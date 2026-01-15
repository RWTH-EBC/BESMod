import json
import os
import logging
import pathlib

import pandas as pd
from ebcpy import TimeSeriesData
import numpy as np

from .base import SurrogateBuilder
from bes_rules.plotting.important_variables import plot_important_variables
from bes_rules.configs.simulation import start_api
from bes_rules.configs import StudyConfig
from bes_rules.simulation_based_optimization.utils import result_handling
from bes_rules.utils import multiprocessing_ as bes_rules_mp


logger = logging.getLogger(__name__)
logger.setLevel("DEBUG")


class BESMod(SurrogateBuilder):

    @staticmethod
    def start_simulation_api(config, **kwargs):
        working_directory = config.base_path.joinpath("00_DymolaWorkDir")
        if kwargs.get("worker") is not None:
            working_directory = working_directory.joinpath(f"worker_{kwargs['worker']}")
        return start_api(
            config=config.simulation,
            working_directory=working_directory,
            n_cpu=kwargs.get("n_cpu", config.n_cpu),  # Overwrite for case of mp on input level
            additional_packages=config.inputs.get_additional_packages() + kwargs.get("extra_packages", []),
            save_path_mos=config.study_path.joinpath("startup_simulation_study.mos")
        )

    @staticmethod
    def get_result_file_name_for_idx(idx):
        return f"iterate_{idx}"

    def simulate(self, parameters, log_df):
        result_file_names = []
        for col in ["result_filename", "model_name"]:
            if col not in log_df:
                log_df[col] = ""
            log_df[col] = log_df[col].astype("str")

        for idx, single_parameters in enumerate(parameters):
            idx_to_use = self._instance_counter + idx
            file_name_to_use = self.get_result_file_name_for_idx(idx_to_use)
            result_file_names.append(file_name_to_use)
            file_path_mat = self._log_path.parent.joinpath(file_name_to_use + ".mat")
            file_path_hdf = self._log_path.parent.joinpath(file_name_to_use + ".hdf")
            log_df.loc[idx_to_use, "result_filename"] = (
                file_path_hdf if self.config.simulation.convert_to_hdf_and_delete_mat
                else file_path_mat
            )
            log_df.loc[idx_to_use, "model_name"] = self.config.simulation.model_name.replace("\n", "")
            log_df.loc[idx_to_use, single_parameters.keys()] = single_parameters.values()

        logger.info(f"Simulating {len(parameters)} combinations")
        results = self.sim_api.simulate(
            parameters=parameters,
            result_file_name=result_file_names,
            savepath="\\\\?\\" + str(self.cd),  # Fix long path issue
            return_option="savepath",
            fail_on_error=False
        )
        if len(result_file_names) == 1:
            results = [results]
        logger.info(f"Finished simulation of {len(parameters)} combinations")
        if not self.config.simulation.extract_results_during_optimization:
            return [None] * len(parameters), log_df

        logger.info("Extracting time-series results")
        # Result analysis section.
        func_kwargs = [
            dict(
                config=self.config,
                result=result,
                result_names=self.get_result_names(),
                parameters=single_parameters
            ) for result, single_parameters in zip(results, parameters)
        ]
        memory_per_process_gb = 4
        available_memory_gb = bes_rules_mp.get_available_ram()
        if available_memory_gb is None:
            n_cpu = 1
        else:
            n_cpu = min(self.config.n_cpu, int(available_memory_gb / memory_per_process_gb))
        if not self.config.simulation.equidistant_output:
            n_cpu = 1  # Idea is that with events, it is hard to predict how much memory one has
        results_last_points = bes_rules_mp.execute_function_in_parallel(
            func=extract_results_and_possibly_plot,
            func_kwargs=func_kwargs,
            n_cpu=n_cpu,
            use_mp=self.use_mp,
            notifier=logger.debug,
            percentage_when_to_message=20,
            #memory_per_process_gb=memory_per_process_gb
        )

        return results_last_points, log_df

    def _result_file_exists(self, file_name: str):
        """Either mat or hdf+json filepath exists"""
        file_path_mat = os.path.join(self.cd, file_name + ".mat")
        file_path_hdf = os.path.join(self.cd, file_name + ".hdf")
        file_path_json = os.path.join(self.cd, file_name + ".json")
        _skip_simulation = False
        file_path_to_load_later = None
        if os.path.exists(file_path_hdf) and os.path.exists(file_path_json):
            logger.info("Case %s already simulated. Skipping ..." % file_name)
            file_path_to_load_later = file_path_hdf
            _skip_simulation = True
        if os.path.exists(file_path_mat):
            logger.info("Case %s already simulated. Skipping ..." % file_name)
            file_path_to_load_later = file_path_mat
            _skip_simulation = True
        return _skip_simulation, file_path_to_load_later


