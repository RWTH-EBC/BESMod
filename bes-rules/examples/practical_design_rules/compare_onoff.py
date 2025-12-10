import logging

from bes_rules import configs, RESULTS_FOLDER
from bes_rules.input_variations import run_input_variations
from bes_rules.configs.inputs import custom_modifiers
import base_design_optimization


def get_inputs_config_with_added_modifiers(
        inverter_uses_storage: bool,
        no_minimal_compressor_speed: bool,
        with_start_losses: bool,
        only_inverter: bool = False,
        only_on_off: bool = False,
        heating_curve_offset: bool = False
):
    if inverter_uses_storage:
        inverter_modifier = [custom_modifiers.NoModifier()]
    else:
        inverter_modifier = [custom_modifiers.HydraulicSeperatorModifier()]
    if no_minimal_compressor_speed:
        inverter_modifier.append(custom_modifiers.NoMinimalCompressorSpeed())

    if with_start_losses:
        modifiers = [
            [custom_modifiers.OnOffControlModifier(), custom_modifiers.StartLossModifier()],
            inverter_modifier + [custom_modifiers.StartLossModifier()]
        ]
    else:
        modifiers = [
            [custom_modifiers.OnOffControlModifier(), custom_modifiers.N30LayerStorage()],
            inverter_modifier
        ]
    if only_inverter:
        modifiers = [modifiers[1]]
    if only_on_off:
        modifiers = [modifiers[0]]

    if heating_curve_offset:
        modifiers = [mod + [custom_modifiers.HeatingCurveOffsetModifier()] for mod in modifiers]

    return base_design_optimization.get_inputs_config_to_simulate(modifiers=modifiers)


def run(
        study_name: str = "inverter_vs_onoff_hydSep",
        n_cpu: int = 1,
        time_step: int = 600,
        surrogate_builder_kwargs: dict = {},
        surrogate_builder_class=None,
        model: str = "MonoenergeticVitoCal",
        with_start_losses: bool = False,
        inverter_uses_storage: bool = False,
        no_minimal_compressor_speed: bool = False
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
            upper_bound=278.15,
            discrete_steps=2
        ),
        configs.OptimizationVariable(
            name="parameterStudy.VPerQFlow",
            lower_bound=5,
            upper_bound=50,
            levels=6
        )
    )

    inputs_config = get_inputs_config_with_added_modifiers(
        inverter_uses_storage=inverter_uses_storage, only_on_off=True,
        no_minimal_compressor_speed=no_minimal_compressor_speed, with_start_losses=with_start_losses
    )
    config = configs.StudyConfig(
        base_path=RESULTS_FOLDER.joinpath("UseCase_TBivAndV"),
        n_cpu=n_cpu,
        name=study_name,
        simulation=sim_config,
        optimization=optimization_config,
        inputs=inputs_config,
        test_only=False
    )
    run_input_variations(
        config=config, run_inputs_in_parallel=False,
        surrogate_builder_class=surrogate_builder_class,
        **surrogate_builder_kwargs
    )


if __name__ == '__main__':
    logging.basicConfig(level="INFO")
    STUDY_NAME = "test_besmod"
    run(STUDY_NAME, n_cpu=1, with_start_losses=False, inverter_uses_storage=True)
