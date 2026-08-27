within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeaBuiRoomCase600FF
  "Calculate the heat demand for a given reduced order model from TEASER"
  extends PartialCalcHeatingDemand(
    redeclare BESMod.Systems.UserProfiles.Case600Profiles heaDemSce,
    h_heater={10000},
    redeclare
      BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(TOda_nominal=265.35, use_ventilation=false),
    redeclare
      BESMod.Systems.Demand.Building.BuildingsRoomCase600FF
      building(natInf=0.5, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
  extends Modelica.Icons.Example;

  annotation (Documentation(info="<html>
<p>In order to use this model, choose a number of zones and pass a zoneParam from TEASER for every zone. Further specify the nominal heat outdoor air temperature in the system parameters or pass your custom systemParameters record.</p>
</html>"));
end CalcHeaBuiRoomCase600FF;
