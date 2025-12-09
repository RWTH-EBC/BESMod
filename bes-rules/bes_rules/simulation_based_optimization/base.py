import logging
import os
import pathlib
from abc import abstractmethod, ABC
from collections import namedtuple
from itertools import product
from warnings import simplefilter
from functools import reduce
import operator

import openpyxl
import pandas as pd
import numpy as np
from sklearn.gaussian_process.kernels import Matern
from sklearn.gaussian_process import GaussianProcessRegressor
from bayes_opt import acquisition
from ebcpy import Optimizer, DymolaAPI
from bes_rules.configs import InputConfig, OptimizationConfig
from bes_rules.simulation_based_optimization import utils

simplefilter(action="ignore", category=pd.errors.PerformanceWarning)

logger = logging.getLogger(__name__)
logger.setLevel("DEBUG")


class BaseSurrogateBuilder(Optimizer, ABC):

    def __init__(self,
                 working_directory: pathlib.Path,
                 optimization_config: OptimizationConfig,
                 test_only: bool = False
                 ):
        super().__init__(cd=working_directory,
                         bounds=[(var.lower_bound, var.upper_bound) for var in optimization_config.variables])
        self.optimization_config = optimization_config
        self.test_only = test_only
        self._instance_counter = 0

    def _choose_framework(self, framework):
        """
        Adds design of experiments to ebcpy real
        optimization options.

        :param str framework:
            String for selection of the relevant function. Supported options are:
            - scipy_minimize
            - dlib_minimize
            - scipy_differential_evolution
            - pymoo
            - DOE
        """
        if framework.lower() == "doe":
            return self._doe, True
        if framework.lower() == "bayes":
            return self._bayes_optimization, True
        return super()._choose_framework(framework=framework)

    def _bayes_optimization(self, method, n_cpu=1, **kwargs):
        raise NotImplementedError(
            "This function is only available if implemented by child classes, "
            "as it is specific to the application"
        )

    def _target_function_adaptor_to_besrules(self, **kwargs):
        return self.obj(xk=list(kwargs.values()))

    def _create_ffd(self):
        vars = self.optimization_config.variables
        samples = []  # (num_samples, num_variables)
        _product = []
        for var in vars:
            if var.discrete_values:
                _product.append(
                    np.array(
                        [(value - var.lower_bound) / (var.upper_bound - var.lower_bound)
                         for value in var.discrete_values]
                    )
                )
            elif var.discrete_steps > 0:
                _product.append(np.arange(0, 1, var.discrete_steps / (var.upper_bound - var.lower_bound)))
            else:
                _product.append(np.linspace(0, 1, var.levels))
        if self.test_only:
            _product = [(0, 1) for _ in vars]

        for vars_values in product(*_product):
            samples.append(list(vars_values))
        return np.array(samples)

    def _doe(self, method, n_cpu=1, **kwargs):
        """
        Perform Design of Experiments on the given parameter space

        :param method:
        :param n_cpu:
            Number of cpu's to use.
        :param kwargs:
            Further settings required for DOE lib.
        """
        if method == "ffd":
            samples = self._create_ffd()
        else:
            raise ValueError("Given method is not supported!")
        try:
            f_res = self.mp_obj(x=samples)
            if not self.optimization_config.objective_names:
                return  # No result for ffd without explicit objective
            x_min = np.array(samples)[np.argmin(f_res), :]
            f_res_min = np.min(f_res)
            res_tuple = namedtuple("res_tuple", "x fun")
            res = res_tuple(x=x_min, fun=f_res_min)
            return res
        except (KeyboardInterrupt, Exception) as error:
            # pylint: disable=inconsistent-return-statements
            self._handle_error(error)

    def run(self):
        if all([
            self.optimization_config.framework != "doe",
            not self.optimization_config.objective_names
        ]):
            raise ValueError("Must set at least one objective_name for frameworks other than doe!")
        self.optimize(
            framework=self.optimization_config.framework,
            method=self.optimization_config.method,
            **self.optimization_config.solver_settings
        )


