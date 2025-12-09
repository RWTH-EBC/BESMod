import json
import logging
import pathlib
import pickle
from pathlib import Path
from typing import List

from bes_rules import configs, DATA_PATH
from bes_rules.configs import InputConfig
from bes_rules.input_variations import run_input_variations
from examples.use_case_1_design import base_design_optimization


def load_input_configs(save_path: Path):
    with open(save_path.joinpath("manipulated_input_configs.pickle"), "rb") as file:
        input_configs = pickle.load(file)
    # model_dump to include new fields added after saving the pickle.
    return [
        InputConfig(**input_config.model_dump())
        for input_config in input_configs
    ]


def get_inputs_config(
        input_configs: List[InputConfig], modifiers = None
):
    weathers = [input_config.weather for input_config in input_configs]
    buildings = [input_config.building for input_config in input_configs]
    users = [input_config.user for input_config in input_configs]
    dhw_profiles = [input_config.dhw_profile for input_config in input_configs]
    if modifiers is not None:
        return configs.InputsConfig(
            full_factorial=False,
            weathers=weathers,
            buildings=buildings,
            users=users,
            dhw_profiles=dhw_profiles,
            modifiers=modifiers
        )
    return configs.InputsConfig(
        full_factorial=False,
        weathers=weathers,
        buildings=buildings,
        users=users,
        dhw_profiles=dhw_profiles,
    )


def load_best_hyperparameters():
    hyperparameters_path = DATA_PATH.joinpath("default_configs", "best_hyperparameters.json")
    with open(hyperparameters_path, "r") as file:
        return json.load(file)


def get_inputs_config_to_simulate(
        cases_to_simulate: list,
        input_analysis_paths: list,
        modifiers=None
):
    inputs_to_simulate = []
    cases_found_in_inputs = []
    _min = 1000
    for input_analysis_path in input_analysis_paths:
        input_configs = load_input_configs(save_path=input_analysis_path)
        for input_config in input_configs:
            _min = min(input_config.weather.TOda_nominal, _min)
            if input_config.get_name() in cases_to_simulate:
                input_config.building.modify_transfer_system = True  # Was not set in simulate combinations
                inputs_to_simulate.append(input_config)
                cases_found_in_inputs.append(input_config.get_name())
    print("Min TOda", _min)
    missing_cases = set(cases_to_simulate).difference(cases_found_in_inputs)
    if missing_cases:
        raise KeyError(
            f"The following cases are not present in "
            f"input-analysis paths: {' ,'.join(missing_cases)}"
        )
    return get_inputs_config(inputs_to_simulate, modifiers=modifiers)


def run(
        study_name: str,
        cases_to_simulate: list,
        input_analysis_paths: pathlib.Path,
        base_path: pathlib.Path,
        n_cpu: int = 1,
        time_step: int = 900,
        surrogate_builder_kwargs: dict = {},
        surrogate_builder_class=None,
        model: str = "MonoenergeticVitoCal",
        use_bayes: bool = True,
        re_simulated_already_simulated_cases: bool = False
):
    sim_config = base_design_optimization.get_simulation_config(
        model=model,
        time_step=time_step,
        convert_to_hdf_and_delete_mat=True,
        recalculate=False,
        equidistant_output=True
    )

    optimization_config = base_design_optimization.get_optimization_config(
        configs.OptimizationVariable(
            name="parameterStudy.TBiv",
            lower_bound=273.15 - 20,
            upper_bound=278.15 if use_bayes else 279.15,  # For FFD plan to include 5 °C
            discrete_steps=1
        ),
        configs.OptimizationVariable(
            name="parameterStudy.VPerQFlow",
            lower_bound=5,
            upper_bound=50,
            levels=6,
        ),
        use_bayes=use_bayes, hyperparameters=load_best_hyperparameters(), n_iter=25
    )
    if not re_simulated_already_simulated_cases:
        cases_already_simulated = load_cases_already_simulated(path=base_path)
        for case in cases_already_simulated:
            if case in cases_to_simulate:
                logging.info("Skipping case %s, already simulated...", case)
                cases_to_simulate.remove(case)

    inputs_config = get_inputs_config_to_simulate(
        cases_to_simulate=cases_to_simulate, input_analysis_paths=input_analysis_paths
    )
    config = configs.StudyConfig(
        base_path=base_path,
        n_cpu=n_cpu,
        name=study_name,
        simulation=sim_config,
        optimization=optimization_config,
        inputs=inputs_config,
        test_only=False
    )
    run_input_variations(
        config=config, run_inputs_in_parallel=use_bayes,
        surrogate_builder_class=surrogate_builder_class,
        **surrogate_builder_kwargs
    )
    add_cases_already_simulated(simulated_cases=cases_to_simulate, path=base_path)


def add_cases_already_simulated(simulated_cases: list, path: pathlib.Path):
    cases_already_simulated = load_cases_already_simulated(path=path)
    with open(path.joinpath("cases_already_simulated.json"), "w") as file:
        json.dump(cases_already_simulated + list(simulated_cases), file, indent=2)


def load_cases_already_simulated(path: pathlib.Path):
    try:
        with open(path.joinpath("cases_already_simulated.json"), "r") as file:
            cases_already_simulated = json.load(file)
    except FileNotFoundError:
        logging.warning("No cases_already_simulated found in path %s", path)
        cases_already_simulated = []
    return cases_already_simulated
