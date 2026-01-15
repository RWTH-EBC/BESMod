"""
Module with helpful functions
"""
from typing import TYPE_CHECKING
import pandas as pd
import numpy as np
import math
import datetime
from ebcpy import preprocessing

if TYPE_CHECKING:
    from bes_rules.configs.inputs import BuildingConfig


def get_heating_degree_days(
        outdoor_air_temperature: pd.Series,
        room_temperature: float,
        heating_threshold_temperature: float
):
    if not isinstance(outdoor_air_temperature.index, pd.DatetimeIndex):
        raise IndexError("Only DatetimeIndex supported")
    if outdoor_air_temperature.index.freq != "D":
        outdoor_air_temperature = outdoor_air_temperature.resample("D").mean()
    return np.sum(
        room_temperature -
        outdoor_air_temperature.loc[outdoor_air_temperature < heating_threshold_temperature]
    )


def heating_curve(
        TOda, TRoom, TOda_nominal,
        TSup_nominal: float = 273.15 + 55,
        TBase_nominal: float = 273.15 + 25
):
    return np.maximum(TBase_nominal + (TSup_nominal - TBase_nominal) * (TRoom - TOda) / (TRoom - TOda_nominal), TRoom)


def get_heating_threshold_temperature_for_building(building: "BuildingConfig") -> float:
    passive_building = 273.15 + 10
    new_building = 273.15 + 12
    old_building = 273.15 + 15
    # All adv_retrofit are considered passive
    if building.construction_data == "tabula_de_adv_retrofit":
        return new_building
    if building.construction_data == "tabula_de_retrofit":
        return new_building
    if building.year_of_construction >= 2009:
        return new_building
    return old_building


def calculate_storage_surface_area(V: float, h_d: float, sIns: float):
    # Innendurchmesser des Speichers: [m]
    dInn = ((V * 4) / (math.pi * h_d)) ** (1 / float(3))
    # Außendurchmesser des Speichers: [m]
    dOut = dInn + 2 * sIns
    # Berechnung der Speicheroberfläche: [m^2]
    return ((math.pi * (dOut ** 2)) / 4) * 2 + math.pi * dOut * (h_d * dInn)


def resample_and_average_results_with_state_events(df: pd.DataFrame, variables: list, time_step: int):
    df = df.copy().loc[:, variables]
    df["Time"] = df.index
    delta_t = df["Time"].shift(-1) - df["Time"]
    df = df.drop("Time", axis=1)
    df = df.multiply(delta_t, axis=0)
    df = preprocessing.convert_index_to_datetime_index(df, origin=datetime.datetime(2023, 1, 1))
    df = df.resample(f"{time_step}s").sum()
    df = preprocessing.convert_datetime_index_to_float_index(df)
    df = df.divide(time_step, axis=0)
    return df


def integrate_time_series(df: pd.DataFrame, variables: list, time_step: int, with_events: bool = True):
    if with_events:
        df_equidistant = resample_and_average_results_with_state_events(df=df, time_step=time_step, variables=variables)
    else:
        df_equidistant = df.loc[range(0, 365 * 86400, time_step)]
        df_equidistant = df_equidistant[~df_equidistant.index.duplicated(keep="last")]
    return {variable: np.sum(df_equidistant.loc[:, variable]) * time_step for variable in variables}


def argmean(arr):
    # Calculate the mean of the array
    mean = np.mean(arr)
    # Calculate the absolute differences between each element and the mean
    abs_diff = np.abs(arr - mean)
    # Find the index of the element with the smallest absolute difference
    return np.argmin(abs_diff)


def argmedian(arr):
    return np.argmin(np.abs(arr - np.median(arr)))