class SurrogateBuilder(BaseSurrogateBuilder):
    """
    Class to perform a design optimization
    using dynamic simulations as model.
    """

    def __init__(
            self,
            config: "StudyConfig",
            input_config: InputConfig,
            sim_api: DymolaAPI = None,
            use_mp: bool = True,
            **kwargs
    ):
        from bes_rules.configs import StudyConfig  # Add type hint here to avoid circular import
        self.config: StudyConfig = config
        self.input_config = input_config
        self._log_path = self.create_and_get_log_path(
            base_path=pathlib.Path(self.config.study_path),
            study_name=input_config.get_name()
        )
        self.use_mp = use_mp
        super().__init__(working_directory=self._log_path.parent,
                         optimization_config=self.config.optimization,
                         test_only=self.config.test_only)
        self.sim_api = sim_api

    @staticmethod
    @abstractmethod
    def start_simulation_api(config, **kwargs) -> DymolaAPI:
        raise NotImplementedError

    @staticmethod
    def create_and_get_log_path(base_path: pathlib.Path, study_name: str, create: bool = True):
        path = base_path.joinpath("DesignOptimizationResults", study_name, "DesignOptimizerResults.xlsx")
        if create:
            os.makedirs(path.parent, exist_ok=True)
        return path

    def get_result_names(self):
        return list(set(
            self.config.get_additional_result_names() +
            self.config.simulation.get_result_names() +
            self.sim_api.result_names
        ))

    def get_log_path(self):
        return self._log_path

    def obj(self, xk, *args):
        """Directly use mp_obj function."""
        return self.mp_obj(x=[xk], *args)[0]

    def mp_obj(self, x, *args):
        x = np.array(x)  # If a framework uses lists instead of arrays

        if os.path.exists(self._log_path):
            _log_df = self.load_design_optimization_log(file_path=self._log_path)
            self._instance_counter = max(_log_df.index) + 1
        else:
            _log_df = pd.DataFrame(
                columns=["iterate"]
            ).set_index("iterate")

        # If not bayes, scaling is performed if not specified otherwise
        if self.optimization_config.solver_settings.get(
                "scale_variables",
                self.optimization_config.framework != "bayes"
        ):
            # Descale from (0, 1) to normal bounds:
            x_descaled = utils.descale_variables(config=self.optimization_config, variables=x)
        else:
            x_descaled = x
        x_descaled = utils.apply_constraints(
            config=self.optimization_config,
            variables=x_descaled,
            input_config=self.input_config
        )
        if x_descaled.size == 0:
            logger.error("No variables left to optimize after constraint!")
            return []
        if self.config.test_only and len(x_descaled) > 4:
            x_descaled = x_descaled[:2]
        parameters = [
            utils.get_simulation_input_from_variables(
                values=_x,
                variables=self.optimization_config.variables
            ) for _x in x_descaled
        ]

        # Check if parameters are already in df and results exists:
        _skipped_results = []
        filtered_parameters = []
        _skipped_results_counter = 0
        for idx, single_parameters in enumerate(parameters):
            idx_existing = self.get_idx_of_parameters_in_df(parameters=single_parameters, df=_log_df)
            if idx_existing is not None:  # Parameters already in df
                _skip_simulation, file_path_to_load_later = self._result_file_exists(
                    file_name=self.get_result_file_name_for_idx(idx_existing)
                )
            else:
                _skip_simulation = False

            # Result is in df but not on disk or should be recalculated
            if not _skip_simulation or self.config.simulation.recalculate:
                # Remove existing result
                if idx_existing is not None:
                    self.logger.info(
                        "Parameters %s exist at index %s, "
                        "but recalculate is set. Deleting existing index and file.",
                        single_parameters, idx_existing
                    )
                    # TODO: Possibly remove existing result as index does not match
                    #os.remove(file_path_to_load_later)
                    _log_df = _log_df.drop(idx_existing)
                filtered_parameters.append(single_parameters)
                _skipped_results.append(None)
            else:
                self.logger.info("Parameters %s exist at index %s, skipping...", idx_existing, parameters)
                _skipped_results.append(idx_existing)

        for idx, _ in enumerate(filtered_parameters):
            if self._instance_counter + idx in _log_df.index:
                raise IndexError(
                    "Index to simulate is already in existing data, would override it."
                    "Check the counter, it should start at the bottom of existing data. Something went wrong."
                )

        results, _log_df = self.simulate(parameters=filtered_parameters, log_df=_log_df)
        assert len(results) == len(filtered_parameters), "Length of parameters and results does not match"

        for idx, result_kpis in enumerate(results):

            if result_kpis is None:
                _log_df.loc[self._instance_counter + idx] = np.NAN
            else:
                _log_df.loc[self._instance_counter + idx, result_kpis.keys()] = result_kpis.values()
            _log_df.loc[self._instance_counter + idx, filtered_parameters[idx].keys()] = filtered_parameters[idx].values()

        # Add objectives
        for obj in self.config.objectives:
            _log_df = obj.calc(df=_log_df, input_config=self.input_config)

        # Save log-results as excel:
        self.save_design_optimization_log(file_path=self._log_path, df=_log_df)
        # Duplicate with different name one folder up to allow multiple opens in Excel
        self.save_design_optimization_log(
            file_path=self.config.study_path.joinpath(self.input_config.get_name() + ".xlsx"),
            df=_log_df
        )

        if not self.optimization_config.objective_names:
            self._instance_counter += len(results)
            return []

        objective_names = self.optimization_config.objective_names
        # Calc objective(s):
        weightings = self.optimization_config.weightings
        objective_values = []

        # Merge with skipped results
        result_idxes = [self._instance_counter + idx for idx in range(len(results))]
        result_idxes_merged = utils.result_handling.merge_results(result_idxes, _skipped_results)

        for idx in result_idxes_merged:
            values = []
            for name in objective_names:
                values.append(_log_df.loc[idx, name])
            if self.optimization_config.multi_objective:
                objective_values.append(values)
            else:
                objective_value = 0
                for value, weighting in zip(values, weightings):
                    objective_value += value * weighting
                objective_values.append(objective_value)

        self._instance_counter += len(results)
        return objective_values

    @abstractmethod
    def simulate(self, parameters, log_df):
        raise NotImplementedError

    @abstractmethod
    def _result_file_exists(self, file_name: str):
        raise NotImplementedError

    @staticmethod
    def load_design_optimization_log(file_path: pathlib.Path) -> pd.DataFrame:
        df = pd.read_excel(
            file_path,
            #sheet_name="DesignOptimization",
            index_col=[0],
            header=[0, 1]
        )
        if "OptimizationVariables" in df.columns.get_level_values(0):
            return df
        # Else
        return pd.read_excel(
            file_path,
            #sheet_name="DesignOptimization",
            index_col=[0]
        )

    @staticmethod
    def save_design_optimization_log(file_path: pathlib.Path, df: pd.DataFrame):
        df = df.reset_index()
        df.to_excel(file_path, sheet_name="DesignOptimization", index=False)
        book = openpyxl.load_workbook(file_path)
        sheet = book["DesignOptimization"]
        if "OptimizationVariables" in df.columns.get_level_values(0):
            sheet.delete_rows(3, 1)
        book.save(file_path)

    @staticmethod
    def get_idx_of_parameters_in_df(parameters: dict, df: pd.DataFrame):
        masks = []
        for name, value in parameters.items():
            if name in df.columns:
                masks.append(np.isclose(df.loc[:, name].values, value, atol=1e-5))
            else:
                return None  # Needs to be simulated, parameter not even in df
        parameter_combination_in_df = reduce(operator.and_, masks)
        if not np.any(parameter_combination_in_df):
            return None  # Needs to be simulated
        indexes = df.loc[parameter_combination_in_df].index
        if len(indexes) > 1:
            logger.warning(
                "The parameter combination '%s'"
                "should have been simulated %s times already. Check optimization strategy! "
                "Returning the first index with the associated result index.", parameters, len(indexes)
            )
        return indexes[0]

    @staticmethod
    def get_result_file_name_for_idx(idx):
        raise NotImplementedError

    def _bayes_optimization(self, method, n_cpu=1, **kwargs):
        n_iter = kwargs["n_iter"]
        hyperparameters = kwargs["hyperparameters"][self.optimization_config.objective_names[0]]
        scale_variables = kwargs.get("scale_variables", False)
        assert len(self.optimization_config.objective_names) == 1, "Only SO is supported"

        # Try to handle constraints already here
        if self.optimization_config.constraints:
            new_optimization_config = self.optimization_config.model_copy()
            for constraint in self.optimization_config.constraints:
                if isinstance(constraint, utils.constraints.BivalenceTemperatureGreaterNominalOutdoorAirTemperature):
                    for variable in new_optimization_config.variables:
                        if variable.name == "parameterStudy.TBiv":
                            variable.lower_bound = max(self.input_config.weather.TOda_nominal, variable.lower_bound)
                elif (
                        isinstance(constraint, utils.constraints.HydraulicSeperatorConstraint) and
                        constraint.input_uses_hydraulic_seperator(input_config=self.input_config)
                ):
                    new_variables = []
                    for variable in new_optimization_config.variables:
                        if variable.name != "parameterStudy.VPerQFlow":
                            new_variables.append(variable)
                    new_optimization_config.variables = new_variables
            self.optimization_config = new_optimization_config

        # Get hyperparameters
        optimization_variables = {}
        length_scales = []
        for variable in self.optimization_config.variables:
            if scale_variables:
                optimization_variables[variable.name.replace(".", "_")] = (0, 1)
            else:
                optimization_variables[variable.name.replace(".", "_")] = (
                    variable.lower_bound,
                    variable.upper_bound
                )

            length_scales.append(hyperparameters[variable.name])

        # Setup bayes
        # from bayes_opt import UtilityFunction
        # acquisition_function = UtilityFunction(kind="ei", xi=1e-1)
        acquisition_function = acquisition.ProbabilityOfImprovement(
            xi=0.1,
            exploration_decay=0
        )
        acquisition_function = utils.custom_bayes.ExplorationAcquisition()

        optimizer = utils.custom_bayes.CustomBayesianOptimization(
            f=self._target_function_adaptor_to_besrules,
            pbounds=optimization_variables,
            allow_duplicate_points=kwargs.get("allow_duplicate_points", True),
            acquisition_function=acquisition_function
        )
        kernel = Matern(
            length_scale=length_scales,
            nu=2.5
        )
        optimizer._gp = GaussianProcessRegressor(kernel=kernel, optimizer=None)
        # Include already simulated points
        if os.path.exists(self._log_path):
            self.logger.info("Using initial points from %s for bayes optimization", self._log_path)
            _log_df = self.load_design_optimization_log(file_path=self._log_path)
            variables = np.vstack([
                _log_df.loc[:, variable.name].values
                for variable in self.optimization_config.variables
            ]).T
            if scale_variables:
                # Scale from normal bounds to (0, 1):
                variables = utils.scale_variables(config=self.optimization_config, variables=variables)
            optimizer.points_injected = variables
            init_points = "reload_old_simulations"
        else:
            self.logger.info("Using central_points for bayes optimization")
            init_points = "central_points"
        optimizer.maximize(init_points=init_points, n_iter=n_iter)

        return None  # Result is not important, saved in self.obj anyways
