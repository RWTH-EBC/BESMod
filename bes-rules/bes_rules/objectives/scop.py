from typing import TYPE_CHECKING

import pandas as pd

from .objective import BaseObjective, BaseObjectiveMapping

if TYPE_CHECKING:
    from bes_rules.configs.inputs import InputConfig


class SCOPMapping(BaseObjectiveMapping):
    heat_pump_electricity_demand: str = "outputs.hydraulic.gen.PEleHeaPum.integral"
    heating_rod_electricity_demand: str = "outputs.hydraulic.gen.PEleEleHea.integral"
    heat_pump_heat_supplied: str = "outputs.hydraulic.gen.QHeaPum_flow.integral"
    heating_rod_heat_supplied: str = "outputs.hydraulic.gen.QEleHea_flow.integral"
    building_heat_supplied: str = "outputs.building.eneBal[1].traGain.integral"
    dhw_heat_supplied: str = "outputs.DHW.Q_flow.integral"


class SCOP(BaseObjective):
    """
    Calculate seasonal coefficient of performance of different
    system boundaries
    """
    mapping: SCOPMapping = SCOPMapping()

    def calc(self, df: pd.DataFrame, input_config: "InputConfig" = None):
        """
        Calculate SCOP
        """
        heat_pump_electricity_demand = self.get_values(df=df, name=self.mapping.heat_pump_electricity_demand)
        heating_rod_electricity_demand = self.get_values(
            df=df, name=self.mapping.heating_rod_electricity_demand,
            default=0)
        heating_rod_heat_supplied = self.get_values(
            df=df, name=self.mapping.heating_rod_heat_supplied,
            default=0)
        heat_pump_heat_supplied = self.get_values(df=df, name=self.mapping.heat_pump_heat_supplied)
        dhw_heat_supplied = self.get_values(df=df, name=self.mapping.dhw_heat_supplied)
        building_heat_supplied = self.get_values(df=df, name=self.mapping.building_heat_supplied)

        df.loc[:, "SCOP_HP"] = heat_pump_heat_supplied / heat_pump_electricity_demand
        df.loc[:, "SCOP_Gen"] = (
                (heat_pump_heat_supplied + heating_rod_heat_supplied) /
                (heating_rod_electricity_demand + heat_pump_electricity_demand)
        )
        df.loc[:, "SCOP_Sys"] = (
                (dhw_heat_supplied + building_heat_supplied) /
                (heating_rod_electricity_demand + heat_pump_electricity_demand)
        )
        df.loc[:, "DHW_share"] = dhw_heat_supplied / (dhw_heat_supplied + building_heat_supplied)
        A = input_config.building.net_leased_area
        df.loc[:, "QBuiDemPerA"] = building_heat_supplied / A / 3600000  # in kWh/m2
        df.loc[:, "QDemPerA"] = (building_heat_supplied + dhw_heat_supplied) / A / 3600000  # in kWh/m2
        return df

    def get_objective_names(self):
        return ["SCOP_HP", "SCOP_Gen", "SCOP_Sys", "DHW_share"]
