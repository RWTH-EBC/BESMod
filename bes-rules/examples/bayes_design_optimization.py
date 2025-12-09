import json
import logging

from bes_rules import configs, STARTUP_BESMOD_MOS, RESULTS_FOLDER
from bes_rules.input_variations import InputVariations
from bes_rules.boundary_conditions import weather, building
from bes_rules.simulation_based_optimization.utils import constraints


def run_optimization(test_only=False):
    sim_config = configs.SimulationConfig(
        startup_mos=STARTUP_BESMOD_MOS,
        model_name="BESMod.BESRules.DesignOptimization.MonoenergeticVitoCal",
        sim_setup=dict(stop_time=86400 * 365, output_interval=900),
        result_names=[],
        type="Dymola",
        recalculate=False,
        show_window=True,
        debug=False,
        extract_results_during_optimization=True,
        convert_to_hdf_and_delete_mat=True
    )

    with open(RESULTS_FOLDER.joinpath("BayesHyperparameters", "best_hyperparameters.json"), "r") as file:
        hyperparameters = json.load(file)

    ## Optimization
    optimization_config = configs.OptimizationConfig(
        framework="bayes",
        method="Not implemented",
        solver_settings={"allow_duplicate_points": False, "hyperparameters": hyperparameters, "n_iter": 20},
        objective_names=["SCOP_Sys"],
        constraints=[constraints.BivalenceTemperatureGreaterNominalOutdoorAirTemperature()],
        variables=[
            configs.OptimizationVariable(
                name="parameterStudy.TBiv",
                lower_bound=273.15 - 16,
                upper_bound=278.15
            ),
            configs.OptimizationVariable(
                name="parameterStudy.VPerQFlow",
                lower_bound=5,
                upper_bound=150
            )
        ],
    )

    weathers = weather.get_weather_configs_by_names(region_names=["Bremerhaven"])
    buildings = building.get_building_configs_by_name(building_names=["Retrofit1918"])

    inputs_config = configs.InputsConfig(
        weathers=weathers,
        buildings=buildings,
        dhw_profiles=[{"profile": "M"}],
    )

    config = configs.StudyConfig(
        base_path=RESULTS_FOLDER.joinpath("bayes_optimization_test"),
        n_cpu=1,
        name="BayesOptimization",
        simulation=sim_config,
        optimization=optimization_config,
        inputs=inputs_config,
        test_only=test_only
    )
    DESOPT = InputVariations(config=config)
    DESOPT.run()


if __name__ == '__main__':
    logging.basicConfig(level="INFO")
    run_optimization(test_only=False)
