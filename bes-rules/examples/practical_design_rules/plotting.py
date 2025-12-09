import os
from pathlib import Path
from typing import List

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from bes_rules import RESULTS_FOLDER
from bes_rules import configs
from bes_rules.plotting import EBCColors
from bes_rules.plotting import utils
from bes_rules.rule_extraction.innovization import mesh_arrays
from bes_rules.rule_extraction.surrogates import AnnuityMixedBayesSurrogate
from examples.use_case_1_design.simulate_oed_cases import load_best_hyperparameters, get_inputs_config_to_simulate


def filter_constants(df, constants):
    for constant, value in constants.items():
        df = df.loc[df.loc[:, constant] == value]
    return df


def compare_plots_with_modifiers(
        x_variables: dict,
        studies: dict,
        save_name: str,
        y_variables: list = None,
        height_per_var: float = 0.75,
        n_columns_per_var: float = 1,
        case_name: str = "UseCase_TBivAndV",
        ncol: int = 1, top=0.9
):
    plot_config = utils.load_plot_config()
    if y_variables is None:
        n_y = [len(x["y_variables"]) for x in x_variables.values()]
        assert len(set(n_y)) == 1, "y_variables have different length"
        n_y = n_y[0]
    else:
        n_y = len(y_variables)
    fig, axes = plt.subplots(
        nrows=n_y, ncols=len(x_variables),
        sharex="col", sharey="row" if y_variables else False,
        squeeze=False, figsize=utils.get_figure_size(
            n_columns=len(x_variables) * n_columns_per_var,
            height_factor=max(1.0, height_per_var * n_y)
        )
    )
    for _x_variable, _ax in zip(x_variables, axes[-1, :]):
        _ax.set_xlabel(plot_config.get_label_and_unit(_x_variable))
    if y_variables is not None:
        for _y_variable, _ax in zip(y_variables, axes[:, 0]):
            _ax.set_ylabel(plot_config.get_label_and_unit(_y_variable))

    for study, data in studies.items():
        study_path = RESULTS_FOLDER.joinpath(case_name, study, "DesignOptimizerResults.xlsx")
        df = pd.read_excel(study_path, index_col=0)
        df = plot_config.scale_df(df)
        for idx_x, x_variable in enumerate(x_variables):
            constants = x_variables[x_variable]["constants"]
            df_filter = filter_constants(df.copy(), constants)
            y_variables_to_plot = x_variables[x_variable].get("y_variables", y_variables)
            for _y_variable, _ax in zip(y_variables_to_plot, axes[:, idx_x]):
                _ax.scatter(
                    df_filter.loc[:, x_variable], df_filter.loc[:, _y_variable],
                    **data
                )
                if y_variables is None:
                    _ax.set_ylabel(plot_config.get_label_and_unit(_y_variable))
    handles, previous_labels = axes[0, 0].get_legend_handles_labels()
    fig.legend(
        handles=handles, labels=previous_labels, loc="upper center",
        columnspacing=0.02, labelspacing=0,
        handletextpad=0.1, ncol=ncol
    )
    fig.tight_layout()
    fig.align_ylabels()
    fig.subplots_adjust(top=top)
    plot_config.save(fig, RESULTS_FOLDER.joinpath(case_name, save_name))
    plt.close("all")


def compare_design_for_y_variables_vars(
        y_variables,
        save_name,
        cases: dict,
        input_config_names: list,
        study_name: str,
        study_path: Path = None
):
    x_variable = "parameterStudy.TBiv"
    plot_config = utils.load_plot_config()
    if study_path is None:
        study_path = RESULTS_FOLDER.joinpath("UseCase_TBivAndV", study_name)
    study_config = configs.StudyConfig.from_json(study_path.joinpath("study_config.json"))
    dfs, input_configs = utils.get_all_results_from_config(study_config=study_config)
    n_cols = len(input_config_names)
    fig, axes = utils.create_plots(
        plot_config=plot_config,
        x_variables=[x_variable] * n_cols,
        y_variables=y_variables,
        height_per_var=0.5,
        share_y=False
    )
    for idx_col, input_config_name in enumerate(input_config_names):
        for df, input_config in zip(dfs, input_configs):
            if not input_config.get_name().startswith(input_config_name):
                continue
            storage_sizes = list(df.loc[:, "parameterStudy.VPerQFlow"].unique())
            df = plot_config.scale_df(df)
            data = cases[input_config.modifiers[0].name]
            for storage_size in storage_sizes:
                mask_storage = df.loc[:, "parameterStudy.VPerQFlow"] == storage_size
                storage_size_markers = data["storage_size_markers"]
                if isinstance(storage_size_markers, str):
                    label = f"{data['label']} - {storage_size_markers}"
                    marker = data["marker"]
                elif isinstance(storage_size_markers, dict):
                    if storage_size not in storage_size_markers:
                        continue
                    else:
                        marker = storage_size_markers[storage_size]
                        label = f"{data['label']} - {storage_size} l/kW"
                else:
                    raise TypeError
                for _y_variable, _ax in zip(y_variables, axes[:, idx_col]):
                    _ax.scatter(
                        df.loc[mask_storage, x_variable], df.loc[mask_storage, _y_variable],
                        color=data["color"], marker=marker, label=label
                    )

    handles, labels = axes[0, 0].get_legend_handles_labels()
    # Create a legend that spans both columns, positioned above the first row
    fig.legend(
        handles, labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.01),
        ncol=2,
    )
    fig.tight_layout()
    fig.align_ylabels()
    fig.subplots_adjust(top=0.85)  # Increase this value to make more room at the top
    save_path = study_path.joinpath(save_name)
    os.makedirs(save_path.parent, exist_ok=True)
    plot_config.save(fig, save_path)
    plt.close("all")


