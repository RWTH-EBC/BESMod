import json
import logging
import os
from pathlib import Path
from typing import List, Dict, Union

import matplotlib.pyplot as plt
import matplotlib.colors as colors

import numpy as np
import pandas as pd

from bes_rules.plotting.utils import PlotConfig
from bes_rules.plotting import get_figure_size, EBCColors
from bes_rules.rule_extraction.regression.regressors import Regressor
from bes_rules.rule_extraction import innovization

logger = logging.getLogger(__name__)


def plot_optimality_gap(
        optimal_design_regressions: Union[Dict[str, np.ndarray], np.ndarray],
        objective_values: List[pd.Series],
        objective_name: str,
        feature_values: np.ndarray,
        design_variable: str,
        feature_names: List[str],
        save_path: Path,
        plot_config: PlotConfig = None
):
    if len(feature_names) > 1:
        print("Not yet supported")
        return
    feature_name = feature_names[0]
    if plot_config is None:
        plot_config = PlotConfig.load_default()
    fig, ax = plt.subplots(
        1, 1,
        figsize=get_figure_size(1, 1)
    )
    heatmap = pd.DataFrame()
    feature_order = feature_values[0].argsort()

    for feature_idx in feature_order:
        objective_values_idx = objective_values[feature_idx]
        feature_value = plot_config.scale(feature_name, feature_values[0, feature_idx])
        x_name = objective_values_idx.index.name
        y_objective = objective_values_idx.values
        y_min = np.nanmin(y_objective)
        y_objective_percent_deviation = (y_objective - y_min) / y_min * 100
        x_values_scaled = plot_config.scale(x_name, objective_values_idx.index)
        if feature_value in heatmap.index:
            heatmap.loc[feature_value, x_values_scaled] = np.nanmax(
                [
                    y_objective_percent_deviation,
                    heatmap.loc[feature_value, x_values_scaled]
                ], axis=0
            )
        else:
            heatmap.loc[feature_value, x_values_scaled] = y_objective_percent_deviation
    heatmap = heatmap.sort_index(axis=1)
    n_design_samples = len(heatmap.columns)
    new_index = list(set(
        list(heatmap.index) +
        list(np.linspace(heatmap.index.min(), heatmap.index.max(), n_design_samples)))
    )
    heatmap = heatmap.reindex(new_index).sort_index()
    x = heatmap.index.values
    y = heatmap.columns.values
    X, Y = np.meshgrid(x, y)
    Z = heatmap.values.T  # Transpose to match meshgrid orientation
    # Plot heatmap
    # cmap = "magma_r" as another good option
    pcm = ax.pcolormesh(X, Y, Z, shading='auto', cmap="coolwarm",
                        norm=colors.PowerNorm(gamma=0.15, vmin=0, vmax=np.nanmax(Z)))
    cbar = plt.colorbar(pcm)
    if not isinstance(optimal_design_regressions, dict):
        optimal_design_regressions = {None: optimal_design_regressions}
        with_legend = False
    else:
        with_legend = False
    for rule_name, regression in optimal_design_regressions.items():
        ax.plot(
            plot_config.scale(feature_name, feature_values[0, feature_order]),
            plot_config.scale(design_variable, regression[feature_order]),
            label=f"Rule: {with_legend}"
        )

    ax.set_title(plot_config.get_label(objective_name))
    cbar.set_label('Optimalitätsgap in %', rotation=90)
    cbar.set_ticks([0, 1, 5] + list(np.arange(10, np.nanmax(Z), 20)))
    ax.set_ylabel(plot_config.get_label_and_unit(design_variable))
    ax.set_xlabel(plot_config.get_label_and_unit(feature_name))
    if with_legend:
        ax.legend(bbox_to_anchor=(1.2, 1), loc="upper left")
    fig.tight_layout()
    os.makedirs(save_path.parent, exist_ok=True)
    plot_config.save(fig, save_path)
    plt.close("all")


