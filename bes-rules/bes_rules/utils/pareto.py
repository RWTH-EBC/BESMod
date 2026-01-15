import numpy as np
import pandas as pd


def get_pareto_efficient_points(objective_values: np.ndarray):
    """
    Find the pareto-efficient points

    :param np.ndarray objective_values: An (n_points, n_costs) array
    :return: An array of indices of pareto-efficient points.
        This will be an (n_points, ) boolean array
    """
    is_pareto_efficient = np.arange(objective_values.shape[0])
    really_pareto_efficient = []
    idx = 0
    while idx is not None:
        obj_val = objective_values[idx]
        point = is_pareto_efficient[idx]
        # Else
        not_pareto_efficient = np.all(
            obj_val < objective_values, axis=1
        )
        objective_values = objective_values[~not_pareto_efficient]
        is_pareto_efficient = is_pareto_efficient[~not_pareto_efficient]
        dominant_points = np.all(obj_val > objective_values, axis=1)
        if np.any(dominant_points):
            idx = np.where(dominant_points == True)[0][0]
            continue
        really_pareto_efficient.append(point)
        idx = None
        for next_idx, _new_point in enumerate(is_pareto_efficient):
            if _new_point not in really_pareto_efficient and _new_point != point:
                idx = next_idx

    return is_pareto_efficient


def get_pareto_efficient_points_for_df(df: pd.DataFrame, objectives: list):
    """
    Find the pareto-efficient points for the given results dataframe
    with index as values and columns as possible objectives

    :param pd.DataFrame df: The dataframe
    :param list objectives: The columns to include
    :return: The rows of the dataframe which is paretro efficient
    """
    objective_values = np.array([df[objective].values for objective in objectives]).transpose()
    # all_objective_values = objective_values.copy()
    return df.iloc[get_pareto_efficient_points(objective_values=objective_values)]
