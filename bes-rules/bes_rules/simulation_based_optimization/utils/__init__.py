from typing import List

import numpy as np
import pandas as pd

from bes_rules.configs.optimization import OptimizationConfig, OptimizationVariable
from bes_rules.simulation_based_optimization.utils import custom_bayes, result_handling


def get_simulation_input_from_variables(
        variables: List[OptimizationVariable],
        values: List[float]
):
    """
    Return a dict for the simulation based on
    OptimizationVariables and value.

    :param values:
        List of values for the OptimizationVariables
    :param list variables:
        List of OptimizationVariables
    :return:
        parameters: dict
            Parameter dict for DymolaAPI
    """
    parameters = {}
    for var, val in zip(variables, values):
        parameters[var.name] = val
    return parameters


def scale_variables(
        config: OptimizationConfig, variables: np.ndarray,
        scale_ub: float = 1.0, scale_lb: float = 0.0):
    """
    Descale variables to normal bounds (0, 1) or (scale_lb, scale_ub).

    :param OptimizationConfig config:
        Config of optimization
    :param List[float] variables:
         Variables to scale
    :param float scale_ub:
        Upper bound scale, default 1
    :param float scale_ub:
        Lower bound scale, default 0
    :return: variables
        Scaled variables
    """
    if variables.shape[1] != len(config.variables):
        raise IndexError(f"Given variables have non-matching shape {variables.shape}."
                         f"Length of variables is {len(variables)}")
    _lb = np.array([var.lower_bound for var in config.variables])
    _ub = np.array([var.upper_bound for var in config.variables])
    return scale_lb + (variables - _lb) / (_ub - _lb) * (scale_ub - scale_lb)


def descale_variables(config: OptimizationConfig, variables: np.ndarray):
    """
    Descale from normal bounds (0, 1) to bounds of variables:

    :param OptimizationConfig config:
        Config of optimization
    :param List[float] variables:
         Variables to descale
    :return: variables
        Descaled variables
    """
    if variables.shape[1] != len(config.variables):
        raise IndexError("Given variables have non-matching shape (%s)."
                         "Length of variables is %s" % variables.shape, len(variables))
    _lb = np.array([var.lower_bound for var in config.variables])
    _ub = np.array([var.upper_bound for var in config.variables])
    return _lb + variables * (_ub - _lb)


def apply_constraints(config: OptimizationConfig, variables, input_config):
    """
    Apply list of constraints before performing the simulation

    :param OptimizationConfig config:
        Config of optimization
    :param List[float] variables:
         Already descaled variables
    :param InputConfig input_config:
        Config may be required for constraints, e.g. temperatures or building
        constraints.

    :return: variables
        All variables which do no violate constraints
    """
    df = pd.DataFrame(columns=config.get_variable_names(), data=variables)
    for constraint in config.constraints:
        df = constraint.apply(df=df, input_config=input_config)
    return df.to_numpy()
