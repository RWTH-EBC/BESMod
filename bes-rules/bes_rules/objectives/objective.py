from abc import abstractmethod
import numpy as np
import pandas as pd
from pydantic import ConfigDict, BaseModel
from ebcpy import TimeSeriesData

from .stochastic_parameter import StochasticParameter
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from bes_rules.configs.inputs import InputConfig


class BaseObjectiveMapping(BaseModel):
    """Base class to define type of mapping between simulation and objective"""

    @property
    def simulation_result_names(self):
        return [val for val in self.dict().values() if val is not None]


class BaseObjective(BaseModel):

    mapping: BaseObjectiveMapping
    model_config = ConfigDict(arbitrary_types_allowed=True)

    @abstractmethod
    def calc(self, df: pd.DataFrame, input_config: "InputConfig" = None):
        """

        Parameters
        ----------
        :param pd.DataFrame df:
            DataFrame with results of design optimizer

        Returns
        -------
        DataFrame with manipulated results of design optimizer
        """
        raise NotImplementedError

    @abstractmethod
    def get_objective_names(self):
        """
        Return the names of the variables which
        are calculated and added to the DataFrame in the
        calc method.
        """
        raise NotImplementedError

    @staticmethod
    def get_values(df: pd.DataFrame, name: str, default = None):
        if name in df:
            return df.loc[:, name]
        if default is not None:
            return np.array(
                [default] * len(df),
                dtype="str" if isinstance(default, str) else "float64"
            )
        raise KeyError(f"Required variable '{name}' not stored in results. "
                       f"Can't compute objective!")

    def get_stochastic_parameter_names(self):
        fields = []
        for field_name, field in self.__fields__.items():
            if field.type_ == StochasticParameter:
                fields.append(field_name)
        return fields

    def monte_carlo_analysis(self, n_samples, df, verbose_output=False):
        fields = self.get_stochastic_parameter_names()
        sample_inputs = {}
        for field in fields:
            stochastic_parameter = self.__getattribute__(field)
            sample_inputs[field] = stochastic_parameter.get_random_values(
                n_samples=n_samples
            )
        obj_names = self.get_objective_names()
        _df_sample_results = pd.DataFrame(
            columns=pd.MultiIndex.from_product([obj_names, df.index])
        )
        for n in range(n_samples):
            for field, samples in sample_inputs.items():
                self.__dict__[field].value = samples[n]
            res = self.calc(df=df).loc[:, obj_names]
            for obj_name in obj_names:
                _df_sample_results.loc[n, obj_name] = res.loc[:, obj_name].values

        for obj_name in obj_names:
            df.loc[:, obj_name] = _df_sample_results.loc[:, obj_name].mean()
            # Use ddof=1 as this should be true for Monte Carlo Errors.
            df.loc[:, f"MCE({obj_name})"] = (
                    _df_sample_results.loc[:, obj_name].std(ddof=1) /
                    np.sqrt(n_samples)
            )

        if verbose_output:
            return df, sample_inputs, _df_sample_results
        return df


class TimeSeriesDependentObjective(BaseObjective):

    def calc(self, df: pd.DataFrame, input_config: "InputConfig" = None) -> dict:
        raise NotImplementedError("calc_tsd is required for TimeSeriesObjectives")

    def calc_tsd(self, df: pd.DataFrame, time_step: int, results_last_point: dict = None) -> dict:
        """

        Parameters
        ----------
        :param TimeSeriesData df:
            Time series data from simulation
        :param int time_step:
            The given fixed time step of the simulation,
            required as results with events are not equally sampled.
        :param dict results_last_point:
            Optional integral results from Modelica to compare with
            python-internal integral calculations.

        Returns
        -------
            Dictionary with objectives. Keys are the name, values the value.
        """
        raise NotImplementedError

    @staticmethod
    def get_values_or_last_point(variable, df: pd.DataFrame, results_last_point: dict):
        if variable in df.columns:
            return df.loc[:, variable]
        if variable in results_last_point:
            return np.array(
                [results_last_point[variable]] * len(df),
                dtype="float64"
            )
        raise KeyError(f"Variable {variable} neither in time-series not integral results.")
