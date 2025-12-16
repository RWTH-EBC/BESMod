import abc
import os
import shutil
from pathlib import Path
import logging

import numpy as np
import pandas as pd
from agentlib.models.fmu_model import FmuModel
from ebcpy import DymolaAPI, TimeSeriesData
from ebcpy.modelica.simres import loadsim

from bes_rules.simulation_based_optimization.besmod import plot_result
from bes_rules.configs import InputConfig
from bes_rules.simulation_based_optimization import SurrogateBuilder, BESMod
from bes_rules.utils.multiprocessing_ import execute_function_in_parallel
from bes_rules.simulation_based_optimization.utils import result_handling
from bes_rules.objectives.annuity import Annuity

logger = logging.getLogger(__name__)


def get_fmu_model_parameters_and_split_names(
        parameters: dict,
        fmu_path: Path,
        result_names: list
):
    fmu = FmuModel(
        path=fmu_path, extract_fmu=False,
        only_config_variables=False
    )

    for key, value in parameters.items():
        fmu.set_parameter_value(key, value)
    try:
        fmu.system.reset()
    except OSError:
        logger.info("Can't reset FMI Instance due to access violation error. This should not be an issue.")
    fmu.initialize(t_start=0,
                   t_stop=1)
    fmu.do_step(t_start=0, t_sample=1)
    model_parameters = {}
    state_result_names = []
    output_result_names = []
    for variable in fmu.get_state_names():
        if variable in result_names:
            state_result_names.append(variable)
    for variable in fmu.get_output_names():
        if variable in result_names:
            output_result_names.append(variable)
        model_parameters[variable] = fmu.get(variable).value
    for variable in fmu.get_state_names() + fmu.get_parameter_names():
        model_parameters[variable] = fmu.get(variable).value
    missing_variables = set(result_names).difference(state_result_names + output_result_names)
    if missing_variables:
        logger.warning(
            "The following possibly required variables are not in the FMU: %s",
            ", ".join(missing_variables)
        )
    fmu.terminate()
    return model_parameters, state_result_names, output_result_names


def do_not_manipulate_predictions(df: pd.DataFrame) -> pd.DataFrame:
    return df