def extract_results_and_possibly_plot(
        result: str,
        result_names: list,
        config: StudyConfig,
        parameters: dict
):
    if result is None:
        return None
    result_name = pathlib.Path(result).name
    result_path = pathlib.Path(result)
    try:
        df, results_last_point = _extract_tsd_results(
            path=result_path,
            result_names=result_names,
            convert_to_hdf_and_delete_mat=config.simulation.convert_to_hdf_and_delete_mat,
            init_period=config.simulation.init_period
        )
    except np.core._exceptions._ArrayMemoryError as err:
        logger.error("Could not read .mat file due to memory-error: %s", err)
        return None  # For DOE, no obj is required.

    if config.simulation.plot_settings:
        plot_result(
            tsd=df,
            constant_results={**results_last_point, **parameters},  # Enable plot with TBiv
            init_period=config.simulation.init_period,
            save_path=result_path.parent,
            result_name=result_name.replace(".mat", ""),
            plot_settings=config.simulation.plot_settings
        )

    # Part for time-series dependent objective calculation, e.g. grid interaction:
    time_series_kpis = {}
    for obj in config.time_series_dependent_objectives:
        time_series_kpis.update(obj.calc_tsd(
            df=df,
            time_step=config.simulation.sim_setup["output_interval"],
            results_last_point=results_last_point
        ))
    time_series_kpi_names = list(time_series_kpis.keys())
    intersection_names = set(time_series_kpi_names).intersection(result_names)
    if intersection_names:
        raise KeyError("Duplicate objective names: ", " ,".join(list(intersection_names)))
    results_last_point.update(time_series_kpis)
    logger.info("Extracted time-series results")

    return results_last_point


def _extract_tsd_results(
        path: pathlib.Path,
        result_names: list,
        convert_to_hdf_and_delete_mat: bool,
        init_period: float
):
    logger.debug("Reading file %s", path.name)
    result_names = list(set(result_names))
    result_names = [result_name for result_name in result_names if result_name]  # trim ""
    if path.suffix == ".hdf":
        # In this case, results were already extracted and separated.
        with open(path.parent.joinpath(path.stem + ".json"), "r") as file:
            results_last_point = json.load(file)
        tsd = TimeSeriesData(path).to_df()
        return tsd, results_last_point
    logger.debug("Read file %s", path.name)
    integrals, trajectories = result_handling.split_variable_names_into_integrals_and_trajectories(result_names)
    # Load only integrals, time-series-information only required in here
    tsd_integrals = _load_mat(path=path, variable_names=integrals)
    results_last_point = result_handling.get_kpis_corrected_for_init_period(
        df=tsd_integrals, init_period=init_period
    )
    del tsd_integrals
    # Load only trajectories, time-series-information required for plotting and time-series kpis
    tsd = _load_mat(path=path, variable_names=trajectories)
    constant_tsd, tsd = result_handling.split_constant_columns_from_tsd(tsd=tsd)
    results_last_point.update(constant_tsd)

    # Cast float as some values are np float which causes json errors
    results_last_point = {k: float(v) for k, v in results_last_point.items()}
    with open(path.parent.joinpath(path.stem + ".json"), "w") as file:
        json.dump(results_last_point, file, indent=2)

    # Only care for tsd after init_period
    tsd = tsd.loc[init_period:]
    tsd.index -= tsd.index[0]  # Reset to 0
    if convert_to_hdf_and_delete_mat and path.suffix != ".hdf":
        tsd.to_hdf(
            path.parent.joinpath(path.stem + ".hdf"),
            key="DesignOptimization"
        )
        os.remove(path)  # Delete .mat file to free space

    return tsd, results_last_point


def _load_mat(path: pathlib.Path, variable_names: list):
    try:
        return TimeSeriesData(path, variable_names=variable_names).to_df()
    except KeyError as key_err:
        logger.info("Could not find variables in .mat file: %s", key_err)
        from ebcpy.modelica.simres import loadsim
        available_variables = loadsim(path)
        variable_names = list(set(available_variables.keys()).intersection(variable_names))
        return TimeSeriesData(path, variable_names=variable_names).to_df()


def plot_result(tsd, constant_results, init_period, result_name, save_path, plot_settings):
    plot_important_variables(
        save_path=save_path.joinpath("plots_time", result_name),
        x_variable="time",
        scatter=False,
        tsd=tsd,
        init_period=init_period,
        constant_results=constant_results,
        **plot_settings
    )
    plot_important_variables(
        tsd=tsd,
        save_path=save_path.joinpath("plots_scatter", result_name),
        x_variable="outputs.weather.TDryBul",
        scatter=True,
        init_period=init_period,
        constant_results=constant_results,
        **plot_settings
    )