def plot_single_regression(
        regressor: Regressor,
        parameters: np.ndarray,
        optimal_design_values: np.ndarray,
        feature_values: np.ndarray,
        feature_names: List[str],
        design_variable: str,
        save_path: Path,
        plot_config: PlotConfig,
        deviation_per_optimal_design: np.ndarray,
        design_rule_string: str = None,
        fig_ax=None,
        plot_cbar: bool = True,
        with_ylabel: bool = True,
        cbar_ax: plt.Axes = None,
        min_max_deviation: float = 10.0
):
    if fig_ax is None:
        fig, ax = plt.subplots(
            1, 1,
            figsize=get_figure_size(
                n_columns=1,
                height_factor=1
            ))
    else:
        fig, ax = fig_ax
    max_deviation = np.nanmax(deviation_per_optimal_design)

    color_args = dict(
        norm=colors.PowerNorm(gamma=0.15, vmin=0, vmax=max(min_max_deviation, max_deviation)),
        cmap='coolwarm', s=5
    )

    if len(feature_names) == 1:
        feature_name = feature_names[0]
        idx = 0
        ax.set_xlabel(plot_config.get_label_and_unit(feature_name))
        features_sorted = feature_values[:, feature_values[idx].argsort()]
        optimal_design_regressions = regressor.eval(
            x=features_sorted,
            parameters=parameters
        )
        ax.plot(
            plot_config.scale(feature_name, features_sorted[idx]),
            plot_config.scale(design_variable, optimal_design_regressions),
            color="red",
            label="Regression"
        )
        mappable = ax.scatter(
            plot_config.scale(feature_name, feature_values[idx]),
            plot_config.scale(design_variable, optimal_design_values),
            label="Optima", **color_args, c=deviation_per_optimal_design,
            rasterized=True
        )
    else:
        ax.set_xlabel(plot_config.get_label_and_unit(design_variable + "_rule"))
        sort_idx = optimal_design_values.argsort()
        optimal_design_regressions = regressor.eval(
            x=feature_values[:, sort_idx],
            parameters=parameters
        )
        mappable = ax.scatter(
            plot_config.scale(design_variable, optimal_design_regressions),
            plot_config.scale(design_variable, optimal_design_values[sort_idx]),
            label="Regression", **color_args, c=deviation_per_optimal_design[sort_idx],
            rasterized=True
        )
        ax.plot(
            plot_config.scale(design_variable, optimal_design_values[sort_idx]),
            plot_config.scale(design_variable, optimal_design_values[sort_idx]),
            color="black",
            label="Idealer Fit" if plot_config.language == "de" else "Ideal Fit"
        )
    if plot_cbar:
        cbar = fig.colorbar(mappable, ax=cbar_ax)
        opt_gap_label = "Optimalitätsgaps" if plot_config.language == "de" else "Optimality Gap"
        cbar.set_label(f'{opt_gap_label} in %', rotation=90)
        if max_deviation <= 10:
            ticks = []
            for value in [0, 1, 3, 5, 10]:
                if value <= min_max_deviation:
                    ticks.append(value)
            cbar.set_ticks(ticks)
        else:
            cbar.set_ticks([0, 1, 5] + list(np.arange(10, max_deviation, 20)))

    if with_ylabel:
        ax.set_ylabel(plot_config.get_label_and_unit(design_variable + "_optimum"))
    if design_rule_string is not None:
        fig.suptitle(design_rule_string.split(" = ")[-1])  # No variable to save space
    if fig_ax is None:
        ax.legend(loc="upper left")
        fig.tight_layout()
        os.makedirs(save_path.parent, exist_ok=True)
        if plot_config.language == "en":
            save_path = save_path.with_stem(save_path.stem + "_en")
        plot_config.save(fig, save_path)
        plt.close(fig)
    else:
        return fig, ax