class BaseSupervisoryControl(SurrogateBuilder, abc.ABC):

    def __init__(
            self,
            config, input_config: InputConfig,
            sim_api: DymolaAPI = None,
            external_control_function: callable = None,
            **kwargs
    ):
        super().__init__(config=config, input_config=input_config, sim_api=sim_api, **kwargs)
        self.external_control_function = external_control_function
        self._predictive_control_options = kwargs["predictive_control_options"]
        self.mapping_predictions = kwargs["mapping_predictions"]
        self.pv_design_name = kwargs.get("pv_design_name", "PVDesignSize")
        self.recalculate_predictions = kwargs.get("recalculate_predictions", True)
        self.mapping_prediction_defaults = kwargs.get("mapping_prediction_defaults", {})

        # Default no manipulation
        self.manipulate_predictions = kwargs.get("manipulate_predictions", do_not_manipulate_predictions)

    @staticmethod
    def start_simulation_api(config, **kwargs):
        config_altered = config.model_copy()
        config_altered.n_cpu = 1
        kwargs["n_cpu"] = 1
        return BESMod.start_simulation_api(
            config=config_altered, **kwargs
        )

    def get_predictive_control_path(self) -> Path:
        path = self.config.study_path.joinpath("PredictiveControlFiles", self.input_config.get_name())
        os.makedirs(path, exist_ok=True)
        return path

    def generate_fmu(self):
        # Create FMU
        self.sim_api.dymola.ExecuteCommand("Advanced.FMI.xmlIgnoreProtected = false;")
        res = self.sim_api.dymola.translateModelFMU(
            modelToOpen=self.sim_api.model_name,
            storeResult=False,
            modelName="BES",
            fmiVersion='2',
            fmiType='all',
            includeSource=False,
            includeImage=0
        )

        if not res:
            msg = "Could not export fmu: %s" % self.sim_api.dymola.getLastErrorLog()
            raise Exception(msg)
        else:
            path = Path(self.sim_api.cd).joinpath(res + ".fmu")
            fmu_path = self.get_predictive_control_path().joinpath(path.name)
            shutil.move(path, fmu_path)
        self.sim_api.dymola.ExecuteCommand("Advanced.FMI.xmlIgnoreProtected = true;")
        return fmu_path

    def _result_file_exists(self, file_name: str):
        """Either mat or hdf+json filepath exists"""
        file_path = os.path.join(self.cd, file_name + ".xlsx")
        _skip_simulation = False
        file_path_to_load_later = None
        if os.path.exists(file_path):
            logger.info("Case %s already simulated. Skipping ..." % file_name)
            file_path_to_load_later = file_path
            _skip_simulation = True
        return _skip_simulation, file_path_to_load_later

    def simulate(self, parameters, log_df):
        fmu_path = self.generate_fmu()
        predictions = self.create_predictions(design_parameter=parameters[0])

        func_kwargs = []
        for idx, design_parameters in enumerate(parameters):
            # Add parameters to df
            log_df.loc[self._instance_counter + idx, design_parameters.keys()] = design_parameters.values()
            path = self.get_log_path().parent.joinpath(self.get_result_file_name_for_idx(idx) + ".xlsx")

            # Size PV accordingly
            design_factor_raw = predictions.loc[:, self.pv_design_name].max()
            if predictions.loc[:, self.pv_design_name].min() != predictions.loc[:, self.pv_design_name].max():
                raise ValueError("Design factor is not constant somehow")
            predictions.loc[:, "P_el_pv"] = (
                    predictions.loc[:, "P_el_pv_raw"] / design_factor_raw *
                    design_parameters.get(self.pv_design_name, 1)
            )
            bes_parameters, state_result_names, output_result_names = get_fmu_model_parameters_and_split_names(
                parameters=design_parameters,
                fmu_path=fmu_path,
                result_names=self.get_result_names()
            )
            bes_parameters = {
                **design_parameters,
                **bes_parameters
            }
            func_kwargs.append(
                self.get_function_inputs_for_parameters(
                    design_parameters=design_parameters,
                    bes_parameters=bes_parameters,
                    fmu_path=fmu_path,
                    save_path=path,
                    predictions=predictions,
                    state_result_names=state_result_names,
                    output_result_names=output_result_names
                )
            )

        results = execute_function_in_parallel(
            func=self.external_control_function,
            func_kwargs=func_kwargs,
            n_cpu=self.config.n_cpu,
            use_mp=self.use_mp
        )

        # Load results
        all_results_last_point = []
        for result, single_parameters in zip(results, parameters):
            df = pd.read_excel(result, index_col=0)

            results_last_point = result_handling.get_kpis_corrected_for_init_period(
                df=df, init_period=self.config.simulation.init_period
            )
            # In AgentLib, all outputs are nan in the first entry, which leads to them
            # not being constant over the whole time. Thus, we skip the first entry
            constant_tsd, tsd = result_handling.split_constant_columns_from_tsd(tsd=df.iloc[1:])
            results_last_point.update(constant_tsd)
            all_results_last_point.append(results_last_point)
            if self.config.simulation.plot_settings:
                try:
                    plot_result(
                        tsd=df,
                        constant_results={**results_last_point, **single_parameters},
                        init_period=self.config.simulation.init_period,
                        result_name=result.stem,
                        save_path=self.get_log_path().parent,
                        plot_settings=self.config.simulation.plot_settings
                    )
                except KeyError as err:
                    logger.error("Could not plot results %s", err)

        return all_results_last_point, log_df

    def create_predictions(self, design_parameter: dict) -> pd.DataFrame:
        df = self.simulate_prediction_case(
            design_parameter=design_parameter
        )
        df = self.manipulate_predictions(df)

        # Add dynamic cost assumptions
        c_grid, c_feed_in = self.input_config.prices.get_c_grid(study_config=self.config)

        if isinstance(c_grid, pd.Series):
            c_sub = c_grid.loc[:df.index[-1]]
            if len(c_sub.index) != len(df.index):
                raise IndexError("Given dynamic prices does not match predictions from Modelica")
            df.loc[:, "c_grid"] = c_sub
        else:
            df.loc[:, "c_grid"] = np.ones(len(df)) * c_grid
        if isinstance(c_feed_in, pd.Series):
            c_sub = c_feed_in.loc[:df.index[-1]]
            if len(c_sub.index) != len(df.index):
                raise IndexError("Given dynamic feed in does not match predictions from Modelica")
            df.loc[:, "c_feed_in"] = c_sub
        else:
            df.loc[:, "c_feed_in"] = np.ones(len(df)) * c_feed_in

        return df

    def simulate_prediction_case(self, design_parameter: dict) -> pd.DataFrame:
        save_path = self.get_predictive_control_path().joinpath("predictions.mat")
        if not os.path.exists(save_path) or self.recalculate_predictions:
            if not self.sim_api.equidistant_output:
                # Change the Simulation Output, to ensure all
                # simulation results have the same array shape.
                # Events can also cause errors in the shape. # TODO: Note assumption booleans are start=false in doc somewhere
                self.sim_api.dymola.experimentSetupOutput(
                    equidistant=True,
                    events=False
                )
                change_output_format = True
            else:
                change_output_format = False
            self.sim_api.dymola.ExecuteCommand("Advanced.StoreProtectedVariables = true;")
            save_path = self.sim_api.simulate(
                parameters=design_parameter,
                result_file_name="predictions",
                savepath="\\\\?\\" + str(save_path.parent),  # Fix long path issue
                return_option="savepath",
                fail_on_error=True
            )
            self.sim_api.dymola.ExecuteCommand("Advanced.StoreProtectedVariables = false;")
            if change_output_format:
                self.sim_api.dymola.experimentSetupOutput(
                    equidistant=False,
                    events=True
                )

        mapping_predictions_to_load = {}
        mapping_predictions_to_add_default = []
        available_variables = loadsim(save_path)
        for variable, mapping in self.mapping_predictions.items():
            if variable in available_variables:
                mapping_predictions_to_load[variable] = mapping
            else:
                if mapping not in self.mapping_prediction_defaults:
                    raise KeyError(
                        f"Mapping {mapping} is not in results and "
                        f"you did not provide a default for it.")
                mapping_predictions_to_add_default.append(mapping)
        df = TimeSeriesData(
            save_path,
            variable_names=list(mapping_predictions_to_load.keys())
        ).to_df()
        df = df.rename(columns=self.mapping_predictions)
        for variable in mapping_predictions_to_add_default:
            df.loc[:, variable] = self.mapping_prediction_defaults[variable]
        return df

    @abc.abstractmethod
    def get_function_inputs_for_parameters(
            self,
            design_parameters: dict,
            bes_parameters: dict,
            fmu_path: Path,
            predictions: pd.DataFrame,
            save_path: Path,
            state_result_names: list,
            output_result_names: list
    ):
        raise NotImplementedError

    @staticmethod
    def get_result_file_name_for_idx(idx):
        return f"Design_{idx}"
