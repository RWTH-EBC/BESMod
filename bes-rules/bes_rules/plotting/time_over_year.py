import pathlib
from typing import List

import datetime
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from bes_rules.configs import PlotConfig
from bes_rules.plotting import utils


def plot_days_in_year_over_hours_in_day(
        df: pd.DataFrame,
        variables: List[str],
        plot_config: PlotConfig,
        save_path: pathlib.Path = None,
        ax: plt.Axes = None
):
    df = df.loc[:86400 * 365 - 1]
    df.to_datetime_index(origin=datetime.datetime(2023, 1, 1))
    df = df.to_df()
    df = df[~df.index.duplicated(keep='first')]

    df = df.loc[:, variables]
    df = plot_config.scale_df(df=df)

    # Extract day of the year and minute of the day from the datetime index
    df['day_of_year'] = df.index.dayofyear
    df['hour_of_day'] = df.index.hour + df.index.minute / 60 + 1

    fig, axes = plt.subplots(1, len(variables), sharey=True,
                             figsize=utils.get_figure_size(2, 1))

    for ax, variable in zip(axes, variables):
        # Pivot the DataFrame to create a matrix for the heatmap
        heatmap_data = df.pivot(index='day_of_year', columns='hour_of_day', values=variable)

        # Create the heatmap
        sns.heatmap(heatmap_data, cmap='rocket_r', #cbar_kws={'label': plot_config.get_label_and_unit(variable)},
                    ax=ax)
        ax.set_ylabel(None)
        # Customize the plot
        ax.set_title(plot_config.get_label_and_unit(variable))
        ax.set_xlabel('Stunde am Tag')
        #ax.set_xticks([0, 8, 16, 24])
    axes[0].set_ylabel('Tag im Jahr')
    fig.tight_layout()
    if save_path is not None:
        plt.savefig(save_path.joinpath(f"time_over_day_and_year.pdf"))
        plt.savefig(save_path.joinpath(f"time_over_day_and_year.png"))

    plt.show()
