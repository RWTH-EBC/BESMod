import json
import os
import os.path
import logging
from pathlib import Path
from typing import List, Union

import numpy as np
import pandas as pd

import matplotlib.pyplot as plt

from bes_rules.configs import PlotConfig, StudyConfig, InputConfig
from bes_rules.simulation_based_optimization.base import SurrogateBuilder

logger = logging.getLogger(__name__)


def get_pv_name(pv_directions):
    if pv_directions:
        return "".join(pv_directions)
    return "noPV"


def get_file_name(input_config, interval, pv_directions):
    return input_config.get_name() + f"_{get_pv_name(pv_directions)}_{interval}"


def save(
        fig: plt.Figure,
        axes: np.ndarray,
        save_path: Path,
        show: bool = False,
        with_legend: bool = True,
        file_endings: list = None,
        language: str = None
):
    if file_endings is None:
        file_endings = ["pdf", "png", "svg"]
    if with_legend:
        for ax in axes.flatten():
            ax.legend()
    fig.tight_layout()
    fig.align_ylabels()
    os.makedirs(save_path.parent, exist_ok=True)
    if language is not None and language == "en":
        save_path = save_path.with_stem(save_path.stem + "_en")
    for suffix in file_endings:
        plt.savefig(save_path.with_suffix(f".{suffix}"))
    if show:
        plt.show()
    plt.close("all")


def create_plots(
        plot_config: PlotConfig,
        x_variables: List[str],
        y_variables: List[str],
        share_x: Union[bool, str] = True,
        share_y: Union[bool, str] = False,
        height_per_var: float = 0.75,
        n_columns_per_var: float = 1
):
    fig, axes = plt.subplots(
        nrows=len(y_variables), ncols=len(x_variables),
        sharex=share_x, sharey=share_y,
        squeeze=False, figsize=get_figure_size(
            n_columns=len(x_variables) * n_columns_per_var,
            height_factor=max(1.0, height_per_var * len(y_variables))
        )
    )
    for _x_variable, _ax in zip(x_variables, axes[-1, :]):
        if _x_variable in plot_config.variables:
            _ax.set_xlabel(plot_config.get_label_and_unit(_x_variable))
        else:
            _ax.set_xlabel(_x_variable)
    for _y_variable, _ax in zip(y_variables, axes[:, 0]):
        if _y_variable not in plot_config.variables:
            _ax.set_ylabel(_y_variable)
        else:
            _ax.set_ylabel(plot_config.get_label_and_unit(_y_variable))
    return fig, axes


def load_plot_config(plot_config: dict = None, language: str = "en"):
    if isinstance(plot_config, PlotConfig):
        return plot_config

    default_plt_config = PlotConfig.load_default(language=language)
    if isinstance(plot_config, str):
        with open(plot_config, "r") as file:
            plot_config = json.load(file)
    if isinstance(plot_config, dict):
        default_plt_config.update_config(plot_config)
    return default_plt_config


def get_all_results_from_config(
        study_config: StudyConfig, with_user: bool = True
) -> (List[Union[pd.DataFrame, None]], List[InputConfig]):
    dfs = []
    input_configs = study_config.inputs.get_permutations()
    for input_config in input_configs:
        if study_config.simulation.type == "Static":
            dfs.append(get_result_from_input_analysis_for_input(study_config, input_config))
        else:
            dfs.append(get_result_for_input(study_config, input_config, with_user))
    return dfs, input_configs


def get_result_for_input(
        study_config: StudyConfig, input_config: InputConfig, with_user: bool
) -> Union[pd.DataFrame, None]:
    study_name = input_config.get_name(with_user=with_user)
    df_path = SurrogateBuilder.create_and_get_log_path(
        base_path=study_config.study_path, study_name=study_name, create=False
    )
    if not os.path.exists(df_path):
        logger.error("Can not load %s, no xlsx result file!", df_path)
        return
    return SurrogateBuilder.load_design_optimization_log(file_path=df_path)


def get_result_from_input_analysis_for_input(
        study_config: StudyConfig, input_config: InputConfig
) -> Union[pd.DataFrame, None]:
    df_path = study_config.base_path.joinpath(study_config.name, get_file_name(input_config, "1h", []) + ".xlsx")

    if not os.path.exists(df_path):
        logger.error("Can not load %s, no xlsx result file!", df_path)
        return
    return pd.read_excel(df_path, index_col=0)


def get_figure_size(
        n_columns,
        height_factor: float = 1,
        one_column_size: float = 134.46 / 315.71,
        quadratic: bool = False
):
    # Column widths ratios are taken from screenshot of two-column elsevier paper
    # on an A4 Page
    din_a4_width = 21 / 2.54  # in inches
    width = din_a4_width * one_column_size * n_columns
    if quadratic:
        return [width, width]
    else:
        return [
            width,
            3.15 * height_factor
        ]
