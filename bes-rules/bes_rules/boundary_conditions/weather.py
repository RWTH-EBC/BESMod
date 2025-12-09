import datetime
import json
import logging
import os
from pathlib import Path

import pandas as pd
from typing import List
from geopy.geocoders import Nominatim

from bes_rules.configs.inputs import WeatherConfig
from bes_rules import DATA_PATH, RESULTS_FOLDER

logger = logging.getLogger(__name__)


def get_weather_configs(condition="cold", forecast=False, weather_data_path: Path = None) -> List[WeatherConfig]:
    """
    Function to get weather configs for climate regions in germany

    :param condition:
        One of cold, average and warm
        Corresponds to "Wint", "Jahr" and "Somm" of DWD.
    :param forecast:
        If True, only load the TRY2045 data. Else only load the TRY2015 data.
    :param Path weather_data_path:
        Path to folder where .dat files are located.
        If none, the data in this repo is used.
    :return:
    """
    if weather_data_path is None:
        weather_data_path = DATA_PATH.joinpath("weather")
    _condition_name = {
        "cold": "Wint",
        "average": "Jahr",
        "warm": "Somm"
    }
    try_name = "TRY2045" if forecast else "TRY2015"
    weather_configs = []
    for subdir, dirs, files in os.walk(weather_data_path):
        for file in files:
            fpath = Path(subdir).joinpath(file)
            if (
                    fpath.suffix == ".dat" and
                    fpath.stem.endswith(f"_{_condition_name[condition]}") and
                    fpath.stem.startswith(try_name)
            ):
                weather_configs.append(
                    WeatherConfig(dat_file=fpath)
                )
    return weather_configs


def get_weather_configs_by_names(
        region_names: list,
        condition: str = "Jahr",
        forecast: bool = "false"
) -> list:
    """
    Return the given region names from the 15 available regions
    in Germany

    :param list region_names:
        List of str with names of regions, e.g. ["Fichtelberg", "Bremerhaven"]
    Further parameter please check get_weather_configs
    """
    with open(DATA_PATH.joinpath("weather", "all_configs.json"), "r") as file:
        sorted_configs = json.load(file)
    configs = []
    for region_name in region_names:
        config = sorted_configs[region_name][condition][forecast]
        configs.append(__load_saved_json_config(config))

    return configs


def get_all_weather_configs(forecast_filter: bool = None, conditions: list = None) -> List[WeatherConfig]:
    with open(DATA_PATH.joinpath("weather", "all_configs.json"), "r") as file:
        sorted_configs = json.load(file)
    if forecast_filter is not None:
        forecast_filter = "true" if forecast_filter else "false"
    configs = []
    for region_name, region_configs in sorted_configs.items():
        for condition, condition_configs in region_configs.items():
            if conditions is not None and condition not in conditions:
                continue
            for forecast, config in condition_configs.items():
                if forecast_filter is not None and forecast != forecast_filter:
                    continue
                configs.append(__load_saved_json_config(config))
    return configs


def __load_saved_json_config(config: str) -> WeatherConfig:
    """
    Helper function to load the json string and correct
    the file path depending on the bes-rules installation folder.
    """
    weather_config_dict = json.loads(config)
    weather_config_dict["dat_file"] = DATA_PATH.joinpath(weather_config_dict["dat_file"])
    return WeatherConfig.model_validate(weather_config_dict)


def save_weather_configs_to_json(weather_configs: List[WeatherConfig]):
    sorted_configs = {}
    for weather_config in weather_configs:
        region_name = weather_config.dat_file.parents[1].name
        forecast = "2045" in weather_config.dat_file.stem
        condition = weather_config.dat_file.stem.split("_")[-1]
        weather_config.mos_path = None
        weather_config = weather_config.model_dump_json()
        if region_name not in sorted_configs:
            sorted_configs[region_name] = {condition: {forecast: weather_config}}
        elif condition not in sorted_configs[region_name]:
            sorted_configs[region_name][condition] = {forecast: weather_config}
        elif forecast not in sorted_configs[region_name][condition]:
            sorted_configs[region_name][condition][forecast] = weather_config

    with open(DATA_PATH.joinpath("weather", "all_configs.json"), "w") as file:
        json.dump(sorted_configs, file)


