"""Module to explore ND-data using interactive plots from plotly"""
from typing import List
from pathlib import Path
import plotly.express as px

from bes_rules.simulation_based_optimization.base import SurrogateBuilder
from bes_rules.configs import PlotConfig


def parallel_coordinates(
        log_path: Path,
        metrics: List[str],
        variables: List[str] = None,
):
    plot_config = PlotConfig.load_default()

    df = SurrogateBuilder.load_design_optimization_log(file_path=log_path)
    df = plot_config.scale_df(df=df)

    if variables is None:
        variables = list(set(df.columns).difference(metrics))

    name_map = {var: r"%s" % plot_config.get_label_and_unit(var).replace("$", "") for var in variables + metrics}
    name_map = {var: var for var in name_map.keys()}

    df = df.rename(columns=name_map)

    fig = px.parallel_coordinates(
        df, color=name_map[metrics[0]],
        dimensions=name_map.values(),
        #color_continuous_scale=px.colors.diverging.Tealrose,
        #color_continuous_midpoint=2
    )
    fig.show()


if __name__ == '__main__':

    LOG_PATH = r"D:\02_Paper\2023_ECOS\DesignOptimizerResultsCtrl.xlsx"

    VARS = [
        #"parameterStudy.TBiv",
        #"parameterStudy.VPerQFlow",
        #"parameterStudy.f_design",
        "parameterStudy.PVSurplus",
        #"parameterStudy.ShareOfPEleNominal",
        "parameterStudy.DHWOverheatTemp",
        "parameterStudy.BufOverheatdT"
    ]
    METRICS = [
        "costs_total",
        "outputs.control.PVHys_KPI.numSwi",
        "outputs.hydraulic.gen.eleHea.numSwi",
        "outputs.control.DHWOverheat_KPI.numSwi",
        "outputs.control.BufOverheat_KPI.numSwi",
        "SCOP_System",
        "hp_coverage_rate",
        "self_consumption_rate",
        "self_sufficiency_degree",
    ]

    parallel_coordinates(
        log_path=LOG_PATH,
        variables=VARS,
        metrics=METRICS,
    )
