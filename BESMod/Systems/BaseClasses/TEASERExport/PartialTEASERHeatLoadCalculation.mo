within BESMod.Systems.BaseClasses.TEASERExport;
partial model PartialTEASERHeatLoadCalculation
  "Partial model for TEASER heat load calculation based on Examples.TEASERHeatLoadCalculation.PartialCalculation"
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      QBui_flow_nominal=building.QRec_flow_nominal,
      use_hydraulic=false,
      use_ventilation=false),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare BESMod.Systems.Hydraulical.Generation.NoGeneration generation,
      redeclare BESMod.Systems.Hydraulical.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.Distribution.BuildingOnly
        distribution(nParallelDem=1),
      redeclare BESMod.Systems.Hydraulical.Transfer.NoHeatTransfer transfer(
          nParallelSup=1)),
    redeclare BESMod.Systems.Electrical.ElectricalSystem electrical(
      redeclare BESMod.Systems.Electrical.Generation.NoGeneration generation,
      redeclare BESMod.Systems.Electrical.Distribution.DirectlyToGrid
        distribution,
      redeclare BESMod.Systems.Electrical.Transfer.IdealHeater transfer(
          TN_heater=120),
      redeclare BESMod.Systems.Electrical.Control.IdealHeater control),
    redeclare BESMod.Systems.Demand.DHW.StandardProfiles DHW(
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough calcmFlow,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.NoDHW DHWProfile),
    redeclare replaceable BESMod.Systems.Demand.Building.TEASERThermalZone building,
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy);

  extends Modelica.Icons.Example;

end PartialTEASERHeatLoadCalculation;
