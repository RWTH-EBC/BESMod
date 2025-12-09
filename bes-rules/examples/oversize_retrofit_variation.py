import logging
import os
import shutil

from bes_rules import boundary_conditions
from bes_rules import configs, STARTUP_BESMOD_MOS, RESULTS_FOLDER
from bes_rules.input_variations import run_input_variations


def run_optimization(test_only=False):

    sim_config = configs.SimulationConfig(
        startup_mos=STARTUP_BESMOD_MOS,
        model_name="BESMod.BESRules.DesignOptimization.MonoenergeticVitoCal",
        sim_setup=dict(stop_time=86400 * 365, output_interval=600),
        result_names=[],
        type="Dymola",
        recalculate=False,
        show_window=True,
        debug=True,
        extract_results_during_optimization=True,
        convert_to_hdf_and_delete_mat=True,
        dymola_api_kwargs={"time_delay_between_starts": 5}
    )

    ## Optimization
    optimization_config = configs.OptimizationConfig(
        framework="doe",
        method="ffd",
        variables=[
            configs.OptimizationVariable(
                name="parameterStudy.TBiv",
                lower_bound=273.15 - 20,
                upper_bound=273.15 + 15,
                levels=20
            ),
            configs.OptimizationVariable(
                name="parameterStudy.VPerQFlow",
                lower_bound=23.5,
                upper_bound=23.5,
                levels=1
            )
        ],
    )

    weathers = boundary_conditions.weather.get_weather_configs_by_names(region_names=["Potsdam"])
    building_configs = boundary_conditions.building.get_all_tabula_sfh_buildings(as_dict=True)
    building_configs = [
        building_configs["1950_standard"],
        #building_configs["1970_standard"],
        building_configs["1994_standard"]
    ]
    building_configs = boundary_conditions.building.generate_buildings_for_all_element_combinations(
        building_configs=building_configs,
        elements=[
            "outer_walls",
            "windows",
            "rooftops",
        ],
        retrofit_choices=None
    )
    for building in building_configs:
        building.modify_transfer_system = True

    inputs_config = configs.InputsConfig(
        weathers=weathers,
        buildings=building_configs,
        dhw_profiles=[{"profile": "M"}],
    )

    config = configs.StudyConfig(
        base_path=RESULTS_FOLDER.joinpath("TBivOptimization"),
        n_cpu=20,
        name="OversizeRetrofitOptionsExtrapolationAll",
        simulation=sim_config,
        optimization=optimization_config,
        inputs=inputs_config,
        test_only=test_only
    )
    run_input_variations(config=config, run_inputs_in_parallel=True)


def copy_files():
    iterate = 14
    path = RESULTS_FOLDER.joinpath("TBivOptimization", "OversizeRetrofitOptions", "DesignOptimizationResults")
    dst_folder = RESULTS_FOLDER.joinpath("TBivOptimization", "OversizeRetrofitOptions", "for_nico")
    os.makedirs(dst_folder, exist_ok=True)
    for folder in os.listdir(path):
        shutil.copy(
            path.joinpath(path.joinpath(folder, f"iterate_{iterate}.hdf")),
            dst_folder.joinpath(f"{folder}.hdf"),
        )



if __name__ == '__main__':
    logging.basicConfig(level="INFO")
    #run_optimization(test_only=False)

