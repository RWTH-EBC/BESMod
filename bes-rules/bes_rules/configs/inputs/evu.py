from typing import Optional, TYPE_CHECKING

from pydantic import field_validator
from bes_rules.configs.inputs.base import BaseInputConfig

if TYPE_CHECKING:
    from bes_rules.configs import InputConfig


class EVUProfile(BaseInputConfig):
    profile: Optional[str] = None

    @field_validator("profile")
    @classmethod
    def check_valid_profile(cls, profile):
        if profile is None:
            return profile
        assert profile in ["EVU_Sperre_EON", "EVU_Sperre_None", "EVU_Sperre_Enbw", "EVU_Sperre_Westnetz"], \
            "Given EVU profile not supported"
        return profile

    def get_modelica_modifier(self, input_config: "InputConfig"):
        if self.profile is None:
            return ""
        return f'hydraulic(control(useSGReady=true, useExtSGSig=false, filNamSGReady=ModelicaServices.ExternalReferences.loadResource' \
               f'("modelica://BESMod/Resources/SGReady/{self.profile}.txt")))'

    def get_name(self):
        return str(self.profile)  # str to convert None->str
