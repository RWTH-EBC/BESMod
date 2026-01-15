import numpy as np
import pandas as pd


def get_kpis_corrected_for_init_period(df: pd.DataFrame, init_period: float):
    """
    Subtract integral values at init-time from last time.
    This leads to wrong last-values for non-integral values.
    However, these values should be plotted as tsd anyway.
    """
    res = {}
    integrals, trajectories = split_variable_names_into_integrals_and_trajectories(df.columns)

    for integral in integrals:
        if integral.endswith("THeaPumSinMean") or integral.endswith("THeaPumSouMean"):
            # Some KPIs are already processed integrals, e.g. mean temperatures.
            init_val = 0
        else:
            init_val = df.loc[df.index[0] + init_period, integral]
        if isinstance(init_val, (pd.DataFrame, pd.Series, np.ndarray)) and len(init_val) > 1:
            init_val = init_val.values.max()
        res[integral] = df.iloc[-1][integral] - init_val
    return res


def split_variable_names_into_integrals_and_trajectories(variable_names: list):
    """
    Function to split given list of variable names into
    ones which represent integral values and ones which hold
    trajectory information.
    Function is based on naming scheme in BESMod/BESRules.
    """
    integrals = []
    trajectories = []
    for variable in variable_names:
        # Only care for last name, as the path in the output bus may change
        if isinstance(variable, tuple):
            # In case of tsd format (variable, "raw")
            last_name = variable[0].split(".")[-1]
        else:
            last_name = variable.split(".")[-1]
        if (
                last_name.startswith("dTCom") or
                last_name.startswith("dTCtrl") or
                last_name in ["integral", "numSwi", "totOnTim"] or
                last_name in ["THeaPumSinMean", "THeaPumSouMean"]
        ):
            integrals.append(variable)
        else:
            trajectories.append(variable)
    return integrals, trajectories


def merge_results(results: list, skipped_results: list):
    _results_merged = []
    counter_res_skip = 0
    for skipped_result in skipped_results:
        if skipped_result is None:
            _results_merged.append(results[counter_res_skip])
            counter_res_skip += 1
        else:
            _results_merged.append(skipped_result)
    return _results_merged


def split_constant_columns_from_tsd(tsd: pd.DataFrame) -> (dict, pd.DataFrame):
    trajectory_columns = (tsd != tsd.iloc[0]).any()
    constant_columns = ~trajectory_columns
    return tsd.loc[:, constant_columns].iloc[0].to_dict(), tsd.loc[:, trajectory_columns]
