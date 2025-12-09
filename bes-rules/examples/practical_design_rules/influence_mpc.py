import logging

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from ebcpy import TimeSeriesData

from examples.use_case_1_design import base_design_optimization, compare_onoff
from bes_rules import RESULTS_FOLDER
from bes_rules import configs
from bes_rules.input_variations import run_input_variations
from bes_rules.simulation_based_optimization import AgentLibMPC
from examples.use_case_1_design import MPC_UTILS_PATH
from bes_rules.boundary_conditions.prices import calculate_operating_costs_with_dynamic_prices, \
    load_dynamic_electricity_prices
from examples.use_case_1_design.plotting import compare_plots_with_modifiers, EBCColors


def manipulate_predictions(df):
    df.loc[:, "P_el_demand"] = (
            df.loc[:, "internal_gains_convective"] +
            df.loc[:, "internal_gains_radiative"]
    )
    return df


def _get_configs(
        with_dynamic_prices: bool,
        no_minimal_compressor_speed: bool = False,
        inverter_uses_storage: bool = True,
        only_one_hp_size: bool = False
):
    optimization_config = compare_onoff.get_optimization_config(
        compare_to_mpc=True, only_one_hp_size=only_one_hp_size
    )
    inputs_config = compare_onoff.get_inputs_config(
        inverter_uses_storage=inverter_uses_storage,
        no_minimal_compressor_speed=no_minimal_compressor_speed, with_start_losses=False,
        only_inverter=True,
        cases_to_simulate=["TRY2045_507965128723_Wint_B1980_standard_o0w2r0g1_SingleDwelling_NoDHW_0K-Per-IntGai"]
    )
    if with_dynamic_prices:
        inputs_config.prices = [
            {"year": None},
            # {"year": 2024, "only_wholesale_price": True},
            {"year": 2024, "only_wholesale_price": False},
            # {"year": 2023, "only_wholesale_price": True}
        ]
    return inputs_config, optimization_config