def plot_convergence(all_deviations: dict, save_path: Path, objective_name: str, plot_config: PlotConfig):
    deviations_to_plot = get_opt_gap_names(plot_config.get_label(objective_name))
    fig, axes = plt.subplots(len(deviations_to_plot), 1, sharex=True, figsize=get_figure_size(n_columns=1))
    for ax, metric, ylabel in zip(axes, deviations_to_plot.keys(), deviations_to_plot.values()):
        experiments = list(all_deviations[metric].keys())
        values = list(all_deviations[metric].values())
        full = values[-1]
        ax.plot(experiments[:-1], values[:-1], color="red", marker="s", label="OVP-Iteration")
        ax.set_ylabel(ylabel)
        ax.axhline(full, label="Vollfaktoriell")
        # ax.set_xticks(list(values.keys()))
        # ax.set_xticklabels([str(k) for k in list(values.keys())[:-1]] + ["full"], rotation=90)
    axes[0].legend(loc="upper left", ncol=1)
    axes[-1].set_xlabel("Anzahl Versuche")
    fig.align_ylabels()
    fig.tight_layout()
    fig.savefig(save_path)
    fig.savefig(save_path.with_suffix(".pdf"))


def get_opt_gap_names(objective_label: str):
    objective_label = objective_label.replace("$", "")
    return {
        "mean": "$\Delta \\bar{%s}$" % objective_label + " in %",
        "max": "$\max (\Delta %s)$" % objective_label + " in %",
    }


def plot_convergences(deviations_paths: dict, save_path: Path, objective_name: str, plot_config: PlotConfig = None):
    if plot_config is None:
        plot_config = PlotConfig.load_default()

    deviations_to_plot = get_opt_gap_names(plot_config.get_label(objective_name))

    fig, axes = plt.subplots(len(deviations_to_plot), 1, sharex=True,
                             figsize=get_figure_size(n_columns=2 / 3, height_factor=1.5))
    data = []
    for deviations_path, kwargs in deviations_paths.items():
        with open(deviations_path, "r") as file:
            all_deviations = json.load(file)
        data.append((all_deviations, kwargs))
    for ax, metric, ylabel in zip(axes, deviations_to_plot.keys(), deviations_to_plot.values()):
        for all_deviations, kwargs in data:
            experiments = [int(n) for n in all_deviations[metric].keys()]
            values = list(all_deviations[metric].values())
            full = values[-1]
            ax.plot(experiments[:-1], values[:-1], **kwargs)
        ax.set_ylabel(ylabel)
        ax.axhline(full, label="Vollfaktoriell" if plot_config.language == "de" else "All Scenarios")
    axes[0].legend(loc="upper right", ncol=1)
    axes[-1].set_xlabel("Anzahl Versuche" if plot_config.language == "de" else "Number Scenarios")
    fig.align_ylabels()
    fig.tight_layout()
    if plot_config.language == "en":
        save_path = save_path.with_stem(save_path.stem + "_en")
    plot_config.save(fig, save_path)


