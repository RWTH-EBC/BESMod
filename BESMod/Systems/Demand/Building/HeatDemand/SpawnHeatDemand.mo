within BESMod.Systems.Demand.Building.HeatDemand;
model SpawnHeatDemand
  extends PartialCalcHeatingDemand(
    redeclare BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      nZones=6,
      QBui_flow_nominal={10632.414942943078,0,0,0,0,0},
      THydSup_nominal={328.15,328.15,328.15,328.15,328.15,328.15}),
    redeclare BESMod.Systems.Demand.Building.SpwanWithParameters building(
      AZone={0,0,0,0,0,0},
      hZone={0,0,0,0,0,0},
      ABui=0,
      hBui=0,
      ARoo=0,
      weaName=systemParameters.filNamWea),
    redeclare BESMod.Systems.UserProfiles.Case600Profiles heaDemSce,
    h_heater={100000,100000,100000,100000,100000,100000});
end SpawnHeatDemand;
