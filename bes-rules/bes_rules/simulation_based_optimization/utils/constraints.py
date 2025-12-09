"""Module with typical optimization contraints"""
import logging

import numpy as np

from bes_rules.configs.optimization import OptimizationConstraint
from bes_rules.configs.inputs.custom_modifiers import HydraulicSeperatorModifier

logger = logging.getLogger(__name__)


class BivalenceTemperatureGreaterNominalOutdoorAirTemperature(OptimizationConstraint):
    """
    Constraint to only study bivalence temperatures above
    nominal outdoor air temperatures.
    """
    name: str = "TBiv must be greater TOdaNominal"

    def apply(self, df, input_config, set_to_nan: bool = False):
        mask = df.loc[:, "parameterStudy.TBiv"] >= input_config.weather.TOda_nominal
        if not set_to_nan:
            return df.loc[mask]
        df.loc[mask] = np.NAN
        return df


class HydraulicSeperatorConstraint(OptimizationConstraint):
    """
    Constraint to only one storage volume if a hydraulic seperator is
    simulated, as VPerQFlow is not used in that case and, thus, has no influence
    on the system.
    """
    name: str = "Hydraulic seperator comes in one size"

    def apply(self, df, input_config, set_to_nan: bool = False):
        if not self.input_uses_hydraulic_seperator(input_config=input_config):
            return df
        first_v = df.loc[:, "parameterStudy.VPerQFlow"].unique()[0]
        mask = df.loc[:, "parameterStudy.VPerQFlow"] == first_v
        if not set_to_nan:
            return df.loc[mask]
        df.loc[mask] = np.NAN
        return df

    @staticmethod
    def input_uses_hydraulic_seperator(input_config):
        if input_config.modifiers is None:
            return False
        for modifier in input_config.modifiers:
            if isinstance(modifier, HydraulicSeperatorModifier):
                return True
        return False


class ThermalComfortConstraint(OptimizationConstraint):
    """
    Constraint according to EN 16... to only allow 73 Kh/a discomfort.
    Only applicable after simulation.
    """
    name: str = "Thermal scomfort constraint"

    def apply(self, df, input_config, set_to_nan: bool = False):
        if "outputs.building.dTComHea[1]" not in df.columns:
            return df  # Can't check comfort
        mask = df.loc[:, "outputs.building.dTComHea[1]"] >= 73.5 * 3600  # K*s
        if np.any(mask):
            logger.warning("Results contain %s points with discomfort", np.count_nonzero(mask))
        if not set_to_nan:
            return df.loc[mask]
        df.loc[mask] = np.NAN
        return df
