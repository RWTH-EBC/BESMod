"""
Plots for the design space
"""
import os.path
import logging
from pathlib import Path
from typing import List, Union

import matplotlib.pyplot as plt

import numpy as np
import pandas as pd

from bes_rules.configs import PlotConfig, StudyConfig
from bes_rules.objectives.annuity import Annuity, AnnuityMapping
from bes_rules.plotting import utils
from bes_rules.simulation_based_optimization import SurrogateBuilder
from bes_rules.utils.pareto import get_pareto_efficient_points_for_df

logger = logging.getLogger(__name__)


def plot_scatter_for_x_over_multiple_y(
        study_config: StudyConfig,
        x_variable: str,
        y_variables: List[str],
        plot_config: PlotConfig = None,
        save_path: Path = None,
        show=False,
):
    dfs, input_configs = utils.get_all_results_from_config(study_config=study_config)
    plot_config = utils.load_plot_config(plot_config=plot_config)

    for df, input_config in zip(dfs, input_configs):
        df = plot_config.scale_df(df)
        fig, axes = utils.create_plots(
            plot_config=plot_config,
            x_variables=[x_variable],
            y_variables=y_variables
        )
        for _y_variable, _ax in zip(y_variables, axes[:, 0]):
            _ax.scatter(df.loc[:, x_variable], df.loc[:, _y_variable])

        axes[0, 0].legend(bbox_to_anchor=(0, 1), loc="lower left")
        utils.save(
            fig=fig, axes=axes,
            save_path=save_path.joinpath(input_config.get_name()),
            show=show, with_legend=False, file_endings=plot_config.file_endings
        )


if __name__ == '__main__':
    logging.basicConfig(level="INFO")
    CONFIG = StudyConfig.from_json(r"D:\00_temp\02_storage_VDI\EVUControl\study_config.json")
    plot_scatter_for_x_over_multiple_y(
        study_config=CONFIG, save_path=Path(r"D:\00_temp"), x_variable="parameterStudy.VPerQFlow",
        y_variables=[
            "costs_total",
            "outputs.building.dTComHea[1]",
            "outputs.hydraulic.gen.heaPum.numSwi"
        ]
    )