def create_weather_cases(path: Path, weathers: List[WeatherConfig]):
    os.makedirs(path.joinpath("WeatherInputs"), exist_ok=True)
    mos_file_path = RESULTS_FOLDER.joinpath("mos_files")
    if os.path.exists(mos_file_path):
        mos_to_dat_stem_map = {
            "_".join(mos_name.split("_")[:3]): mos_file_path.joinpath(mos_name)
            for mos_name in os.listdir(mos_file_path) if mos_name.endswith(".mos")
            # dat_stem contains a "_" between TRY and geo-info
        }
    else:
        mos_to_dat_stem_map = {}
    for weather_config in weathers:
        dat_stem = weather_config.dat_file.stem
        if (
                weather_config.TOda_nominal is not None and
                dat_stem in mos_to_dat_stem_map
        ):
            weather_config.mos_path = mos_to_dat_stem_map[dat_stem]
            continue
        if (
                weather_config.TOda_nominal is not None and
                weather_config.mos_path is not None and
                os.path.exists(weather_config.mos_path)
        ):
            continue
        from aixweather.project_class import ProjectClassTRY, ProjectClassEPW
        if weather_config.dat_file_new_pc.suffix == ".dat":
            project_class = ProjectClassTRY
        else:
            project_class = ProjectClassEPW
        try_project = project_class(
            path=str(weather_config.dat_file_new_pc),
            abs_result_folder_path=path.joinpath("WeatherInputs")
        )
        path.mkdir(exist_ok=True)
        path.joinpath("WeatherInputs").mkdir(exist_ok=True)
        try_project.import_data()
        try_project.data_2_core_data()
        # Some file have station names like London/Gatwick --> leads to path errors
        mos_path = f"{dat_stem}_{try_project.meta_data.station_name.replace('/', '_')}.mos"
        try_project.core_2_mos(filename=mos_path)
        _din_ts_12831_path = DATA_PATH.joinpath(
            "weather", "DIN_TS_12831-1_Klimadaten.xlsx"
        )
        weather_config.mos_path = try_project.abs_result_folder_path.joinpath(mos_path)
        for weird_char in ["ü", "ö", "ä", "ß"]:
            if weird_char in str(weather_config.mos_path).lower():
                raise ValueError(
                    f"No weird characters (ä,ü,ö,ß) in .mos "
                    f"file allowed! Converter gave: {weather_config.mos_path}"
                )

        if weather_config.TOda_nominal is None:
            geo_loc = Nominatim(user_agent="GetLoc")
            locname = geo_loc.reverse(f"{try_project.meta_data.latitude}, {try_project.meta_data.longitude}")
            # Get PLZ from address
            plz, city_name = locname.address.split(", ")[-2:]
            df = pd.read_excel(_din_ts_12831_path, sheet_name="Klimadaten", index_col=0)
            TOda_nominal = df.loc[int(plz), "T_NA"]
            logger.info("Got PLZ=%s (city %s) and TOda_nominal=%s degC based on longitude and latitude",
                        plz, city_name, TOda_nominal)
            weather_config.TOda_nominal = TOda_nominal + 273.15
    return weathers


def get_international_weather_data_configs():
    base_path = DATA_PATH.joinpath("weather", "international")
    TOda_nominal_map = {}
    weather_configs = []
    for file in os.listdir(base_path):
        if not file.endswith(".epw"):
            continue
        weather_configs.append(
            WeatherConfig(
                dat_file=base_path.joinpath(file),
                TOda_nominal=TOda_nominal_map.get(file, -12)
            )
        )
    return weather_configs


if __name__ == '__main__':
    create_weather_cases(path=Path(r"D:\00_temp\test_epw"), weathers=get_international_weather_data_configs())
