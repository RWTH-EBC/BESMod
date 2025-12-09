import logging

import pandas as pd

from bes_rules import configs, RESULTS_FOLDER
from bes_rules.input_variations import run_input_variations
from bes_rules.configs.inputs import custom_modifiers
from examples.use_case_1_design import simulate_oed_cases, PATH_OED_BOTH, base_design_optimization, plotting


def get_cases_to_simulate():
    return [
        "TRY2015_541817120824_Jahr_B1918_standard_o0w2r1g0_SingleDwelling_M_0K-Per-IntGai",
        "TRY2015_474856110632_Jahr_B1950_standard_o1w2r0g2_SingleDwelling_NoDHW_0K-Per-IntGai",
        "TRY2045_495193085486_Somm_B2015_standard_o0w0r0g0_SingleDwelling_NoDHW_0K-Per-IntGai",
        "TRY2015_504312129522_Wint_B1948_standard_o0w0r0g0_SingleDwelling_M_0K-Per-IntGai"
    ]


def get_optimization_config(compare_to_mpc: bool, only_one_hp_size: bool = False):
    if compare_to_mpc:
        return base_design_optimization.get_optimization_config(
            configs.OptimizationVariable(
                name="parameterStudy.TBiv",
                lower_bound=261.15 if only_one_hp_size else 261.15,
                upper_bound=261.15 - 6 if only_one_hp_size else 273.15,
                levels=1 if only_one_hp_size else 3
            ),
            configs.OptimizationVariable(
                name="parameterStudy.VPerQFlow",
                lower_bound=5,
                upper_bound=50,
                levels=3
            )
        )
    return base_design_optimization.get_optimization_config(
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


def get_input_analysis_paths(oed_iter, path_oed):
    all_paths = []
    for i in range(oed_iter+1):
        if i == 0:
            all_paths.append(path_oed.joinpath("verification_with_mean", f"corner_points", "input_analysis"))
        else:
            all_paths.append(path_oed.joinpath("verification_with_mean", f"iter_{i}", "input_analysis"))
    return all_paths


def get_inputs_config(
        inverter_uses_storage: bool,
        no_minimal_compressor_speed: bool,
        with_start_losses: bool,
        only_inverter: bool = False,
        cases_to_simulate: list = None,
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

    # Mean points from central design, average with high QDem or GTZ, once with and once without DHW
    # And most extreme cases.
    if cases_to_simulate is None:
        cases_to_simulate = get_cases_to_simulate()
    inputs_config_corner = simulate_oed_cases.get_inputs_config_to_simulate(
        cases_to_simulate=cases_to_simulate,
        input_analysis_paths=get_input_analysis_paths(oed_iter=0, path_oed=PATH_OED_BOTH)
    )
    inputs_config = base_design_optimization.extend_input_configs_with_modifiers(
        inputs_config_corner=inputs_config_corner,
        modifiers=modifiers,
        is_evu=False
    )
    return inputs_config


def run(
        study_name: str = "inverter_vs_onoff_hydSep",
        n_cpu: int = 1,
        time_step: int = 600,
        surrogate_builder_kwargs: dict = {},
        surrogate_builder_class=None,
        model: str = "MonoenergeticVitoCal",
        with_start_losses: bool = False,
        inverter_uses_storage: bool = False,
        compare_to_mpc: bool = False,
        no_minimal_compressor_speed: bool = False
):
    sim_config = base_design_optimization.get_simulation_config(
        model=model,
        time_step=time_step,
        convert_to_hdf_and_delete_mat=True,
        recalculate=False,
        equidistant_output=True
    )
    optimization_config = get_optimization_config(compare_to_mpc)
    inputs_config = get_inputs_config(
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


def run_mpc():
    variables = {
        "input_names": [
            "TDHWSet",
            "TBufSet",
            "actExtBufCtrl",
            "actExtDHWCtrl"
        ],
        "state_names": [
            "outputs.hydraulic.tra.opening[1]",
            "hydraulic.generation.eleHea.Q_flow_nominal"
            "scalingFactor",
            "QPriAtTOdaNom_flow_nominal",
            "hydraulic.generation.m_flow_nominal[1]",
        ],
        "output_names": [
            "hydraulic.control.sigBusDistr.TStoBufTopMea",
            "hydraulic.control.sigBusDistr.TStoDHWTopMea",
            "outputs.building.TZone[1]"
        ]
    }

    mapping_predictions = {
        "electrical.generation.outBusGen.PElePV.value": "P_el_pv_raw",
        "parameterStudy.f_design": "PVDesignSize",
        "outputs.weather.TDryBul": "T_Air",
        "hydraulic.control.buiAndDHWCtr.TSetBuiSup.TSet": "THeaCur",
        "outputs.DHW.Q_flow.value": "Q_DHW_Dem",
        "outputs.building.eneBal[1].traGain.value": "Q_Hou_Dem",
        "userProfiles.useProBus.absIntGaiRad": "internal_gains_radiative",
        "userProfiles.useProBus.absIntGaiConv": "internal_gains_convective"
    }

    def manipulate_predictions(df: pd.DataFrame):
        df.loc[:, "P_El_Dem"] = (
                df.loc[:, "internal_gains_convective"] +
                df.loc[:, "internal_gains_radiative"]
        )
        return df

    from bes_rules.simulation_based_optimization.milp import MILPBasedOptimizer, run_milp_model
    from bes_rules.boundary_conditions.prices import load_dynamic_electricity_prices
    time_step = 900
    run(
        model="MonoenergeticVitoCal_MPC",
        time_step=time_step,
        surrogate_builder_class=MILPBasedOptimizer,
        surrogate_builder_kwargs=dict(
            predictive_control_function=run_milp_model,
            predictive_control_options={
                "with_dhw": False,
                "control_horizon": 4,
                "minimal_part_load_heat_pump": 1,
                "closed_loop": True
            },
            variables=variables,
            manipulate_predictions=manipulate_predictions,
            mapping_predictions=mapping_predictions,
            mapping_prediction_defaults={
                "P_el_pv_raw": 0,
                "PVDesignSize": 1,
            },
            c_grid=load_dynamic_electricity_prices(year=2023, time_step=time_step, init_period=86400 * 2),
        ),
        study_name="on_off_milp"
    )


def calculate_with_dynamic_prices(study_name: str):
    from bes_rules.boundary_conditions.prices import calculate_operating_costs_with_dynamic_prices
    study_path = RESULTS_FOLDER.joinpath("UseCase_TBivAndV", study_name)
    study_config = configs.StudyConfig.from_json(study_path.joinpath("study_config.json"))
    calculate_operating_costs_with_dynamic_prices(
        study_config=study_config,
        year=2023
    )


def create_surrogate_plots(study_name):
    plotting.plot_mismatch_due_to_bad_control(RESULTS_FOLDER.joinpath("UseCase_TBivAndV", study_name))
    plotting.plot_bayes_surrogate_for_simulations(
        RESULTS_FOLDER.joinpath("UseCase_TBivAndV", study_name),
        just_end=True
    )


def plot_for_thesis(study_name):
    cases = {
        "HydraulicSeperator": {
            "color": "red", "label": "Inverter", "storage_size_markers": "Hyd. Weiche",
            "marker": "P"},
        "OnOff": {
            "color": "blue",
            "label": "On/Off",
            "storage_size_markers": {
                5: "^",
                23: "o",
                50: "s"
            }
        }
    }
    input_config_names = [
        "TRY2015_541817120824_Jahr_B1918_standard_o0w2r1g0_SingleDwelling_M_0K-Per-IntGai",
        "TRY2045_495193085486_Somm_B2015_standard_o0w0r0g0_SingleDwelling_NoDHW_0K-Per-IntGai",
    ]
    plotting.compare_design_for_y_variables_vars(
        study_name=study_name,
        cases=cases,
        save_name=f"final_plot",
        input_config_names=input_config_names,
        y_variables=[
            "SCOP_Sys",
            "outputs.hydraulic.gen.heaPum.numSwi",
            "outputs.THeaPumSinMean",
        ]
    )


if __name__ == '__main__':
    logging.basicConfig(level="INFO")
    # STUDY_NAME = "inverter_vs_onoff_mpc_perfect"
    # run(STUDY_NAME, n_cpu=12, with_start_losses=False, compare_to_mpc=True, inverter_uses_storage=True, no_mininmal_compressor_speed=True)
    # calculate_with_dynamic_prices(STUDY_NAME)
    STUDY_NAME = "influence_on_off_hydSepNLay"
    plotting.plot_mismatch_due_to_bad_control(RESULTS_FOLDER.joinpath("UseCase_TBivAndV", "no_dhw", "corner_points"))
