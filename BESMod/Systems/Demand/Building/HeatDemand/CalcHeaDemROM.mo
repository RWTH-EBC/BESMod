within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeaDemROM
  "Calculate the heat demand for a given reduced order model from TEASER"
  extends PartialCalcHeatingDemand(
    TN_heater=building.zoneParam[1].TNHeat,
    KR_heater=building.zoneParam[1].KRHeat,
    h_heater=building.zoneParam.hHeat*10,
    redeclare BESMod.Examples.BAUSimStudy.BESParameters
      systemParameters(
      QDHW_flow_nomial=0,
      TOda_nominal=261.05,
      THydSup_nominal={328.15}),
    redeclare BESMod.Systems.Demand.Building.TEASERThermalZone
      building(
      nZones=1,
      redeclare BESMod.Examples.BAUSimStudy.Buildings.Case_1_standard
        oneZoneParam,
      final ventRate=0.5 .- building.zoneParam.baseACH));
  extends Modelica.Icons.Example;

  annotation (Documentation(info="<html>
<p>In order to use this model, choose a number of zones and pass a zoneParam from TEASER for every zone. Further specify the nominal heat outdoor air temperature in the system parameters or pass your custom systemParameters record.</p>
</html>"));
end CalcHeaDemROM;
