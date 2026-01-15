import logging

import pandas as pd

from .objective import TimeSeriesDependentObjective, BaseObjectiveMapping
from bes_rules.utils.functions import integrate_time_series

logger = logging.getLogger(__name__)


class MeanTemperatureMapping(BaseObjectiveMapping):
    outdoor_air_temperature: str = "outputs.weather.TDryBul"
    heat_pump_supply_temperature: str = "outputs.hydraulic.genCtrl.THeaPumOut"
    heat_pump_heat_flow_rate: str = "outputs.hydraulic.gen.QHeaPum_flow.value"
    heat_pump_heat_flow_integral: str = "outputs.hydraulic.gen.QHeaPum_flow.integral"


class MeanTemperatureKPI(TimeSeriesDependentObjective):
    mapping: MeanTemperatureMapping = MeanTemperatureMapping()

    def get_objective_names(self):
        return ["THeaPumSinMean", "THeaPumSouMean"]

    def calc_tsd(self, df: pd.DataFrame, time_step: int, results_last_point: dict = None) -> dict:
        heat_pump_heat_flow_rate = self.get_values_or_last_point(
            variable=self.mapping.heat_pump_heat_flow_rate, df=df, results_last_point=results_last_point
        )
        outdoor_air_temperature = self.get_values_or_last_point(
            variable=self.mapping.outdoor_air_temperature, df=df, results_last_point=results_last_point
        )
        heat_pump_supply_temperature = self.get_values_or_last_point(
            variable=self.mapping.heat_pump_supply_temperature, df=df, results_last_point=results_last_point
        )
        df.loc[:, "THeaPumTimesQHeaPum"] = (heat_pump_supply_temperature * heat_pump_heat_flow_rate)
        df.loc[:, "TOdaTimesQHeaPum"] = (outdoor_air_temperature * heat_pump_heat_flow_rate)

        df.loc[:, self.mapping.heat_pump_heat_flow_rate] = heat_pump_heat_flow_rate  # In case constant for integral
        variables = [
            "THeaPumTimesQHeaPum",
            "TOdaTimesQHeaPum",
            self.mapping.heat_pump_heat_flow_rate
        ]
        integrals = integrate_time_series(df=df, time_step=time_step, variables=variables, with_events=True)
        heat_integral = integrals[self.mapping.heat_pump_heat_flow_rate]
        heat_integral_from_modelica = results_last_point[self.mapping.heat_pump_heat_flow_integral]
        logger.info(
            "Integration Error between Modelica and Python for heat flow rate is %s percent.",
            (heat_integral - heat_integral_from_modelica) / heat_integral_from_modelica * 100
        )
        return {
            "THeaPumSupMean": integrals["THeaPumTimesQHeaPum"] / heat_integral,
            "THeaPumSouMean": integrals["TOdaTimesQHeaPum"] / heat_integral
        }
