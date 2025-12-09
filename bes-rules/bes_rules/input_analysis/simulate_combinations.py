import datetime
import os
import pickle
import shutil
from pathlib import Path
import logging

from ebcpy import TimeSeriesData
from ebcpy.preprocessing import convert_index_to_datetime_index

from bes_rules import configs, STARTUP_BESMOD_MOS
from bes_rules.boundary_conditions import weather, building
from bes_rules.configs.simulation import start_api
from bes_rules.input_analysis.heat_load_estimation import VARIABLE_NAMES
from bes_rules.utils import notify


def convert_to_datetime_and_parquet(mat_result_file, first_day_of_year, init_period, variable_names):
    df = TimeSeriesData(mat_result_file, variable_names=variable_names).to_df().loc[init_period:]
    from ebcpy.preprocessing import convert_index_to_datetime_index
    df = convert_index_to_datetime_index(df, origin=first_day_of_year)
    df_path = Path(mat_result_file).with_suffix(".parquet")
    df.to_parquet(
        df_path,
        engine="fastparquet",
        compression=None,
        index=True
    )
    os.remove(mat_result_file)
    return df_path


def empty_postprocessing(mat_result, **_kwargs):
    return mat_result


def simulate_all_combinations(
        study_path: Path,
        n_cpu: int,
        inputs_config: configs.InputsConfig,
        remove_mats: bool = True,
        variable_names: list = None,
        store_tsd_in_pickle: bool = False,
        save_path: Path = None,
        model_name: str = None,
        study_name: str = "HeatDemandSimulationResults"
):
    if save_path is None:
        save_path = study_path
    if model_name is None:
        model_name = "BESMod.Systems.BaseClasses.TEASERExport.PartialTEASERHeatLoadCalculation"
    if variable_names is None:
        variable_names = VARIABLE_NAMES
    import sys

    def notify_on_exception(exc_type, exc_value, exc_traceback):
        error_message = (f"An error occurred in study: "
                         f"{exc_type.__name__}: {exc_value}")
        notify.notify_telegram(error_message)
        sys.__excepthook__(exc_type, exc_value, exc_traceback)

    # Replace the default exception handler
    sys.excepthook = notify_on_exception

    sim_config = configs.SimulationConfig(
        startup_mos=STARTUP_BESMOD_MOS,
        model_name=model_name,
        sim_setup=dict(stop_time=86400 * 365, output_interval=900),
        result_names=[],
        init_period=86400 * 2,
        type="Dymola",
        recalculate=False,
        equidistant_output=True,
        show_window=True,
        debug=True,
        extract_results_during_optimization=True,
        convert_to_hdf_and_delete_mat=True,
        dymola_api_kwargs={"time_delay_between_starts": 5, "extract_variables": False}
    )
    inputs_config.generate_files(
        path=study_path,
        name="HeatDemandSimulations"
    )

    input_permutations = inputs_config.get_permutations()
    model_names = [
        input_config.get_modelica_modifier(model_name=model_name, with_custom_modifier=False)
        for input_config in input_permutations
    ]

    from bes_rules.input_variations import generate_modelica_package
    os.makedirs(save_path, exist_ok=True)
    explicit_model_names, new_package = generate_modelica_package(
        save_path=save_path,
        modifiers=model_names,
        names=[input_config.get_name() for input_config in input_permutations]
    )

    sim_api = start_api(
        config=sim_config,
        working_directory=study_path.joinpath("00_DymolaWorkDir"),
        n_cpu=n_cpu,
        additional_packages=inputs_config.get_additional_packages() + [new_package],
        save_path_mos=study_path.joinpath("startup_study.mos")
    )

    first_day_of_year = datetime.datetime(2015, 1, 1, 0, 0)

    if not store_tsd_in_pickle:
        postprocess_mat_result = convert_to_datetime_and_parquet
        kwargs_postprocessing = dict(
            init_period=sim_config.init_period,
            variable_names=variable_names,
            first_day_of_year=first_day_of_year
        )
    else:
        postprocess_mat_result = empty_postprocessing
        kwargs_postprocessing = {}

    result_file_names = [str(i) for i in range(len(model_names))]
    result_paths = sim_api.simulate(
        model_names=explicit_model_names,
        result_file_name=result_file_names,
        return_option="savepath",
        savepath=save_path.joinpath("SimulationResults"),
        postprocess_mat_result=postprocess_mat_result,
        kwargs_postprocessing=kwargs_postprocessing
    )

    results_extracted = []
    for result_path, input_config in zip(result_paths, input_permutations):
        if store_tsd_in_pickle:
            df = TimeSeriesData(result_path, variable_names=variable_names).to_df().loc[sim_config.init_period:]
            df = convert_index_to_datetime_index(df, origin=first_day_of_year)
            if remove_mats:
                os.remove(result_path)
        else:
            df = result_path
        results_extracted.append({
            "input_config": input_config,
            "df": df
        })
    if remove_mats and store_tsd_in_pickle:
        shutil.rmtree(save_path.joinpath("SimulationResults"))
    pickle_path = save_path.joinpath(f"{study_name}.pickle")
    with open(pickle_path, "wb") as file:
        pickle.dump(results_extracted, file)
    logging.info("Results stored under %s", pickle_path)
    notify.notify_telegram(f"Study {study_name} is finished.")
    reproduction_kwargs = dict(
        title=study_name,
        path=save_path,
        files=[],
        log_message="Automated script"
    )
    sim_api.save_for_reproduction(
        save_total_model=False,
        export_fmu=False,
        **reproduction_kwargs
    )
    sim_api.close()


def simulate_cases_heat_load_estimation(study_path: Path, n_cpu: int):
    weathers = weather.get_all_weather_configs()
    buildings = []
    for use_normative_infiltration in [True, False]:
        building_config_kwargs = dict(
            use_normative_infiltration=use_normative_infiltration,
            use_led=False
        )
        buildings.extend(building.get_all_tabula_sfh_buildings(**building_config_kwargs))
    users = [
        configs.inputs.UserProfile(night_set_back=0, with_persons=False, with_electrical_gains=False),
        configs.inputs.UserProfile(night_set_back=2, with_persons=True, with_electrical_gains=True),
        configs.inputs.UserProfile(night_set_back=3, with_persons=True, with_electrical_gains=True),
    ]
    inputs_config = configs.InputsConfig(
        weathers=weathers,
        buildings=buildings,
        users=users,
        dhw_profiles=[{"profile": "NoDHW"}],
    )
    simulate_all_combinations(
        study_path=study_path, n_cpu=n_cpu,
        inputs_config=inputs_config
    )


if __name__ == '__main__':
    logging.basicConfig(level="INFO")
    from bes_rules import RESULTS_FOLDER

    PATH = RESULTS_FOLDER.joinpath("heat_load_retrofit_options")
    simulate_cases_heat_load_estimation(PATH, n_cpu=6)
