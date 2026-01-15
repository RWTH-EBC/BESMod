import logging
from pathlib import Path
from typing import Dict, List

import numpy as np
import pandas as pd
from bes_rules.plotting.utils import PlotConfig
from bes_rules.rule_extraction.surrogates.base import Surrogate, get_variables_to_interpolate

from bes_rules.rule_extraction.surrogates.plotting import plot_surrogate_quality
from scipy.interpolate import LinearNDInterpolator
from scipy.interpolate import interp1d

logger = logging.getLogger(__name__)


class LinearInterpolationSurrogate(Surrogate):

    def predict(
            self,
            design_variables: Dict[str, np.ndarray],
            metrics: List[str],
            save_path_plot: Path = None,
            plot_config: PlotConfig = None,
            plot_kwargs: dict = None
    ) -> pd.DataFrame:
        """Use LinearNDInterpolation from scipy"""
        variables_to_interpolate, mask_constant_variables, df_interpolated = get_variables_to_interpolate(
            df=self.df, design_variables=design_variables
        )
        is_1d = len(variables_to_interpolate) == 1

        # Build X for training
        X_train = []
        for var in variables_to_interpolate:
            X_train.append(df_interpolated[var].values)
        X_train = np.array(X_train).T  # Shape: (n_samples, n_dimensions)

        # Prepare query points and multi-index
        if is_1d:
            # For 1D, it's simple
            X_query_array = design_variables[variables_to_interpolate[0]].reshape(-1, 1)
            multi_index = pd.Index(design_variables[variables_to_interpolate[0]],
                                   name=variables_to_interpolate[0])
        else:
            # For ND point-by-point, stack the arrays
            X_query = []
            for var in variables_to_interpolate:
                X_query.append(design_variables[var])
            X_query_array = np.column_stack(X_query)
            multi_index = pd.MultiIndex.from_arrays(X_query, names=variables_to_interpolate)

        # Create result DataFrame
        df_result = pd.DataFrame(index=multi_index)

        # Interpolate each metric
        for metric in metrics:
            y_train = df_interpolated[metric].values

            if is_1d:
                interpolator = interp1d(X_train[:, 0], y_train, kind="linear", bounds_error=False)
            else:
                interpolator = LinearNDInterpolator(X_train, y_train)
            # Predict values
            y_pred = interpolator(X_query_array)

            # Add to result DataFrame
            df_result[metric] = y_pred

        if save_path_plot is not None:
            plot_surrogate_quality(
                df_simulation=self.df.loc[mask_constant_variables],
                df_interpolated=df_result,
                save_path=save_path_plot,
                plot_config=plot_config
            )
        return df_result

    def predict_old(
            self,
            design_variables: Dict[str, np.ndarray],
            metrics: List[str],
            save_path_plot: Path = None,
            plot_config: PlotConfig = None
    ) -> pd.DataFrame:
        variables_to_interpolate, mask_constant_variables, df_interpolated = get_variables_to_interpolate(
            df=self.df, design_variables=design_variables
        )
        if len(variables_to_interpolate) > 1:
            raise ValueError("Currently, only linear interpolation of one axis is allowed")
        variable_to_interpolate = variables_to_interpolate[0]
        df_interpolated = df_interpolated.loc[:, metrics + [variable_to_interpolate]]

        values = design_variables[variable_to_interpolate]
        df_interpolated = df_interpolated.set_index(variable_to_interpolate)
        # real_values = df_interpolated.index.copy()
        try:
            df_interpolated = df_interpolated.reindex(
                list(set(list(values) + list(df_interpolated.index)))).sort_index()
        except ValueError as err:
            raise err
        df_interpolated = df_interpolated.interpolate(limit_area='inside').loc[values]
        mask_no_extrapolation = ~df_interpolated.isnull().any(axis=1)
        if save_path_plot is not None:
            plot_surrogate_quality(
                df_simulation=self.df.loc[mask_constant_variables],
                df_interpolated=df_interpolated,
                save_path=save_path_plot,
                plot_config=plot_config
            )
        return df_interpolated.loc[:, metrics]