def run_mpc(
        n_cpu,
        with_dynamic_prices: bool,
        no_minimal_compressor_speed: bool = False,
        inverter_uses_storage: bool = True,
        only_one_hp_size: bool = False
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
        # n_days=4,
        time_step=time_step,
        convert_to_hdf_and_delete_mat=False,
        recalculate=False,
        equidistant_output=True
    )

    inputs_config, optimization_config = _get_configs(
        with_dynamic_prices=with_dynamic_prices,
        inverter_uses_storage=inverter_uses_storage,
        no_minimal_compressor_speed=no_minimal_compressor_speed,
        only_one_hp_size=only_one_hp_size
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


def plot_mpc_stats(study_name):
    from agentlib_mpc.utils.analysis import load_mpc, load_mpc_stats
    from agentlib_mpc.utils.plotting.interactive import show_dashboard
    mpc_results_path = RESULTS_FOLDER.joinpath(
        "UseCase_TBivAndV",
        study_name,
        "DesignOptimizationResults",
        "TRY2015_523845130645_Jahr_NoRetrofit1983_SingleDwelling_M_0K-Per-IntGai"
    )
    mpc_results = load_mpc(mpc_results_path.joinpath("Design_0_mpc_agent.csv"))
    mpc_stats = load_mpc_stats(mpc_results_path.joinpath("stats_Design_0_mpc_agent.csv"))
    variables_to_plot = [
        # Not ok
        "TBufSet",
        "yValSet",
        "yEleHeaSet",
        "T_TES_1",
        # "T_TES_2",
        # "T_TES_3",
        "T_TES_4",
        # "TTraRet",
        "Qdot_hp",
        "Qdot_hp_max",
        "QTra_flow",
        # "c_feed_in_out",
        "c_grid_out",
        "P_el_feed_into_grid",
        "P_el_feed_from_grid",
        "PEleHeaPum",
        "PEleEleHea",
        # "PEleIntGai_out",
        # "PEleFee",
        # "P_pv",
        # "valve_actual",
        # "Tamb",
        "QTra_flow_slack",
        # "PEleHeaPum_slack",
        # "TTraSup_slack",
        "THeaPumSup_slack",
        # "QHeaPum_flow_slack",
        # "Q_storage_loss"
        # "mTra_flow",
    ]
    show_dashboard(data=mpc_results, stats=mpc_stats, scale="days", variables_to_plot=variables_to_plot)


def debug_casadi_model(design_config_path):
    from bes_rules.simulation_based_optimization.agentlib_mpc.simulate_mpc_model import run as simulate_casadi_and_fmu
    simulate_casadi_and_fmu(
        design_config_path=design_config_path,
        start_time=0,
        stop_time=86400 * 7,
        control_emulator_mapping={
            "hydraulic.control.buiAndDHWCtr.TSetBuiSup.TSet": "TBufSet",
            "outputs.hydraulic.tra.opening[1]": "yValSet",
            "hydraulic.generation.sigBusGen.uEleHea": "yEleHeaSet",
        }
    )


def plot_compare_casadi_fmu(design_config_path):
    mapping = {
        "mTra_flow": "hydraulic.transfer.portTra_in[1].m_flow",
        "TTraSup": "outputs.hydraulic.tra.TSup[1]",
        "TTraRet": "outputs.hydraulic.tra.TRet[1]",
        "QTra_flow": "outputs.building.eneBal[1].traGain.value",
        # "QTra_flow_slack": "outputs.building.eneBal[1].traGain.value",
        "Q_storage_loss": "outputs.hydraulic.dis.QBufLos_flow.value",
        "Qdot_hp": "outputs.hydraulic.gen.QHeaPum_flow.value",
        "PEleHeaPum": "outputs.hydraulic.gen.PEleHeaPum.value",
        "PEleEleHea": "outputs.hydraulic.gen.PEleEleHea.value",
        "P_el_feed_from_grid": "outputs.electrical.dis.PEleLoa.value",
        "T_TES_1": "hydraulic.distribution.stoBuf.layer[1].T",
        "T_TES_2": "hydraulic.distribution.stoBuf.layer[2].T",
        "T_TES_3": "hydraulic.distribution.stoBuf.layer[3].T",
        "T_TES_4": "hydraulic.distribution.stoBuf.layer[4].T",
        "TBufSet": "TBufSet",
        "yValSet": "yValSet",
        "valve_actual": "yValSet",
        "yEleHeaSet": "yEleHeaSet",
        "T_amb": "outputs.weather.TDryBul",
        "T_Air": "outputs.building.TZone[1]",
    }

    def _read_sim_result(path):
        return pd.read_csv(path, header=[0, 1, 2], index_col=0).droplevel(level=2, axis=1).droplevel(level=0, axis=1)

    df_fmu = _read_sim_result(design_config_path.parent.joinpath("Design_0_sim_agent_debug.csv"))
    df_casadi = _read_sim_result(design_config_path.parent.joinpath("Design_0_sim_agent_casadi_debug.csv"))
    n_batch = 5
    casadi_vars = list(mapping.keys())
    fmu_vars = list(mapping.values())
    for i in range(0, len(mapping), n_batch):
        if i + n_batch > len(mapping):
            n_batch = len(mapping) - i
        fig, axes = plt.subplots(n_batch, 1, sharex=True)
        for ax, casadi, fmu in zip(axes.flatten(), casadi_vars[i:i + n_batch], fmu_vars[i:i + n_batch]):
            ax.plot(df_fmu.index, df_fmu.loc[:, fmu], label="FMU", color="blue")
            ax.plot(df_fmu.index, df_casadi.loc[:, casadi], label="Casadi", color="red", linestyle="--")
            ax.set_ylabel(casadi)
        axes[-1].set_xlabel("Time")
    m_flow_var = "mTra_flow"
    T_ret_var = "TTraRet"
    T_supply_var = "TTraSup"
    T_room = "T_Air"
    UA_casadi = df_casadi.loc[:, m_flow_var] * 4184 * np.log(
        (df_casadi.loc[:, T_supply_var] - df_casadi.loc[:, T_room]) /
        (df_casadi.loc[:, T_ret_var] - df_casadi.loc[:, T_room])
    )
    m_flow_var = mapping[m_flow_var]
    T_ret_var = mapping[T_ret_var]
    T_supply_var = mapping[T_supply_var]
    T_room = mapping[T_room]
    UA_fmu = df_fmu.loc[:, m_flow_var] * 4184 * np.log(
        (df_fmu.loc[:, T_supply_var] - df_fmu.loc[:, T_room]) /
        (df_fmu.loc[:, T_ret_var] - df_fmu.loc[:, T_room])
    )
    plt.figure()
    plt.plot(df_fmu.index, UA_casadi, color="red", linestyle="--")
    plt.plot(df_fmu.index, UA_fmu, color="blue", )
    plt.show()


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
        inverter_uses_storage: bool = True,
        only_one_hp_size: bool = False
):
    study_name = "mpc_perfect_reference"
    sim_config = base_design_optimization.get_simulation_config(
        model="MonoenergeticVitoCal",
        time_step=900,
        convert_to_hdf_and_delete_mat=True,
        recalculate=False,
        equidistant_output=True
    )

    inputs_config, optimization_config = _get_configs(
        with_dynamic_prices=with_dynamic_prices,
        inverter_uses_storage=inverter_uses_storage,
        no_minimal_compressor_speed=no_minimal_compressor_speed,
        only_one_hp_size=only_one_hp_size
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


def compare_dynamic_prices_to_reference(mpc_name):
    from bes_rules.plotting import utils
    plot_config = utils.load_plot_config()
    study_config_mpc = configs.StudyConfig.from_json(
        RESULTS_FOLDER.joinpath("UseCase_TBivAndV", mpc_name, "study_config.json")
    )
    study_config_ref = configs.StudyConfig.from_json(RESULTS_FOLDER.joinpath(
        "UseCase_TBivAndV", "mpc_design_reference",
        "study_config.json"))

    time_step = study_config_mpc.simulation.sim_setup["output_interval"]
    file_ending = "hdf" if study_config_ref.simulation.convert_to_hdf_and_delete_mat else "mat"
    dfs, input_configs = utils.get_all_results_from_config(study_config=study_config_mpc, with_user=True)
    for df, input_config in zip(dfs, input_configs):
        case_name = input_config.get_name(with_user=True)
        case_path = study_config_mpc.study_path.joinpath("DesignOptimizationResults", case_name)
        case_path_ref = study_config_ref.study_path.joinpath("DesignOptimizationResults", case_name)
        if input_config.prices.year is None:
            df.to_excel(case_path.joinpath("DesignOptimizationResultsWithDynamicCosts.xlsx"))
            continue
        c_grid = load_dynamic_electricity_prices(
            year=input_config.prices.year,
            init_period=study_config_mpc.simulation.init_period,
            time_step=time_step,
            only_wholesale_price=input_config.prices.only_wholesale_price
        )
        c_grid = c_grid.loc[study_config_mpc.simulation.init_period:]
        c_grid.index -= c_grid.index[0]
        for idx, row in df.iterrows():
            data = {}
            TBiv = row["parameterStudy.TBiv"] - 273.15
            VSto = row["parameterStudy.VPerQFlow"]
            # if TBiv != -12 or VSto != 50:
            #    continue
            fig, ax = plt.subplots(3, 1, sharex=True, figsize=utils.get_figure_size(1, 1.25))
            kwargs = {
                "MPC": {"label": "MPC Ist", "color": EBCColors.red},  # , "marker": "^", "markersize": 1},
                "MPCIst": {"label": "MPC Ist", "color": EBCColors.red},  # , "marker": "^", "markersize": 1},
                "MPCSet": {"label": "Soll", "color": EBCColors.red, "linestyle": "--"},
                # "marker": "^", "markersize": 1},
                "MPCBufLow": {"label": "MPC-US", "color": EBCColors.grey, "linestyle": "--"},
                # "marker": "^", "markersize": 1},
                "RBC": {"label": "RBC", "color": EBCColors.blue},  # , "marker": "s", "markersize": 1},
            }
            ax[0].plot([308], [0], color="black", linestyle="--", label="Preis")
            for name, path in zip(["RBC", "MPC"], [case_path_ref, case_path]):
                try:
                    tsd = pd.read_excel(path.joinpath(f"Design_{idx}.xlsx"), index_col=0)
                    tsd = tsd.loc[study_config_mpc.simulation.init_period:]
                    tsd.index -= tsd.index[0]
                except FileNotFoundError:
                    tsd = TimeSeriesData(path.joinpath(f"iterate_{idx}.{file_ending}")).to_df()
                tsd = tsd.loc[~tsd.isna().any(axis=1)]

                _end = min(tsd.index[-1], c_grid.index[-1])
                tsd = tsd.loc[:_end]
                # In kW * €/kWh = €/3600s = €/s. Each value is time_step seconds, thus, multiply with time_step
                data[name] = (
                        tsd.loc[:_end, "outputs.electrical.dis.PEleLoa.value"] / 1000 * c_grid.loc[
                                                                                        :_end] / 3600 * time_step
                )
                tsd.index /= 86400
                _mask = (tsd.index > 308) & (tsd.index < 309)
                ax[1].plot(tsd.index[_mask], tsd.loc[_mask, "outputs.hydraulic.disCtrl.TStoBufTopMea"] - 273.15,
                           **kwargs[name])
                if name == "MPC":
                    ax[1].plot(tsd.index[_mask], tsd.loc[_mask, "TBufSet"] - 273.15, **kwargs["MPCSet"])
                    # ax[1].plot(tsd.index[_mask], tsd.loc[_mask, "outputs.hydraulic.disCtrl.TStoBufBotMea"] - 273.15, **kwargs["MPCBufLow"])
                    ax[1].plot(tsd.index[_mask], tsd.loc[_mask, "outputs.hydraulic.disCtrl.TStoBufTopMea"] - 273.15,
                               **kwargs["MPCIst"])
                    ax[2].plot(tsd.index[_mask], tsd.loc[_mask, "outputs.hydraulic.tra.opening[1]"] * 100,
                               **kwargs["MPCIst"])
                    ax[2].plot(tsd.index[_mask], tsd.loc[_mask, "yValSet"] * 100, **kwargs["MPCSet"])
                else:
                    ax[1].plot(tsd.index[_mask], tsd.loc[_mask, "outputs.hydraulic.disCtrl.TStoBufTopMea"] - 273.15,
                               **kwargs[name])
                    ax[2].plot(tsd.index[_mask], tsd.loc[_mask, "outputs.hydraulic.tra.opening[1]"] * 100,
                               **kwargs[name])
                ax[0].plot(tsd.index[_mask], data[name].loc[_mask] * time_step, **kwargs[name])
                # ax[4].plot(tsd.index[_mask], tsd.loc[_mask, "outputs.weather.TDryBul"], **kwargs[name])
            ax_c_twin = ax[0].twinx()
            ax[0].plot([308], [0], color=EBCColors.red, linestyle="--", label="MPC Soll")
            ax_c_twin.plot(c_grid.loc[:_end].index[_mask] / 86400, c_grid.loc[:_end].loc[_mask], color="black",
                           linestyle="--")
            ax_c_twin.set_ylabel("$c_\mathrm{Bed,el}$ in €/kWh")
            # ax[0].axvline(120, color="black")
            # ax[0].axvline(273, color="black")
            ax[0].set_ylabel("$K_\mathrm{Bed}$ in €")
            ax[1].set_ylabel("$T_\mathrm{PS}$ in °C")
            ax[2].set_ylabel("$y_\mathrm{TV}$ in %")
            ax[0].legend(bbox_to_anchor=(0, 1, 1, 1.02), loc="lower left", mode="expand", ncol=2)
            title = "$T_\mathrm{Biv}=%s$°C, $v_\mathrm{\dot{Q}_\mathrm{HL}}=%s$L/kW" % (TBiv, VSto)
            # ax[0].set_title(title)
            print(idx, title)
            ax[-1].set_xlabel("Zeit in d")
            fig.tight_layout()
            fig.align_ylabels()
            fig.subplots_adjust(hspace=0.03)
            plot_config.save(fig, RESULTS_FOLDER.joinpath(
                "UseCase_TBivAndV", mpc_name,
                f"tsd_plot_{idx}_{input_config.get_name()}"
            ))
    plt.show()


if __name__ == "__main__":
    logging.basicConfig(level="INFO")
    # plot_influence_mpc()
    # run_mpc(n_cpu=9, with_dynamic_prices=True, inverter_uses_storage=True, no_minimal_compressor_speed=False, only_one_hp_size=False)
    # run_rule_based_comparison(with_dynamic_prices=True, inverter_uses_storage=True, no_minimal_compressor_speed=True)
    # compare_dynamic_prices_to_reference(mpc_name="mpc_design_new_agentlib")
    calculate_with_dynamic_prices("mpc_design_new_agentlib")

    # plot_mpc_stats(STUDY_NAME)
    # DESIGN_CONFIG_PATH = RESULTS_FOLDER.joinpath(
    #    "UseCase_TBivAndV", STUDY_NAME, "DesignOptimizationResults",
    #    "TRY2015_523845130645_Jahr_NoRetrofit1983_SingleDwelling_M_0K-Per-IntGai", "generated_configs_Design_0"
    # )
    # debug_casadi_model(DESIGN_CONFIG_PATH)
    # plot_compare_casadi_fmu(DESIGN_CONFIG_PATH)
