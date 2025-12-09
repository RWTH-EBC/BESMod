"""
Plots for simulation analysis
"""
import logging
from pathlib import Path
from typing import List, Union, Dict

import matplotlib.pyplot as plt
from ebcpy import TimeSeriesData

from bes_rules.plotting import utils


logger = logging.getLogger(__name__)


def get_names_of_plot_variables(
        x_variable: str,
        y_variables: Dict[str, Union[List, str]],
        x_vertical_lines: List[str] = None,
        **kwargs
):
    all_variables = ["outputs.weather.TDryBul"]
    """
    Small helper function to get all variable names
    to be extracted from the simulation result.
    """
    if x_variable != "time":
        all_variables.append(x_variable)
    if x_vertical_lines is not None:
        all_variables.extend(x_vertical_lines)
    for vars in y_variables.values():
        if isinstance(vars, str):
            all_variables.append(vars)
        else:
            all_variables.extend(vars)
    return list(set(all_variables))


def plot_important_variables(
        tsd: TimeSeriesData,
        x_variable: str,
        y_variables: Dict[str, Union[List, str]],
        init_period: float,
        constant_results: dict,
        plot_config: dict = None,
        save_path: Path = None,
        show=False,
        scatter: bool = False,
        x_vertical_lines: List[str] = None,
):
    """
    Plot the most important variables during simulation.


    Example usage:
    ```
    y_variables = {
        "$T_\mathrm{Oda}$ in °C": "outputs.weather.TDryBul",
        "$T_\mathrm{Room}$ in °C": ["outputs.building.TZone[1]", "outputs.user.TZoneSet[1]"],
        "$\dot{Q}_\mathrm{HeaPum}$": "outputs.hydraulic.gen.PEleHeaPum.value",
    }
    ```

    """
    if isinstance(tsd, TimeSeriesData):
        locator = lambda x: (x, "raw")
    else:
        locator = lambda x: x

    if x_vertical_lines is None or not scatter:
        x_vertical_lines = []
    if len(x_vertical_lines) > 2:
        raise ValueError("Only two x_vertical_lines are supported")
    plot_config = utils.load_plot_config(plot_config=plot_config)

    tsd = tsd.copy()
    for constant_res, value in constant_results.items():
        tsd.loc[:, constant_res] = value

    tsd = plot_config.scale_df(tsd)
    fig, axes = plt.subplots(nrows=len(y_variables), ncols=1, sharex=True, squeeze=True,
                             figsize=(5.90551 * 1.5, 8.27 * 1.8 * len(y_variables) / 10))
    if len(y_variables) == 1:
        axes = [axes]
    axes[-1].set_xlabel(plot_config.get_label_and_unit(x_variable))

    for x_vertical_line in x_vertical_lines:
        if tsd.loc[:, locator(x_vertical_line)].std() != 0:
            raise ValueError(f"Given x_vertical_lines {x_vertical_line} in not constant.")

    if x_variable == "time":
        x_values = tsd.loc[init_period:].index / plot_config.get_variable(x_variable).factor
    else:
        x_values = tsd.loc[init_period:, locator(x_variable)]

    for _y_variable, _ax in zip(y_variables, axes):
        _ax.set_ylabel(_y_variable)
        for idx, x_vertical_line in enumerate(x_vertical_lines):
            _ax.axvline(
                tsd.loc[:, locator(x_vertical_line)].mean(),
                label=plot_config.get_label(x_vertical_line),
                color="black"
            )
        plot_variables = y_variables[_y_variable]
        if isinstance(plot_variables, str):
            plot_variables = [plot_variables]
        for plot_variable in plot_variables:
            variable_loc = locator(plot_variable)
            if variable_loc not in tsd.columns:
                logger.error("Variable %s not found in results, can't plot it.", plot_variable)
                continue
            if scatter:
                _ax.scatter(x_values, tsd.loc[init_period:, variable_loc],
                            label=plot_config.get_label(plot_variable),
                            s=1)
            else:
                _ax.plot(x_values, tsd.loc[init_period:, variable_loc],
                         label=plot_config.get_label(plot_variable))
        _ax.legend(bbox_to_anchor=(1, 1), loc="upper left", ncol=1)
    utils.save(
        fig=fig, axes=axes,
        save_path=save_path,
        show=show, with_legend=False, file_endings=["png"]
    )
