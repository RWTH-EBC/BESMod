import logging
import os
import pathlib

import matplotlib.pyplot as plt
import pandas as pd
from ebcpy import Optimizer
from typing import Type, List
import numpy as np
from bes_rules.rule_extraction.regression.regressors import Regressor

logger = logging.getLogger(__name__)


deviation_metrics = {
    "mean": np.mean,
    "max": np.max,
    "RMSE": lambda x: np.mean(np.array(x) ** 2) ** 0.5
}


class ObjectiveMetricRegression(Optimizer):

    def __init__(self, cd=None, **kwargs):
        """Instantiate class parameters"""
        self.feature_values = kwargs.pop("feature_values")
        self.objectives = kwargs.pop("objectives")
        self.design_values = kwargs.pop("design_values")
        self.metric = kwargs.pop("metric")
        self.regressor: Type[Regressor] = kwargs.get("regressor")
        assert self.metric in deviation_metrics
        super().__init__(cd=cd, **kwargs)

    def obj(self, xk, *args):
        deviations, _ = get_deviation_from_optimum(
            regressor=self.regressor,
            feature_values=self.feature_values,
            objectives=self.objectives,
            design_values=self.design_values,
            parameters=xk
        )
        return deviations[self.metric]

    def mp_obj(self, x, *args):
        raise NotImplementedError


def minimize_deviation_from_optimum(
        regressor: Type[Regressor],
        feature_values: np.ndarray,
        design_values: np.ndarray,
        objectives: np.ndarray,
        metric: str
):
    warm_start_parameters = regressor.get_parameters(x=feature_values, y=design_values)
    bounds = []
    for r in warm_start_parameters:
        if r < 0:
            bounds.append((r * 1.9, r * 0.1))
        elif r == 0:
            bounds.append((-1, 1))
        else:
            bounds.append((r * 0.1, r * 1.9))

    optimizer = ObjectiveMetricRegression(
        feature_values=feature_values,
        objectives=objectives,
        design_values=design_values,
        bounds=bounds,
        metric=metric,
        regressor=regressor
    )
    kwargs_diff_evo = dict(framework="scipy_differential_evolution", method="best1bin", popsize=50)
    result = optimizer.optimize(**kwargs_diff_evo)
    regressor.get_equation_string(
        x=plot_config.get_label(objective_variable_name),
        parameters=result.x
    )


def get_deviation_from_optimum(
        optimal_design_regressions: np.ndarray,
        objective_values: List[pd.Series],
        scenario_names: list,
        save_path_plot_extrapolation: pathlib.Path = None,
        design_variable: str = ""  # Only used for logging
):
    max_safe_extrapolation_distances_above = {
        "parameterStudy.TBiv": 4,  # For greater TBiv. In this case, using the max of a monovalent HP is also wrong.
        # Adjust if it happens and plot the result
        "parameterStudy.VPerQFlow": 1  # For larger storages, happens never
    }
    max_safe_extrapolation_distances_below = {
        "parameterStudy.TBiv": 1,  # For oversized hps, happens never
        "parameterStudy.VPerQFlow": 1  # For smaller storage, also never happend
    }
    objective_mins = []
    objective_regression_mins = []
    objective_deviations = []
    for optimal_design_regression_idx, objective_values_idx, scenario_name in zip(
            optimal_design_regressions, objective_values, scenario_names
    ):
        objective_values_idx = objective_values_idx[~pd.isna(objective_values_idx)]
        min_values_for_design_variable = objective_values_idx.groupby(level=design_variable).min()

        minimum = np.min(objective_values_idx)
        design_values_idx = objective_values_idx.index.get_level_values(design_variable)
        extrapolation_distance = max(
            design_values_idx.min() - optimal_design_regression_idx,
            optimal_design_regression_idx - design_values_idx.max()
        )

        design_values_for_design_variable = np.unique(design_values_idx)
        if np.any(np.sort(design_values_for_design_variable) != design_values_for_design_variable):
            raise IndexError("Data is not sorted")
        if extrapolation_distance > 0:
            logger.info(
                "Rule leads to extrapolation at %s=%s of %s in scenario %s.",
                design_variable, optimal_design_regression_idx, extrapolation_distance, scenario_name
            )
            # Determine if we're extrapolating beyond the lower or upper bound
            extrapolating_below = optimal_design_regression_idx < design_values_idx.min()
            if extrapolating_below:
                max_safe_extrapolation_distance = max_safe_extrapolation_distances_below.get(design_variable, 0)
            else:
                max_safe_extrapolation_distance = max_safe_extrapolation_distances_above.get(design_variable, 0)

            if extrapolation_distance <= max_safe_extrapolation_distance:
                # Linear extrapolation
                # For extrapolating below the minimum or above the maximum
                if extrapolating_below:
                    # Get the two lowest points for linear extrapolation
                    x1, x2 = design_values_for_design_variable[:2]
                    y1, y2 = min_values_for_design_variable.values[:2]
                    ref = y1
                else:
                    # Get the two highest points for linear extrapolation
                    x1, x2 = design_values_for_design_variable[-2:]
                    y1, y2 = min_values_for_design_variable.values[-2:]
                    ref = y2

                # Calculate slope and extrapolate
                slope = (y2 - y1) / (x2 - x1)
                objective_regression = y1 + slope * (optimal_design_regression_idx - x1)

                logger.debug(
                    "Using linear extrapolation within safe distance (%.2f <= %.2f)",
                    extrapolation_distance, max_safe_extrapolation_distance
                )
                if save_path_plot_extrapolation is not None:
                    os.makedirs(save_path_plot_extrapolation, exist_ok=True)
                    fig, ax = plt.subplots(1, 1)
                    ax.plot(design_values_for_design_variable, min_values_for_design_variable)
                    ax.scatter(optimal_design_regression_idx, objective_regression)
                    ax.set_ylabel("Objective")
                    ax.set_xlabel(design_variable)
                    ax.set_title(scenario_name)
                    fig.tight_layout()
                    fig.savefig(save_path_plot_extrapolation.joinpath(f"idx_{len(objective_deviations)}.png"))
                    plt.close("all")
                if objective_regression < ref:
                    logger.critical("Extrapolation leads to better costs than last point, using last point")
                    objective_regression = ref
            else:
                # Case 2: Beyond the safe extrapolation region
                # Use the maximum value to be conservative
                objective_regression = objective_values_idx.max()

                logger.warning(
                    "Extrapolation distance (%.2f) exceeds safe limit (%.2f). Using maximum objective value: %.2f",
                    extrapolation_distance, max_safe_extrapolation_distance, objective_regression
                )
        else:
            objective_regression = np.interp(
                optimal_design_regression_idx,
                design_values_for_design_variable,
                min_values_for_design_variable.values
            )
        objective_mins.append(minimum)
        objective_regression_mins.append(objective_regression)
        objective_percent_deviation = (objective_regression - minimum) / minimum * 100
        objective_deviations.append(objective_percent_deviation)
    objective_deviations = np.array(objective_deviations)

    return {
        metric: deviation_metric(objective_deviations)
        for metric, deviation_metric in deviation_metrics.items()
    }, objective_deviations, objective_mins, objective_regression_mins