def plot_feature_importance(path_results: Path, features: list, features_order: list, with_influence: bool = False):
    plot_config = PlotConfig.load_default()
    if features is None:
        features = ['Q_demand_total', 'GTZ_Ti_HT', 'THyd_nominal', 'dhw_share']
    feature_data = []

    df = pd.read_excel(path_results, index_col=0)
    df = df.loc[df.loc[:, "Regression"] == "PowerLaw"]
    for feature in features:
        # Calculate average error when this feature is present vs absent
        with_feature_mean = df[df['features'].str.contains(feature)]['mean'].mean()
        without_feature_mean = df[~df['features'].str.contains(feature)]['mean'].mean()
        mean_improvement = without_feature_mean - with_feature_mean

        with_feature_max = df[df['features'].str.contains(feature)]['max'].mean()
        without_feature_max = df[~df['features'].str.contains(feature)]['max'].mean()
        max_improvement = without_feature_max - with_feature_max

        feature_data.append({
            'feature': feature,
            'mean_improvement': mean_improvement,
            'max_improvement': max_improvement
        })

    feature_df = pd.DataFrame(feature_data)

    # Sort by mean improvement for consistent ordering
    feature_df = feature_df.sort_values('mean_improvement', ascending=False)
    feature_df = feature_df.set_index("feature")
    feature_df_abs_values = feature_df.copy()
    for idx, order in zip(feature_df.index, features_order):
        if idx not in order:
            raise ValueError("Order is mixed up. Feature importance order: %s" % feature_df.index)
        feature_df_abs_values.loc[idx, "mean"] = df.loc[df.loc[:, "features"] == order, "mean"].values[0]
        feature_df_abs_values.loc[idx, "max"] = df.loc[df.loc[:, "features"] == order, "max"].values[0]

    # Set bar width and positions
    width = 0.35
    x = np.arange(len(features))

    if with_influence:
        # Create a figure with primary and secondary y-axes
        fig, (ax1, ax12) = plt.subplots(2, 1, figsize=get_figure_size(1, 2), sharex=True)
        ax2 = ax1.twinx()  # Create secondary y-axis

        # Plot mean error reduction on primary y-axis (left)
        bars1 = ax1.bar(x - width / 2, feature_df['mean_improvement'], width, color=EBCColors.blue, label='Mittlere')

        # Plot max error reduction on secondary y-axis (right)
        bars2 = ax2.bar(x + width / 2, feature_df['max_improvement'], width, color=EBCColors.red, label='Max')

        # Customize axes
        ylabel_1 = "Reduktion Mittelwert" if plot_config.language == "de" else "Mean Reduction"
        ylabel_2 = "Reduktion Mittelwert" if plot_config.language == "de" else "Maximum Reduction"
        ax1.set_ylabel(f'{ylabel_1} in %', color=EBCColors.blue)
        ax1.tick_params(axis='y', labelcolor=EBCColors.blue)
        ax2.set_ylabel(f'{ylabel_2} in %', color=EBCColors.red)
        ax2.axhline(0, color="black")
        ax2.tick_params(axis='y', labelcolor=EBCColors.red)
    else:
        # Create a figure with primary and secondary y-axes
        corr_rule_figure = 0.3 / 0.48
        height_factor = 134.46 / 315.71 * 21 / 2.54 / 3.15
        #fig, ax12 = plt.subplots(1, 1, figsize=get_figure_size(corr_rule_figure, height_factor * 0.9825), sharex=True)
        fig, ax12 = plt.subplots(1, 1, figsize=get_figure_size(1, 1), sharex=True)

    ax22 = ax12.twinx()  # Create secondary y-axis

    # Plot mean error reduction on primary y-axis (left)
    bars1 = ax12.bar(x - width / 2, feature_df_abs_values['mean'], width, color=EBCColors.blue, label='Mittlere')

    # Plot max error reduction on secondary y-axis (right)
    bars2 = ax22.bar(x + width / 2, feature_df_abs_values['max'], width, color=EBCColors.red, label='Max')

    # Customize axes
    ax12.set_ylabel(f'{"Mittelwert" if plot_config.language == "de" else "Mean"} in %', color=EBCColors.blue)
    ax12.tick_params(axis='y', labelcolor=EBCColors.blue)
    ax12.set_xticks(x)
    ax12.set_xticklabels([plot_config.get_label(feature) for feature in feature_df.index], rotation=90)

    ax22.set_ylabel('Maximum in %', color=EBCColors.red)
    ax22.tick_params(axis='y', labelcolor=EBCColors.red)

    fig.align_ylabels()
    fig.tight_layout()
    plot_path = path_results.parent.joinpath(f"FeatureInfluence{'_en' if plot_config.language == 'en' else ''}.png")
    plot_config.save(fig, plot_path, bbox_inches="tight")
