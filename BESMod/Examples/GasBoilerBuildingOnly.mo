within BESMod.Examples;
model GasBoilerBuildingOnly
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.TEASERThermalZone building(
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ABui=sum(building.zoneParam.VAir)^(2/3),
      ARoo=sum(building.zoneParam.ARoof),
      redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.Hydraulical.Generation.GasBoiler generation(
        dTTra_nominal={10},
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum),
      redeclare BESMod.Systems.Hydraulical.Control.GasBoiler control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicBoilerPI
          parPID,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.PID
          PIDCtrl),
      redeclare BESMod.Systems.Hydraulical.Distribution.BuildingOnly distribution(
          nParallelDem=1),
      redeclare BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
        transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad)),
    redeclare BESMod.Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough calcmFlow),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      QBui_flow_nominal=building.QRec_flow_nominal,
      THydSup_nominal={338.15},
      use_ventilation=false,
      use_dhw=false,
      use_elecHeating=false));

  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/GasBoilerBuildingOnly.mos"
        "Simulate and plot"), Documentation(info="<html>
  <h4>Information</h4>
  <p>
    This model represents a building energy system featuring a gas boiler for space heating. The building model uses the TEASER thermal zone representation of a building located in Aachen, Germany. The system only models space heating without ventilation, domestic hot water or electrical heating.
  </p>

  <h4>Key Components</h4>
  <ul>
    <li>Generation: <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.GasBoiler\">Gas Boiler</a></li>
    <li>Distribution: <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.BuildingOnly\">Building Only Distribution</a></li>
    <li>Heat Transfer: <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased\">Pressure-based Radiator</a></li>
    <li>Building Model: <a href=\"modelica://BESMod.Systems.Demand.Building.TEASERThermalZone\">TEASER Thermal Zone</a></li>
  </ul>
</html>"));
end GasBoilerBuildingOnly;
