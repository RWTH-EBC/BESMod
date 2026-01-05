import logging
import pathlib
from typing import Optional, TYPE_CHECKING, Tuple

from bes_rules.configs.inputs.base import BaseInputConfig
from pydantic import Field, model_validator, BaseModel

if TYPE_CHECKING:
    from bes_rules.configs import InputConfig

logger = logging.getLogger(__name__)


class RelevantBuildingParameters(BaseModel):
    heat_load_outside_factor: float = Field(
        title="UA value to ambient air, calculated by TEASER",
    )
    heat_load_ground_factor: float = Field(
        title="UA value to soil, calculated by TEASER",
    )
    roof_area: float
    window_area: float
    facade_area: float
    volume_air: Optional[float] = None
    base_infiltration: Optional[float] = None
    CEff: Optional[float] = None


class BuildingConfig(BaseInputConfig):
    """
    See TEASER documentation for more information on parameters.
    Fields with default values are calculated in this tool using TEASER:
    """

    name: str
    number_of_floors: int
    height_of_floors: float
    with_ahu: bool
    year_of_construction: int
    net_leased_area: float
    number_of_occupants: int
    building_parameters: RelevantBuildingParameters = Field(
        title="Relevant building calculated by TEASER",
        default=None
    )
    record_name: str = None
    building_model_name: str = None
    package_path: pathlib.Path = None
    modify_transfer_system: bool = False
    element_retrofits: Optional[dict] = None
    use_normative_infiltration: bool = False
    use_led: bool = False
    base_infiltration: float = 0.2
    retrofit_transfer_system_to_at_least: Optional[Tuple[float, float]] = Field(
        default=None,
        description="If specified, the buildings maximum supply and return temperature will be this tuple."
                    "For the case of old buildings with new radiators to ensure, "
                    "e.g., (70, 55) °C supply/return temperature"
    )
    defined_supply_temperature: Optional[Tuple[float, float]] = Field(
        default=None,
        description="If specified, the buildings supply and return temperature will be this tuple."
    )
    use_verboseEnergyBalance: bool = True
    possibly_use_underfloor_heating: bool = True
    method: Optional[str] = None
    usage: Optional[str] = None
    construction_type: Optional[str] = None
    geometry_data: Optional[str] = None
    construction_data: Optional[str] = None
    infiltration_rate: Optional[float] = None

    @model_validator(mode='after')
    def deprecation_warning(self):
        if self.method is not None:
            self.geometry_data = f"{self.method}_{self.usage}"
            self.construction_data = self.construction_type.replace("tabula_", "tabula_de_")
            logger.warning(
                "method (%s), usage (%s), and construction_type (%s) are deprecated in the new TEASER API, "
                "converting to new API: construction_data (%s) and geometry_data (%s)",
                self.method, self.usage, self.construction_type, self.construction_data, self.geometry_data
            )
        if self.geometry_data is None or self.construction_data is None:
            raise ValueError(
                "You need to specify both geometry_data and construction_data in the new TEASER API "
                "or specify all old inputs: method, usage, and construction_type"
            )
        if self.infiltration_rate is not None:
            self.base_infiltration = self.infiltration_rate
            logger.warning("infiltration_rate is deprecated, use base_infiltration in the future")
        return self

    def get_modelica_modifier(self, input_config: "InputConfig"):
        base_building_modifier = f"redeclare {self.building_model_name} building("
        if input_config.user.use_stochastic_internal_gains:
            base_building_modifier += f"use_absIntGai=userProfiles.use_absIntGai, "
        if self.use_verboseEnergyBalance:
            building_modifier = base_building_modifier + "use_verboseEnergyBalance=true)"
        else:
            building_modifier = base_building_modifier + "use_verboseEnergyBalance=false)"
        if not self.modify_transfer_system:
            return building_modifier

        from bes_rules.boundary_conditions.building import get_retrofit_temperatures

        THyd_nominal, dTHyd_nominal, THydSupOld_design, _, QBuiOld_flow_design, QBui_flow_design = get_retrofit_temperatures(
            building_config=self,
            TOda_nominal=input_config.weather.TOda_nominal,
            TRoom_nominal=input_config.user.room_set_temperature,
            retrofit_transfer_system_to_at_least=self.retrofit_transfer_system_to_at_least
        )
        use_ufh = self.possibly_use_underfloor_heating and THydSupOld_design < 273.15 + 36

        if use_ufh:
            transfer_system_type = (
                "BESMod.Systems.Hydraulical.Transfer.UFHTransferSystem transfer(\n "
                "  nHeaTra=1.3, "
                "  redeclare BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData UFHParameters(T_floor=291.15), \n"
                "  redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPum)"
            )
            # Disable heat losses to the floor as already included in transfer.
            # TODO: UFH parameters are always the same.
            building_modifier = building_modifier[:-1] + ", zoneParam={%s(AFloor=0)})" % self.record_name
        else:
            transfer_system_type = (
                "BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased transfer(\n"
                "    redeclare BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData parRad)"
            )
        if self.defined_supply_temperature is not None:
            THyd_nominal, TRet_nominal = self.defined_supply_temperature
            dTHyd_nominal = THyd_nominal - TRet_nominal
            THydSupOld_design = THyd_nominal
            QBuiOld_flow_design = QBui_flow_design
        modifier = (
            f"  hydraulic(redeclare {transfer_system_type}),\n"
            f"  THyd_nominal={THyd_nominal},\n"
            f"  dTHyd_nominal={dTHyd_nominal},"
            f"  systemParameters(\n"
            "    QBuiOld_flow_design={%s}, THydSupOld_design={%s})" % (QBuiOld_flow_design, THydSupOld_design)
        )

        return f"{modifier},\n{building_modifier}"

    def get_name(self):
        name = self.record_name.split(".")[-1]
        if self.use_normative_infiltration:
            return name + "ConVen"
        return name

    def get_heating_load(
            self,
            TOda_nominal: float,
            TRoom_nominal: float = 293.15,
            TSoil: float = 286.15
    ):
        """
        From TEASER:
        heat_load_outside_factor : float [W/K]
            Factor needed for recalculation of the heat load of the thermal zone.
            This can be used to recalculate the thermalzones heat load inside
            Modelica export for parametric studies. This works only together with
            heat_load_ground_factor.

            heat_load = heat_load_outside_factor * (t_inside - t_outside) +
            heat_load_ground_factor * (t_inside - t_ground).
        heat_load_ground_factor : float [W/K]
            Factor needed for recalculation of the heat load of the thermal zone.
            This can be used to recalculate the thermalzones heat load inside
            Modelica export for parametric studies. See heat_load_outside_factor.
        """
        if self.building_parameters is None:
            raise ValueError("You first have to create the building models using"
                             "`create_buildings` to calculate the heat load")
        return (
                self.building_parameters.heat_load_outside_factor * (TRoom_nominal - TOda_nominal) +
                self.building_parameters.heat_load_ground_factor * (TRoom_nominal - TSoil)
        )

    def get_internal_gains_from_teaser(self):
        return self.package_path.parent.joinpath(
            self.get_teaser_name(), f"InternalGains_{self.get_teaser_name()}.txt"
        )

    def get_teaser_name(self):
        try:
            _ = int(self.name[0])
            return "B" + self.name
        except ValueError:
            return self.name  # First value is non-numeric
