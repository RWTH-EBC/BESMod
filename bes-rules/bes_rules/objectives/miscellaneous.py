import logging
from typing import TYPE_CHECKING

import numpy as np
import pandas as pd

from .objective import BaseObjective, BaseObjectiveMapping

if TYPE_CHECKING:
    from bes_rules.configs.inputs import InputConfig

logger = logging.getLogger(__name__)


class MiscellaneousMapping(BaseObjectiveMapping):
    electric_energy_demand: str = "outputs.electrical.dis.PEleLoa.integral"
    electric_energy_feed_in: str = "outputs.electrical.dis.PEleGen.integral"
    heat_pump_heat_supplied: str = "outputs.hydraulic.gen.QHeaPum_flow.integral"
    heating_rod_heat_supplied: str = "outputs.hydraulic.gen.QEleHea_flow.integral"
    electric_energy_produced_by_pv: str = "outputs.electrical.gen.PElePV.integral"
    boiler_gen_heat_supplied: str = "outputs.hydraulic.gen.QBoi_flow.integral"
    boiler_dis_heat_supplied: str = "outputs.hydraulic.dis.QBoi_flow.integral"
    heat_load: str = "systemParameters.QBui_flow_nominal[1]"
    heat_pump_at_nominal: str = "QPriAtTOdaNom_flow_nominal"


class Miscellaneous(BaseObjective):
    """
    Calculate miscellaneous metrics, such as coverage rate or pv states
    """
    mapping: MiscellaneousMapping = MiscellaneousMapping()

    def calc(self, df: pd.DataFrame, input_config: "InputConfig" = None):
        """
        Calculate coverage rates and self-sufficiency degrees
        """
        heating_rod_heat_supplied = self.get_values(df=df, name=self.mapping.heating_rod_heat_supplied, default=0)
        heat_pump_heat_supplied = self.get_values(df=df, name=self.mapping.heat_pump_heat_supplied, default=0)
        boiler_heat_supplied = (
            self.get_values(df=df, name=self.mapping.boiler_gen_heat_supplied, default=0) +
            self.get_values(df=df, name=self.mapping.boiler_dis_heat_supplied, default=0)
        )

        sum_of_heat_supplied = heat_pump_heat_supplied + heating_rod_heat_supplied + boiler_heat_supplied
        # If no heat is supplied, dividing with inf will yield zero, as both HP and HR cover 0 %
        sum_of_heat_supplied[sum_of_heat_supplied == 0] = np.inf
        df.loc[:, "HP_Coverage"] = heat_pump_heat_supplied / sum_of_heat_supplied
        df.loc[:, "HR_Coverage"] = heating_rod_heat_supplied / sum_of_heat_supplied
        df.loc[:, "Boi_Coverage"] = boiler_heat_supplied / sum_of_heat_supplied

        heat_load = self.get_values(df=df, name=self.mapping.heat_load)
        df.loc[:, "eps_hp"] = self.get_values(df=df, name=self.mapping.heat_pump_at_nominal, default=0) / heat_load

        electric_energy_demand = self.get_values(df=df, name=self.mapping.electric_energy_demand)
        electric_energy_feed_in = self.get_values(df=df, name=self.mapping.electric_energy_feed_in)
        electric_energy_produced_by_pv = self.get_values(df=df, name=self.mapping.electric_energy_produced_by_pv, default=0)
        electric_energy_produced_by_pv_and_self_used = electric_energy_produced_by_pv - electric_energy_feed_in
        if np.any(electric_energy_produced_by_pv > 0):
            df.loc[:, "self_consumption_rate"] = (
                    electric_energy_produced_by_pv_and_self_used /
                    electric_energy_produced_by_pv
            )
            df.loc[:, "self_sufficiency_degree"] = (
                    electric_energy_produced_by_pv_and_self_used /
                    (electric_energy_demand + electric_energy_produced_by_pv_and_self_used)
            )
        return df

    def get_objective_names(self):
        return ["self_consumption_rate", "self_sufficiency_degree", "HR_Coverage", "HP_Coverage"]
