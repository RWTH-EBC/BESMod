import json
import os
from typing import List

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from bes_rules import RESULTS_FOLDER
from bes_rules.boundary_conditions.building import get_retrofit_temperatures
from bes_rules.configs import StudyConfig
from bes_rules.configs.inputs import InputConfig, InputsConfig
from bes_rules.utils.functions import get_heating_degree_days, get_heating_threshold_temperature_for_building


def load_practical_features_from_input_analysis(path_input_analysis) -> dict:
    with open(path_input_analysis.joinpath("practical_features.json"), "r") as file:
        return json.load(file)


def get_practical_features(
        input_config: InputConfig,
        all_practical_features: dict = None,
        with_custom_features: bool = False
) -> dict:
    df = input_config.weather.get_hourly_weather_data()
    TOda = df.loc[:, "t"] + 273.15
    heating_threshold = get_heating_threshold_temperature_for_building(building=input_config.building)
    TZoneSet = input_config.user.room_set_temperature

    THyd_nominal, _, THydNoRet_nominal, _, QNoRet_flow_nominal, QRet_flow_nominal = get_retrofit_temperatures(
        building_config=input_config.building,
        TOda_nominal=input_config.weather.TOda_nominal,
        TRoom_nominal=input_config.user.room_set_temperature,
        retrofit_transfer_system_to_at_least=input_config.building.retrofit_transfer_system_to_at_least
    )
    if all_practical_features is None:
        q_demand_total = 0
        dhw_share = 0
    else:
        dhw_share = all_practical_features[input_config.get_name()]["dhw_share"]
        q_demand_total = all_practical_features[input_config.get_name()]["q_demand_total"]

    # praxisnahe Features
    H = QRet_flow_nominal / (input_config.user.room_set_temperature - input_config.weather.TOda_nominal)
    practical_features = {
        "TOda_nominal": input_config.weather.TOda_nominal,
        "Q_demand_total": q_demand_total * input_config.building.net_leased_area,
        "q_demand_total": q_demand_total,
        "QHeaLoa_flow": QRet_flow_nominal,
        "qHeaLoa_flow": H,
        #"TThr": get_heating_threshold_temperature_for_building(building=input_config.building),
        "GTZ_Ti_HT": get_heating_degree_days(TOda, TZoneSet, heating_threshold),
        #"TRoomSet": input_config.user.room_set_temperature,
        "THyd_nominal": THyd_nominal,
        #"TDHW_nominal": 273.15 + 50,
        "dhw_share": dhw_share,
        "dTSetback": input_config.user.night_set_back,
        "cEff": input_config.building.building_parameters.CEff / input_config.building.building_parameters.volume_air / 3600,
        "tau_building": input_config.building.building_parameters.CEff / H / 3600
    }
    if with_custom_features:
        practical_features.update(
            {
                # "GTZ_Ti_Ti": get_heating_degree_days(TOda, TZoneSet, TZoneSet),
                # "area": input_config.building.net_leased_area,
                "year": input_config.building.year_of_construction,
                "QNomRed": QRet_flow_nominal / QNoRet_flow_nominal,
                # Custom / new features
                # "TMin": TOda.min(),
                # "TMean": TOda.mean(),
                # "TMeanSmaller20": df.loc[TOda < 20 + 273.15, "t"].mean(),
                # "phiHeatingToNominal": (df.loc[TOda < 20 + 273.15, "t"].mean()) / input_config.weather.TOda_nominal,
            }
        )
    return practical_features


def get_feature_names(inputs_config: InputsConfig) -> List[str]:
    return list(get_practical_features(InputConfig(
        weather=inputs_config.weathers[0],
        building=inputs_config.buildings[0],
        dhw_profile=inputs_config.dhw_profiles[0],
        user=inputs_config.users[0],
        evu_profile=inputs_config.evu_profiles[0]
    )).keys())
