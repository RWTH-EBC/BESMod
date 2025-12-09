from typing import TYPE_CHECKING, Optional
from bes_rules.configs.inputs.base import BaseInputConfig


if TYPE_CHECKING:
    from bes_rules.configs import InputConfig


class CustomModifierConfig(BaseInputConfig):
    name: str
    modifier: str
    model_name: Optional[str] = None

    def get_name(self):
        return self.name

    def get_modelica_modifier(self, input_config: "InputConfig"):
        return self.modifier


class HydraulicSeperatorModifier(CustomModifierConfig):
    name: str = "HydraulicSeperator"
    modifier: str = "hydraulic(distribution(redeclare BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.HydraulicSeparator parStoBuf))"


class OnOffControlModifier(CustomModifierConfig):
    name: str = "OnOff"
    modifier: str = (
        "hydraulic(control("
        "redeclare BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.OnOff priGenPIDCtrl))"
    )


class OperativeRoomTemperatureControl(CustomModifierConfig):
    name: str = "ope"
    modifier: str = "hydraulic(control(useOpeTemCtrl=true))"


class N30LayerStorage(CustomModifierConfig):
    name: str = "NLayer"
    modifier: str = "hydraulic(distribution(parStoBuf(nLayer=30)))"


class HeatConductionModelStorage(CustomModifierConfig):
    name: str = "HeatTransfer"  # Irrelevant
    modifier: str = "AixLib.Fluid.Storage.BaseClasses.HeatTransferOnlyConduction"

    def get_name(self):
        return self.modifier.split(".")[-1]

    def get_modelica_modifier(self, input_config: "InputConfig"):
        return (
            "hydraulic(distribution(\n"
            f"stoBuf(redeclare model HeatTransfer = {self.modifier}),\n"
            f"stoDHW(redeclare model HeatTransfer = {self.modifier})))"
        )


class NoMinimalCompressorSpeed(CustomModifierConfig):
    name: str = "100"
    modifier: str = "hydraulic(control(parPIDHeaPum(yMin=0.01)))"


class NoModifier(CustomModifierConfig):
    # Useful to compare a modifier with the default model in a full factor input variation
    name: str = ""
    modifier: str = ""


class StartLossModifier(CustomModifierConfig):
    name: str = "StartLoss"
    modifier: str = "enableInertia=true"


class HeatingCurveOffsetModifier(CustomModifierConfig):
    name: str = "HC"
    modifier: str = "hydraulic(control(buiAndDHWCtr(TSetBuiSup(dTAddCon=10))))"


class BivalentPartParallelModifier(CustomModifierConfig):
    name: str = "NoCutOff"
    modifier: str = "parameterStudy(TCutOff=253.15)"
    cut_off: float

    def get_modelica_modifier(self, input_config: "InputConfig"):
        return f"parameterStudy(TCutOff={self.cut_off + 273.15})"


class BivalentAlternativeModifier(CustomModifierConfig):
    name: str = "cufOff"
    modifier: str = "parameterStudy(TCutOff=parameterStudy.TBiv)"


if __name__ == '__main__':
    OnOffControlModifier()
