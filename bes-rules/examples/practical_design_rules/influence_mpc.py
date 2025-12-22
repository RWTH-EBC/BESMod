import logging
from pathlib import Path

import base_design_optimization
import compare_onoff
from bes_rules import RESULTS_FOLDER, configs
from bes_rules.boundary_conditions.prices import calculate_operating_costs_with_dynamic_prices
from bes_rules.input_variations import run_input_variations
from bes_rules.plotting import EBCColors
from bes_rules.simulation_based_optimization import AgentLibMPC
from mpc_utils import run_mpc
from plotting import compare_plots_with_modifiers

MPC_UTILS_PATH = Path(__file__).parent.joinpath("mpc_utils")


def manipulate_predictions(df):
    df.loc[:, "P_el_demand"] = (
            df.loc[:, "internal_gains_convective"] +
            df.loc[:, "internal_gains_radiative"]
    )
    return df


def _get_configs(
        with_dynamic_prices: bool,
        no_minimal_compressor_speed: bool = False,
        inverter_uses_storage: bool = True
):
    optimization_config = base_design_optimization.get_optimization_config(
        configs.OptimizationVariable(
            name="parameterStudy.TBiv",
            lower_bound=261.15,
            upper_bound=273.15,
            levels=3
        ),
        configs.OptimizationVariable(
            name="parameterStudy.VPerQFlow",
            lower_bound=5,
            upper_bound=50,
            levels=3
        )
    )
    inputs_config = compare_onoff.get_inputs_config_with_added_modifiers(
        inverter_uses_storage=inverter_uses_storage,
        no_minimal_compressor_speed=no_minimal_compressor_speed,
        with_start_losses=False,
        only_inverter=True,
        years_of_construction=["1980"]
    )
    if with_dynamic_prices:
        inputs_config.prices = [
            {"year": None},
            {"year": 2024, "only_wholesale_price": False},
        ]
    return inputs_config, optimization_config


def run_mpc_studies(
        n_cpu,
        with_dynamic_prices: bool,
        no_minimal_compressor_speed: bool = False,
        inverter_uses_storage: bool = True
):
    time_step = 900

    study_name = "".join([
        _get_mpc_name(no_minimal_compressor_speed),
        # "_cDyn" if use_dynamic_prices else "_cCon",
        "" if inverter_uses_storage else "hydSep"
    ])

    mapping_predictions = {
        "electrical.generation.outBusGen.PElePV.value": "P_el_pv_raw",
        "parameterStudy.f_design": "PVDesignSize",
        "outputs.weather.TDryBul": "T_amb",
        "outputs.building.TZone[1]": "T_Air",
        "outputs.building.eneBal[1].traGain.value": "Q_demand",
        "userProfiles.useProBus.absIntGaiRad": "internal_gains_radiative",
        "userProfiles.useProBus.absIntGaiConv": "internal_gains_convective",
        "hydraulic.control.buiAndDHWCtr.TSetBuiSup.TSet": "THeaCur",
    }

    surrogate_builder_kwargs = dict(
        external_control_function=run_mpc.run,
        predictive_control_options=dict(
            mpc_module=MPC_UTILS_PATH.joinpath("agent_modules/mpc.json"),
            predictor_module=MPC_UTILS_PATH.joinpath("agent_modules/predictor.json"),
            simulator_module=MPC_UTILS_PATH.joinpath("agent_modules/simulator_fmu.json"),
            mpc_parameters={},
            save_mpc_results=False,
            save_mpc_stats=True,
            model_path=MPC_UTILS_PATH.joinpath("model_no_rom.py")
        ),
        mapping_prediction_defaults={
            "P_el_pv_raw": 0,
            "PVDesignSize": 1,
        },
        manipulate_predictions=manipulate_predictions,
        mapping_predictions=mapping_predictions
    )
    sim_config = base_design_optimization.get_simulation_config(
        model="MonoenergeticVitoCal_MPC",
        n_days=30,
        time_step=time_step,
        convert_to_hdf_and_delete_mat=False,
        recalculate=False,
        equidistant_output=True
    )

    inputs_config, optimization_config = _get_configs(
        with_dynamic_prices=with_dynamic_prices,
        inverter_uses_storage=inverter_uses_storage,
        no_minimal_compressor_speed=no_minimal_compressor_speed
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
        surrogate_builder_class=AgentLibMPC,
        **surrogate_builder_kwargs
    )
    calculate_with_dynamic_prices(study_name)


