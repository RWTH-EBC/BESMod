import logging

from bes_rules import configs, STARTUP_BESMOD_MOS, RESULTS_FOLDER
from bes_rules.input_variations import run_input_variations
from bes_rules.boundary_conditions import weather, building
from bes_rules.simulation_based_optimization.utils import constraints


def run_optimization(test_only=False):

    sim_config = configs.SimulationConfig(
        startup_mos=STARTUP_BESMOD_MOS,
        model_name="BESMod.BESRules.DesignOptimization.MonoenergeticVitoCal",
        sim_setup=dict(stop_time=86400 * 30, output_interval=600),
        show_window=True,
        debug=True,
        equidistant_output=True,
        dymola_api_kwargs={"time_delay_between_starts": 5},
        extract_results_during_optimization=True,
        convert_to_hdf_and_delete_mat=True,
        recalculate=True,
    )

    ## Optimization
    optimization_config = configs.OptimizationConfig(
        framework="doe",
        method="ffd",
        constraints=[constraints.BivalenceTemperatureGreaterNominalOutdoorAirTemperature()],
        variables=[
            configs.OptimizationVariable(
                name="parameterStudy.TBiv",
                lower_bound=273.15 - 16,
                upper_bound=278.15,
                levels=8
            ),
            configs.OptimizationVariable(
                name="parameterStudy.VPerQFlow",
                lower_bound=12,
                upper_bound=35,
                levels=3
            )
        ],
    )

    weathers = weather.get_weather_configs_by_names(region_names=["Potsdam"])
    buildings = building.get_building_configs_by_name(building_names=["Retrofit1918", "NoRetrofit1983"])

    inputs_config = configs.InputsConfig(
        weathers=weathers,
        buildings=buildings,
        dhw_profiles=[{"profile": "M"}],
    )

    config = configs.StudyConfig(
        base_path=RESULTS_FOLDER.joinpath("TBivOptimization"),
        n_cpu=1,
        name="TestzoneNewDev",
        simulation=sim_config,
        optimization=optimization_config,
        inputs=inputs_config,
        test_only=test_only
    )
    run_input_variations(config=config, run_inputs_in_parallel=False)


if __name__ == '__main__':
    logging.basicConfig(level="INFO")
    run_optimization(test_only=False)
