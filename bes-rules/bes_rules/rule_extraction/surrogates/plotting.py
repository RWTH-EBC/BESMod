import os
import numpy as np
import pandas as pd
from typing import TYPE_CHECKING
from pathlib import Path
from matplotlib import pyplot as plt
from scipy.interpolate import griddata

from bes_rules.configs import PlotConfig

if TYPE_CHECKING:
    from bes_rules.rule_extraction.surrogates.bayes import BayesSurrogate


def plot_surrogate_fit_for_video(
        surrogate: "BayesSurrogate",
        bo_path: Path,
        save_path: Path,
        optimization_variables: list = None
):
    df_bo = pd.read_excel(bo_path)
    for target_variable, gp in surrogate.metric_gp.items():
        # Create a folder for the current target variable
        target_save_path = save_path.joinpath(target_variable)
        os.makedirs(target_save_path, exist_ok=True)  # Create directory if it doesn't exist

        if optimization_variables is None:
            optimization_variables = list(surrogate.metric_hyperparameters[target_variable].keys())
            if len(optimization_variables) > 2:
                raise ValueError("Can only plot two optimization_variables at once")

        # Prepare real data for interpolation based on the target variable
        X_real = surrogate.df[optimization_variables].values
        y_real = surrogate.df[target_variable].values  # Use the target variable for interpolation
        x_interp = np.linspace(X_real[:, 0].min(), X_real[:, 0].max(), 100)
        y_interp = np.linspace(X_real[:, 1].min(), X_real[:, 1].max(), 100)
        X_interp = np.array(np.meshgrid(x_interp, y_interp)).T.reshape(-1, 2)
        Z_interp = griddata(X_real, y_real, X_interp, method='linear').reshape(100, 100)

        # Create a 3D plot
        fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
        ax.plot_surface(X_interp[:, 0].reshape(100, 100), X_interp[:, 1].reshape(100, 100), Z_interp, cmap='viridis',
                        alpha=0.5)

        # Function to update and save the plot
        def update_plot(i):
            X_bo_step = df_bo[optimization_variables[0]].values[:i + 1]
            Y_bo_step = df_bo[optimization_variables[1]].values[:i + 1]
            y_bo_step = df_bo[target_variable].values[:i + 1]
            surrogate.fit(df_bo.iloc[:i + 1])
            # gp.fit(np.column_stack((X_bo_step, Y_bo_step)), y_bo_step)
            X_pred = np.array(np.meshgrid(np.linspace(X_real[:, 0].min(), X_real[:, 0].max(), 100),
                                          np.linspace(X_real[:, 1].min(), X_real[:, 1].max(), 100))).T.reshape(-1, 2)
            y_mean = gp.predict(X_pred).reshape(100, 100)

            ax.clear()
            ax.plot_surface(X_interp[:, 0].reshape(100, 100), X_interp[:, 1].reshape(100, 100), Z_interp,
                            cmap='viridis', alpha=0.5)
            ax.scatter(X_bo_step, Y_bo_step, y_bo_step, color='red', label='Observed Points')
            ax.plot_surface(X_pred[:, 0].reshape(100, 100), X_pred[:, 1].reshape(100, 100), y_mean, cmap='plasma',
                            alpha=0.5)
            ax.set_xlabel(optimization_variables[0])
            ax.set_ylabel(optimization_variables[1])
            ax.set_zlabel(target_variable)
            ax.set_title(f'Bayesian Optimization for {target_variable} - Step {i + 1}')
            ax.legend()

        # Save frames for the video
        num_steps = min(20, len(df_bo))
        for i in range(num_steps):
            update_plot(i)
            plt.savefig(target_save_path.joinpath(f"bayesian_optimization_{target_variable}_step_{i + 1}.png"))