def calculate_with_dynamic_prices(study_name: str):
    study_path = RESULTS_FOLDER.joinpath("UseCase_TBivAndV", study_name)
    study_config = configs.StudyConfig.from_json(study_path.joinpath("study_config.json"))
    calculate_operating_costs_with_dynamic_prices(
        study_config=study_config
    )


def _get_mpc_name(no_minimal_compressor_speed: bool):
    return "mpc_perfect" if no_minimal_compressor_speed else "mpc_design_new_agentlib"


def _get_ref_name(no_minimal_compressor_speed: bool):
    return "mpc_perfect_reference" if no_minimal_compressor_speed else "mpc_design_reference"


def get_case_file_names(prices_name: str, no_minimal_compressor_speed: bool):

    def _get_path(study, costs_name):
        return RESULTS_FOLDER.joinpath(
            "UseCase_TBivAndV",
            study,
            "DesignOptimizationResults",
            f"TRY2045_507965128723_Wint_B1980_standard_o0w2r0g1_SingleDwelling_NoDHW_0K-Per-IntGai_{costs_name}",
            "DesignOptimizationResultsWithDynamicCosts.xlsx"
        )

    if no_minimal_compressor_speed:
        prices_name = f"_100{prices_name}"

    cases = {
        "RBC": _get_path(_get_ref_name(no_minimal_compressor_speed), prices_name),
        "MPC": _get_path(_get_mpc_name(no_minimal_compressor_speed), prices_name),
    }
    return cases


def plot_influence_mpc():
    y_variables = [
        "SCOP_Sys",
        "HP_Coverage",
        "costs_operating",
        "outputs.hydraulic.gen.heaPum.numSwi",
        "outputs.building.dTComHea[1]",
        # "outputs.building.dTCtrl[1]",
        # "outputs.building.eneBal[1].traGain.integral"
    ]
    input_config_name = "TRY2045_507965128723_Wint_B1980_standard_o0w2r0g1_SingleDwelling_NoDHW_0K-Per-IntGai"
    study_name = f"mpc_design/DesignOptimizationResults/{input_config_name}"
    ref_name = f"influence_on_off_hydSep/DesignOptimizationResults/{input_config_name}"
    ref_name = study_name
    for _price in ["", "_2024", "_2024Spot"]:
        studies = {
            f"{ref_name}_{_price}": {"color": EBCColors.blue, "label": "RBC", "marker": "s"},
            f"{study_name}_{_price}": {"color": EBCColors.red, "label": "MPC", "marker": "o"},
        }
        for TBiv in [-12, -6, 0]:
            compare_plots_with_modifiers(
                y_variables=y_variables,
                x_variables={"parameterStudy.VPerQFlow": {"parameterStudy.TBiv": TBiv}},
                studies=studies,
                save_name=f"mpc_design/influence_{_price}_{TBiv}",
                height_per_var=0.5
            )


def run_rule_based_comparison(
        with_dynamic_prices: bool,
        no_minimal_compressor_speed: bool = False,
        inverter_uses_storage: bool = True
):
    study_name = "mpc_perfect_reference"
    sim_config = base_design_optimization.get_simulation_config(
        model="MonoenergeticVitoCal",
        n_days=30,
        time_step=900,
        convert_to_hdf_and_delete_mat=True,
        recalculate=False,
        equidistant_output=True
    )

    inputs_config, optimization_config = _get_configs(
        with_dynamic_prices=with_dynamic_prices,
        inverter_uses_storage=inverter_uses_storage,
        no_minimal_compressor_speed=no_minimal_compressor_speed
    )

    config = configs.StudyConfig(
        base_path=RESULTS_FOLDER.joinpath("UseCase_TBivAndV"),
        n_cpu=9,
        name=study_name,
        simulation=sim_config,
        optimization=optimization_config,
        inputs=inputs_config,
        test_only=False
    )
    run_input_variations(
        config=config, run_inputs_in_parallel=False
    )
    calculate_with_dynamic_prices(study_name)


if __name__ == "__main__":
    logging.basicConfig(level="INFO")
    run_mpc_studies(n_cpu=3, with_dynamic_prices=True, inverter_uses_storage=True, no_minimal_compressor_speed=False)
