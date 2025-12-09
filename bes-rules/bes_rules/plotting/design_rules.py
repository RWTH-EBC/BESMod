"""
Module to plot regression models to build design rules.
"""
import logging
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from bes_rules.configs import StudyConfig, PlotConfig
from bes_rules.rule_extraction.features import get_feature_names
logger = logging.getLogger(__name__)


def plot_rules(config: StudyConfig, percent_deviation: float = None):
    obj_vars = config.optimization.get_variable_names()
    obj_kpis = config.optimization.objective_names
    feature_names = get_feature_names(config.inputs)

    plot_config = PlotConfig.load_default()

    for obj_kpi in obj_kpis:
        df_kpi = pd.read_excel(
            config.study_path.joinpath(f"RuleExtraction_{obj_kpi}.xlsx"),
            sheet_name=obj_kpi
        )
        df_kpi = plot_config.scale_df(df=df_kpi)
        for sp_name in feature_names:
            if len(df_kpi.loc[:, sp_name].drop_duplicates()) == 1:
                logger.info("Feature %s has not variance. Skipping plot.", sp_name)
                continue
            for obj_var in obj_vars:
                if len(df_kpi.loc[:, obj_var].drop_duplicates()) == 1:
                    logger.info("Objective variable %s has a constant optimal value. Skipping plot.", obj_var)
                    continue
                plt.figure()
                plt.xlabel(plot_config.get_label_and_unit(sp_name))
                plt.ylabel(plot_config.get_label_and_unit(obj_var))
                plt.title(plot_config.get_label(obj_kpi))
                if percent_deviation is None:
                    x = df_kpi.loc[:, sp_name]
                    y = df_kpi.loc[:, obj_var]
                    plt.scatter(x, y)
                    ret, residual, _, _, _ = np.polyfit(x.values, y.values, 1, full=True)
                    plt.plot(x, ret[0] * x + ret[1],
                             label=f"{plot_config.get_label(obj_var)}$={round(ret[0], 2)}\cdot $"
                                   f"{plot_config.get_label(sp_name)}$ + {round(ret[1], 2)}$")
                    plt.legend()
                else:
                    assert percent_deviation in [1, 3, 5, 10], "percent_deviation not valid"
                    _ymax = df_kpi.loc[:, get_percent_deviation_name(obj_var, percent_deviation, "max")]
                    _ymin = df_kpi.loc[:, get_percent_deviation_name(obj_var, percent_deviation, "min")]
                    _ymean = (_ymax + _ymin) / 2
                    _yerr = _ymax - _ymean
                    plt.errorbar(
                        y=df_kpi.loc[:, obj_var],
                        x=df_kpi.loc[:, sp_name],
                        yerr=_yerr,
                        fmt="o"
                    )

    plt.show()


def get_percent_deviation_name(obj_var: list, percent_deviation: float, minmax: str):
    return f"{obj_var} {percent_deviation}-percent {minmax}"


if __name__ == '__main__':
    logging.basicConfig(level="INFO")
    CONFIG = StudyConfig.from_json(r"E:\01_Results\TBivOptimization\Testzone\study_config.json")
    CONFIG.optimization.objective_names = ["costs_total"]#, "costs_operating", "costs_invest", "emissions"]
    plot_rules(config=CONFIG)
