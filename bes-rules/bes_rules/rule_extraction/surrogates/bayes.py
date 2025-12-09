import logging
from pathlib import Path
from typing import Dict, List
from functools import reduce
import operator

import numpy as np
import pandas as pd
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import Matern

from bes_rules.plotting.utils import PlotConfig
from bes_rules.rule_extraction.surrogates import Surrogate
from bes_rules.rule_extraction.surrogates.plotting import plot_surrogate_quality

logger = logging.getLogger(__name__)


class BayesSurrogate(Surrogate):

    def __init__(self, df: pd.DataFrame, **kwargs):
        super().__init__(df=df, **kwargs)
        self.metric_hyperparameters = kwargs["metric_hyperparameters"]
        self.extrapolate = kwargs.get("extrapolate", False)
        self.metric_gp = {}
        self.optimization_variables_order = None
        for metric, hyperparameters in self.metric_hyperparameters.items():
            optimization_variables = list(hyperparameters.keys())
            kernel = Matern(
                length_scale=[hyperparameters[optimization_variable]
                              for optimization_variable in optimization_variables],
                nu=2.5)
            if self.optimization_variables_order is None:
                self.optimization_variables_order = optimization_variables
            else:
                if self.optimization_variables_order != optimization_variables:
                    raise ValueError("Order of optimization_variables does not match across hyperparameters")

            # Initialize Gaussian Process with the selected kernel
            self.metric_gp[metric] = GaussianProcessRegressor(kernel=kernel, optimizer=None)
        self.fit(df=self.df)

    def fit(self, df: pd.DataFrame):
        for metric, gp in self.metric_gp.items():
            design_variables_order = self.metric_hyperparameters[metric]
            X_predict = []
            for design_variable in design_variables_order:
                X_predict.append(df.loc[:, design_variable].values)
            X_predict = np.array(X_predict).T
            y_real = df.loc[:, metric]
            is_na = np.isnan(y_real)
            #idx = [0, 200, 400]
            #gp.fit(X_predict[idx], y_real[idx])
            gp.fit(X_predict[~is_na], y_real[~is_na])

    def predict(
            self,
            design_variables: Dict[str, np.ndarray],
            metrics: List[str],
            save_path_plot: Path = None,
            plot_config: PlotConfig = None,
            plot_kwargs: dict = None
    ) -> pd.DataFrame:
        # Order is the same for all metrics, see __init__
        X_predict = []
        extrapolation_mask = []
        for design_variable in self.optimization_variables_order:
            if design_variable not in design_variables:
                raise KeyError(f"{design_variable} not present in design_variables to predict")
            x_predict = design_variables[design_variable]
            X_predict.append(x_predict)
            extrapolation_mask.append((
                (x_predict < self.df.loc[:, design_variable].min()) |
                (x_predict > self.df.loc[:, design_variable].max())
            ))

        extrapolation_mask_all = reduce(operator.or_, extrapolation_mask)
        multi_index = pd.MultiIndex.from_arrays(X_predict, names=self.optimization_variables_order)
        X_predict = np.array(X_predict).T
        df_predict = pd.DataFrame(index=multi_index)
        df_std = df_predict.copy()
        for metric in metrics:
            if metric not in self.metric_hyperparameters:
                raise KeyError("Given metric not in hyperparameters, can't predict")
            y_predict, y_std = self.metric_gp[metric].predict(X_predict, return_std=True)
            if not self.extrapolate:
                y_predict[extrapolation_mask_all] = np.NAN
            df_predict[metric] = y_predict
            df_std[metric] = y_std * 3  # 3 sigma, 99.7 %
        if save_path_plot is not None:
            plot_kwargs = {} if plot_kwargs is None else plot_kwargs
            plot_surrogate_quality(
                df_simulation=self.df,
                df_interpolated=df_predict,
                save_path=save_path_plot,
                plot_config=plot_config,
                df_std=df_std,
                **plot_kwargs
            )
        return df_predict
