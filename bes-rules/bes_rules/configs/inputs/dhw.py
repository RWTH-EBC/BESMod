import pathlib
from typing import Optional, TYPE_CHECKING

import pandas as pd
from pydantic import field_validator, BaseModel, Field, FieldValidationInfo

from bes_rules.configs.inputs.base import BaseInputConfig

if TYPE_CHECKING:
    from bes_rules.configs import InputConfig


class DHWCalcConfig(BaseModel):
    daily_volume: int
    time_step: int = 60
    TDHW_hot: float = 40  # °C
    TDHW_cold: float = 10  # °C
    path: pathlib.Path = None
    tCrit: float = Field(
        default=None,
        title="Critical time according to EN 15450 in h"
    )
    QCrit: float = Field(
        default=None,
        title="Energy demand during critical time according to EN 15450 in kWh"
    )

    def get_name(self):
        return "_".join([str(s) for s in [self.daily_volume, self.time_step, self.TDHW_hot, self.TDHW_cold]])


class DHWProfile(BaseInputConfig):
    profile: str
    dhw_calc_config: Optional[DHWCalcConfig] = None

    @field_validator("dhw_calc_config")
    def check_valid_dhw_calc_config(cls, dhw_calc_config, info: FieldValidationInfo):
        if info.data["profile"] == "DHWCalc" and dhw_calc_config is None:
            raise ValueError("You need to specify dhw_calc_config for DHWCalc")
        return dhw_calc_config

    @field_validator("profile")
    @classmethod
    def check_valid_profile(cls, profile):
        if profile in ["NoDHW", "DHWCalc"] or profile.startswith("Profile"):
            return profile
        assert profile in ["S", "M", "L"], "Only profile S, M, and L are supported"
        return profile

    def get_modelica_modifier(self, input_config: "InputConfig"):
        if self.profile != "DHWCalc":
            if self.profile == "NoDHW":
                return (
                    f"DHW(redeclare BESMod.Systems.Demand.DHW.RecordsCollection.NoDHW DHWProfile,\n"
                    f"  redeclare BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough calcmFlow),\n"
                    f"systemParameters(use_dhw=false)"
                )
            else:
                if not self.profile.startswith("Profile"):
                    profile = "Profile" + self.profile
                else:
                    profile = self.profile
                return f"DHW(redeclare BESMod.Systems.Demand.DHW." \
                       f"RecordsCollection.{profile} DHWProfile)"
        fine_tuning_modifiers = dict(
            tCrit=self.dhw_calc_config.tCrit,
            QCrit=self.dhw_calc_config.QCrit
        )
        fine_tuning_modifier = "\n".join(
            [f"    {key}={value},"
             for key, value in fine_tuning_modifiers.items()
             if value is not None]
        )
        m_flow_nominal = pd.read_csv(self.dhw_calc_config.path, skiprows=2, sep="\t").loc[:, "2_m_flow"].max()
        VDHWDayAt60 = self.dhw_calc_config.daily_volume / 1000 * (
                (self.dhw_calc_config.TDHW_hot - self.dhw_calc_config.TDHW_cold) /
                (60 - self.dhw_calc_config.TDHW_cold)
        )
        return f"redeclare BESMod.Systems.Demand.DHW.DHWCalc DHW(tableName=\"DHWCalc\"," \
               f"{fine_tuning_modifier}" \
               f"    fileName=Modelica.Utilities.Files.loadResource(\"{self.dhw_calc_config.path}\")," \
               f"    VDHWDayAt60={VDHWDayAt60}," \
               f"    mDHW_flow_nominal={m_flow_nominal}," \
               f"    redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquDynamic calcmFlow" \
               f")"""

    def get_name(self):
        if self.profile != "DHWCalc":
            return self.profile
        return f"{self.profile}{self.dhw_calc_config.daily_volume}"