def get_vars_from_df_for_bayes(variables: list, df: pd.DataFrame, n_sample: int = 100):
    design_variables = {}
    for var in variables:
        design_variables[var] = np.linspace(
            df.loc[:, var].min(),
            df.loc[:, var].max(),
            n_sample
        )
    design_values = mesh_arrays(list(design_variables.values()))
    flat_design_variables = {var: design_values[:, idx] for idx, var in enumerate(design_variables)}
    return flat_design_variables


def plot_bayes_surrogate_for_simulations(
        result_folder: Path,
        start_from: int = 9,
        idx_step: int = 1,
        show_plot: bool = False,
        just_end: bool = False,
        metrics_to_plot: list = None
):
    hyperparameters = load_best_hyperparameters()
    if metrics_to_plot is None:
        metrics_to_plot = list(hyperparameters.keys())
    for metric in metrics_to_plot:
        if metric not in hyperparameters:
            hyperparameters[metric] = hyperparameters["outputs.hydraulic.gen.heaPum.numSwi"]
    plot_path = result_folder.joinpath("bayes_plots")
    os.makedirs(plot_path, exist_ok=True)
    variables = ["parameterStudy.TBiv", "parameterStudy.VPerQFlow"]
    for file in os.listdir(result_folder):
        if not file.endswith(".xlsx") or file.endswith("all_results.xlsx"):
            continue
        df_path = result_folder.joinpath(file)
        df = pd.read_excel(df_path, index_col=0)
        flat_design_variables = get_vars_from_df_for_bayes(variables, df, n_sample=100)
        if not np.any((df.loc[:, "parameterStudy.TBiv"] == 278.15) & (df.loc[:, "parameterStudy.VPerQFlow"] == 5)):
            print("Not corner design", file)
        if just_end:
            indexes = [len(df.index)]
        else:
            indexes = range(start_from, len(df.index), idx_step)
        for idx in indexes:
            try:
                surrogate = AnnuityMixedBayesSurrogate(
                    df=df.loc[:idx],
                    metric_hyperparameters=hyperparameters
                )
                surrogate.predict(
                    metrics=metrics_to_plot,
                    design_variables=flat_design_variables,
                    save_path_plot=plot_path.joinpath(f"{df_path.stem}_{idx}.png"),
                    plot_kwargs=dict(plot_surface=True, show_plot=show_plot)
                )
            except ValueError as err:
                print(f"Can't plot {file} with idx {idx}: {err}")


def plot_mismatch_due_to_bad_control(result_folder: Path):
    dtCtrl = "outputs.building.dTCtrl[1]"
    QTra = "outputs.building.eneBal[1].traGain.integral"
    save_path = result_folder.joinpath("dTCtrlPlots")
    for file in os.listdir(result_folder):
        if not file.endswith(".xlsx") or file.endswith("all_results.xlsx"):
            continue
        df_path = result_folder.joinpath(file)
        df = pd.read_excel(df_path, index_col=0)
        df.loc[:, "dQTra"] = (df.loc[:, QTra].max() - df.loc[:, QTra]) / 3600000
        df.loc[:, "dTCtrl"] = (df.loc[:, dtCtrl] - df.loc[:, dtCtrl].min()) / 3600
        df.loc[:, "dCOpe"] = (df.loc[:, QTra].max() - df.loc[:, QTra]) / df.loc[:, QTra] * 100
        plot_config = utils.load_plot_config()
        fig, axes = plt.subplots(2, 1, figsize=utils.get_figure_size(1, 1))
        for ax, var in zip(axes, ["dQTra", "dCOpe"]):
            ax.scatter(
                df.loc[:, "dTCtrl"],
                df.loc[:, var],
                color=EBCColors.blue
            )
            ax.plot(
                [df.loc[:, "dTCtrl"].min(), df.loc[:, "dTCtrl"].max()],
                [df.loc[:, var].min(), df.loc[:, var].max()],
                color="black",
                label="Identität"
            )
        axes[-1].set_xlabel("$\Delta T_\mathrm{Raum,Ctrl} - \Delta T_\mathrm{Raum,Ctrl,Min}$ in kWh")
        axes[0].set_ylabel("Abweichung\nin kWh")
        axes[1].set_ylabel("Abweichung\nin %")
        print(df.loc[:, "dCOpe"].max())
        os.makedirs(save_path, exist_ok=True)
        fig.align_ylabels()
        fig.tight_layout()
        plot_config.save(fig, save_path.joinpath(df_path.stem))
        plt.close("all")