def plot_surrogate_quality(
        df_simulation: pd.DataFrame,
        df_interpolated: pd.DataFrame,
        save_path: Path,
        plot_config: PlotConfig = None,
        plot_surface: bool = True,
        df_std: pd.DataFrame = None,
        show_plot: bool = False
):
    if plot_config is None:
        plot_config = PlotConfig.load_default()
    ncol = len(df_interpolated.columns)
    nrow = df_interpolated.index.nlevels
    if nrow == 1 or not plot_surface:
        plot_surrogate_quality_for_each_index(
            df_simulation=df_simulation,
            df_interpolated=df_interpolated,
            save_path=save_path,
            plot_config=plot_config,
            df_std=df_std
        )
        return
    fig, axes = plt.subplots(
        nrow - 1, ncol, sharex=False, squeeze=False,
        subplot_kw={"projection": "3d"})
    for level in range(1, nrow):
        index_x = df_interpolated.index.get_level_values(0)
        index_y = df_interpolated.index.get_level_values(level)
        axes_row = axes[level - 1, :]
        for column, ax in zip(df_interpolated.columns, axes_row):
            assumed_mesh_len = int(len(df_interpolated) ** 0.5)
            ax.plot_surface(
                plot_config.scale(index_x.name, index_x).values.reshape(-1, assumed_mesh_len),
                plot_config.scale(index_y.name, index_y).values.reshape(-1, assumed_mesh_len),
                plot_config.scale(column, df_interpolated.loc[:, column]).values.reshape(-1, assumed_mesh_len),
                cmap='viridis', alpha=0.5
            )
            ax.scatter(
                plot_config.scale(index_x.name, df_simulation.loc[:, index_x.name]),
                plot_config.scale(index_y.name, df_simulation.loc[:, index_y.name]),
                plot_config.scale(column, df_simulation.loc[:, column]),
                color='red',
                label='Simulation'
            )
            ax.set_xlabel(plot_config.get_label_and_unit(index_x.name))
            ax.set_ylabel(plot_config.get_label_and_unit(index_y.name))
            ax.set_zlabel(plot_config.get_label_and_unit(column))

    os.makedirs(save_path.parent, exist_ok=True)
    fig.tight_layout()
    fig.savefig(save_path)
    if show_plot:
        plt.show()
    plt.close("all")


def plot_surrogate_quality_for_each_index(
        df_simulation: pd.DataFrame,
        df_interpolated: pd.DataFrame,
        save_path: Path,
        plot_config: PlotConfig,
        df_std: pd.DataFrame = None
):
    ncol = len(df_interpolated.columns)
    nrow = df_interpolated.index.nlevels
    fig, axes = plt.subplots(nrow, ncol, sharex=False, squeeze=False)
    for level in range(nrow):
        index = df_interpolated.index.get_level_values(level)
        x_name = index.name
        axes_row = axes[level, :]
        for column, ax in zip(df_interpolated.columns, axes_row):
            ax.plot(
                plot_config.scale(x_name, index),
                plot_config.scale(column, df_interpolated.loc[:, column]),
                label="Surrogate",
                marker="^",
                color="gray",
                markersize=2
            )
            ax.scatter(
                plot_config.scale(x_name, df_simulation.loc[:, x_name]),
                plot_config.scale(column, df_simulation.loc[:, column]),
                label="Simulation", marker="o", color="red"
            )
            if df_std is not None:
                ax.fill_between(
                    plot_config.scale(x_name, index),
                    plot_config.scale(column, df_interpolated.loc[:, column] - df_std.loc[:, column]),
                    plot_config.scale(column, df_interpolated.loc[:, column] + df_std.loc[:, column]),
                    label="Uncertainty",
                    color="gray",
                    alpha=0.3,
                )
            ax.set_ylabel(plot_config.get_label_and_unit(column))
            ax.set_xlabel(plot_config.get_label_and_unit(x_name))
    os.makedirs(save_path.parent, exist_ok=True)
    fig.tight_layout()
    fig.savefig(save_path)
    plt.close("all")


if __name__ == '__main__':
    import json
    from bes_rules import RESULTS_FOLDER

    with open(RESULTS_FOLDER.joinpath("BayesHyperparameters", "best_hyperparameters.json"), "r") as file:
        PARAS = json.load(file)
    df_path = RESULTS_FOLDER.joinpath(
        "RE_Journal", "BESCtrl", "DesignOptimizationResults",
        "TRY2015_536322100078_Jahr_B1994_retrofit_SingleDwelling_M_South",
        "DesignOptimizerResults.xlsx")
    SURROGATE = BayesSurrogate(
        df=pd.read_excel(df_path, index_col=0),
        metric_hyperparameters=PARAS
    )
    plot_surrogate_fit_for_video(
        save_path=RESULTS_FOLDER.joinpath("BayesHyperparameters"),
        surrogate=SURROGATE,
        optimization_variables=["parameterStudy.TBiv", "parameterStudy.VPerQFlow"],
        bo_path=df_path
    )
