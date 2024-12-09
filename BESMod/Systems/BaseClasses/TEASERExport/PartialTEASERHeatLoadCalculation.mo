within BESMod.Systems.BaseClasses.TEASERExport;
partial model PartialTEASERHeatLoadCalculation
  "Partial model for TEASER export heat load calculation"
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

  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Partial model with common interfaces to enable heat load calculation with the TEASER export example <code>TEASERHeatLoadCalculation</code>. 
This model extends the <a href=\"modelica://BESMod.Systems.BaseClasses.PartialBuildingEnergySystem\">PartialBuildingEnergySystem</a> with standard components for simple heat load simulation scenarios.</p>

<h4>Important Parameters</h4>
<ul>
  <li>QBui_flow_nominal: Nominal heat flow rate of the building (automatically set from building model)</li>
  <li>use_hydraulic: Set to false (no hydraulic system used)</li>
  <li>use_ventilation: Set to false (no ventilation system used)</li>
</ul>

<h4>Components</h4>
<ul>
  <li>Building: <a href=\"modelica://BESMod.Systems.Demand.Building.TEASERThermalZone\">TEASERThermalZone</a> (Automatically set by TEASER)</li>
  <li>User Profiles: <a href=\"modelica://BESMod.Systems.UserProfiles.TEASERProfiles\">TEASERProfiles</a> (Automatically set by TEASER)</li>
  <li>Control: <a href=\"modelica://BESMod.Systems.Control.NoControl\">NoControl</a></li>
  <li>Electrical System: Ideal heater configuration with direct grid connection</li>
  <li>DHW: Standard profiles without actual DHW demand</li>
  <li>Hydraulic/Ventilation: Disabled placeholder components</li>
</ul>
</html>"));
end PartialTEASERHeatLoadCalculation;
