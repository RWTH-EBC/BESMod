"""
Test-module for functions and classes concerning the building models
"""
import json
import pathlib
import unittest
from pathlib import Path

import numpy as np

from bes_rules.configs.inputs import InputConfig, UserProfile
from bes_rules.boundary_conditions.building import (create_buildings, get_building_configs_by_name,
                                                    get_supply_temperature_after_retrofit,
                                                    get_retrofit_temperatures)
from bes_rules.boundary_conditions.weather import get_weather_configs_by_names


class TestRetrofitTemperatures(unittest.TestCase):
    """Test-retrofit temperatures."""

    def test_no_retrofit(self):
        regression_tests = {
            "NoRetrofit1918": (363.15, 20, 363.15, 20, 18592.321522476486, 18592.321522476486),
            "NoRetrofit1983": (328.15, 10, 328.15, 10, 9205.351783448908, 9205.351783448908)
        }
        buildings = get_building_configs_by_name(building_names=list(regression_tests.keys()))
        configs = self._create_input_configs(buildings=buildings)
        for config in configs:
            result = get_retrofit_temperatures(
                building_config=config.building,
                TOda_nominal=config.weather.TOda_nominal,
                TRoom_nominal=config.user.room_set_temperature
            )
            self.assertEqual(result, regression_tests[config.building.name])

    def test_retrofit(self):
        regression_path = pathlib.Path(__file__).parent.joinpath("regression", "retrofit_data.json")
        with open(regression_path, "r") as file:
            regression_data = json.load(file)
        TSup1 = np.linspace(273.15 + 35, 273.15 + 90, 20)
        dT1 = np.linspace(5, 20, 20)
        QNom1 = 100
        QNom2_arr = [20, 40, 60, 80, 100]
        for idx, QNom2 in enumerate(QNom2_arr):
            TSup2_list = []
            dT2_list = []
            for TSup, dT in zip(TSup1, dT1):
                TSup2, dT2 = get_supply_temperature_after_retrofit(
                    TRoom1=293.15,
                    TRoom2=293.15,
                    n=1.3,
                    TSup1=TSup,
                    TRet1=TSup - dT,
                    QNom1=QNom1,
                    QNom2=QNom2
                )
                TSup2_list.append(TSup2)
                dT2_list.append(dT2)
            self.assertEqual(TSup2_list, regression_data[str(QNom2)]["TSup2"])
            self.assertEqual(dT2_list, regression_data[str(QNom2)]["dT2"])

    @staticmethod
    def _create_input_configs(buildings, with_create_buildings: bool = True):
        weather = get_weather_configs_by_names(region_names=["Potsdam"])[0]
        weather.TOda_nominal = 273.15 - 12
        if with_create_buildings:
            buildings = create_buildings(name="Retro", building_configs=buildings, export=False)
        return [InputConfig(
            weather=weather,
            building=building,
            dhw_profile={"profile": "M"}, user=UserProfile()
        ) for building in buildings]


if __name__ == "__main__":
    unittest.main()