def print_table_for_input_configs(
        cases_to_simulate: List[configs.InputConfig],
        input_analysis_paths: List[Path],
        pre_calculated_features: Path,
        with_tau: bool = False,
        with_dhw: bool = True,
        with_heat_load: bool = True,
        with_weather: bool = True
):
    df = pd.read_excel(pre_calculated_features, index_col=0)
    inputs_config = get_inputs_config_to_simulate(
        cases_to_simulate=cases_to_simulate, input_analysis_paths=input_analysis_paths
    )
    df_latex = pd.DataFrame()

    for idx, input_config in enumerate(inputs_config.get_permutations()):
        dat_file = input_config.weather.dat_file
        df_latex.loc[idx + 1, "Standort"] = str(dat_file.parents[1].stem).replace(" ", "_")
        _loc = df.loc[input_config.get_name()]
        if with_weather:
            year, _, _typ = dat_file.stem.split("_")
            _typ = {"Jahr": "N", "Somm": "W", "Wint": "K"}[_typ]
            df_latex.loc[idx + 1, "Klimareferenz"] = year.replace("TRY", "") + "-" + _typ
        df_latex.loc[idx + 1, "Baujahr"] = str(input_config.building.year_of_construction)
        df_latex.loc[idx + 1, "Sanierung"] = input_config.building.get_name().split("_")[-2]  # Part with o0w0r0g0
        df_latex.loc[idx + 1, r"$\TAusNom$ in \si{\degreeCelsius}"] = _loc["TOda_nominal"] - 273.15
        df_latex.loc[idx + 1, r"$\GTZ$ in Tsd. \si{\kelvin\hour}"] = _loc["GTZ_Ti_HT"] / 1000
        if with_dhw:
            df_latex.loc[idx + 1, r"$\alphadhw$ in \si{\percent}"] = _loc["dhw_share"] * 100
        if with_heat_load:
            df_latex.loc[idx + 1, r"$\QHeaLoa$ in \si{\kilo\watt}"] = _loc["QHeaLoa_flow"] / 1000
        df_latex.loc[idx + 1, r"$\TSupNom$ in \si{\degreeCelsius}"] = _loc["THyd_nominal"] - 273.15
        if with_tau:
            df_latex.loc[idx + 1, r"$\tau_\mathrm{Geb}$ in h"] = _loc["tau_building"]
            _name = input_config.get_name()
            _name_2K = _name.replace("4K", "2K")
            _name_4K = _name.replace("2K", "4K")
            df_latex.loc[idx + 1, r"$\Delta Q_\mathrm{Abs,2K}$ in \si{\percent}"] = df.loc[_name_2K, "dQ_setback"]
            df_latex.loc[idx + 1, r"$\Delta Q_\mathrm{Abs,4K}$ in \si{\percent}"] = df.loc[_name_4K, "dQ_setback"]
    df_latex.index.name = "Szenario"
    print(df_to_latex_table(df_latex))


def df_to_latex_table(df):
    """
    Converts a pandas DataFrame to a LaTeX table string.

    Parameters:
    -----------
    df : pandas.DataFrame
        The DataFrame to convert
    caption : str, optional
        Caption for the table
    label : str, optional
        Label for the table

    Returns:
    --------
    str
        LaTeX table code
    """
    df_reset = df.reset_index()
    # Get column headers, escape special LaTeX characters
    headers = [r"\rotatebox{-90}{%s}" % col for col in df_reset.columns]

    # Begin tabular environment with column alignment
    num_cols = len(headers)
    latex = f"\\begin{{tabular}}{{{''.join(['c'] * num_cols)}}}\n"
    latex += "\\toprule\n"

    # Add column headers
    latex += " & ".join(headers) + " \\\\\n"
    latex += "\\midrule\n"

    # Add rows
    for _, row in df_reset.iterrows():
        # Convert each cell to string, handle dollars properly
        row_str = []
        for item in row:
            if isinstance(item, float):
                row_str.append(f"{item:.1f}")
            else:
                row_str.append(str(item))

        latex += " & ".join(row_str) + " \\\\\n"

    # Close the tabular environment and table
    latex += "\\bottomrule\n"
    latex += "\\end{tabular}\n"

    return latex


if __name__ == '__main__':
    # plot_time_series_dynamic_vs_static()
    plot_bars_on_off_mpc(no_minimal_compressor_speed=False)
