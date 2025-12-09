import abc
from pathlib import Path
from typing import Dict, List

import numpy as np
import pandas as pd

from bes_rules.plotting.utils import PlotConfig


class Surrogate(abc.ABC):

    def __init__(self, df: pd.DataFrame, **kwargs):
        self.df = df

    @abc.abstractmethod
    def predict(
            self,
            design_variables: Dict[str, np.ndarray],
            metrics: List[str],
            save_path_plot: Path,
            plot_config: PlotConfig,
            plot_kwargs: dict = None
    ) -> pd.DataFrame:
        raise NotImplementedError


def get_variables_to_interpolate(df: pd.DataFrame, design_variables: Dict[str, np.ndarray]):
    df_interpolated = df.copy()
    variables_to_interpolate = []
    mask_constant_variables = np.array([True] * len(df))
    for design_variable, values in design_variables.items():
        if len(set(values)) > 1:
            variables_to_interpolate.append(design_variable)
        else:
            df_interpolated = df_interpolated.loc[df_interpolated.loc[:, design_variable] == values[0]]
            mask_constant_variables = (
                    mask_constant_variables &
                    (df.loc[:, design_variable] == values[0]).values
            )
    return variables_to_interpolate, mask_constant_variables, df_interpolated
