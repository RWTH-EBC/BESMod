within BESMod.Systems.BaseClasses.TEASERExport;
partial model PartialHeatPumpSimpleHOM
  "Partial model for TEASER export with monoenergetic heat pump, without ventilation and PV"
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles userProfiles,
    redeclare replaceable BESMod.Systems.Demand.Building.AixLibHighOrder building
      constrainedby BESMod.Systems.Demand.Building.BaseClasses.PartialDemand
      "The room resolved building, e.g. AixLibHighOrder or SpawnHighOrder",
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Control.DHWSuperheating control(TSetDHW=
          systemParameters.TSetDHW),
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        dTTra_nominal={10},
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D
            (redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN255.Vitocal350AWI114
              datTab),
        redeclare package MediumEva = AixLib.Media.Air,
        TBiv=271.15,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen),
      redeclare BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Internal,

        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,

        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,

        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.SimpleTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoBuf(dTLoadingHC1=0),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoDHW(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal),
      redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad)),
    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare final BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM
        DHWProfile,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      use_hydraulic=true,
      use_ventilation=false,
      use_elecHeating=false,
      QBui_flow_nominal=building.QRec_flow_nominal),
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare final package MediumDHW = IBPSA.Media.Water,
    redeclare final package MediumZone = IBPSA.Media.Air,
    redeclare final package MediumHyd = IBPSA.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>This is a partial model representing a monoenergetic heat pump system for the TEASER export example <code>HeatPumpSimple</code>: the system of <code>HeatPumpMonoenergetic</code> without mechanical ventilation and without PV, so that it also takes buildings without ventilation ports, such as <a href=\"modelica://BESMod.Systems.Demand.Building.SpawnHighOrder\">SpawnHighOrder</a>. It implements the following subsystems:</p>

<ul>
<li>Electrical system with a direct grid connection</li>
<li>Heat pump based hydraulic system with electric backup heater and thermal storage</li>
<li>Domestic hot water system with standard tapping profile</li>
<li>No ventilation system: the building's air exchange comes from the user profiles</li>
<li>Control system for DHW superheating</li>
<li>Building: the room resolved <a href=\"modelica://BESMod.Systems.Demand.Building.AixLibHighOrder\">AixLibHighOrder</a> or <a href=\"modelica://BESMod.Systems.Demand.Building.SpawnHighOrder\">SpawnHighOrder</a> (Automatically set by TEASER)</li>
<li>User Profiles: <a href=\"modelica://BESMod.Systems.UserProfiles.AixLibHighOrderProfiles\">AixLibHighOrderProfiles</a> (Automatically set by TEASER)</li>
</ul>

<h4>Important Parameters</h4>
<ul>
<li>Heat pump bivalence temperature: -2 degC (271.15 K)</li>
<li>DHW setpoint temperature: Defined in systemParameters.TSetDHW</li>
<li>Storage loading temperature differences:
  <ul>
    <li>Buffer storage: 0 K</li>
    <li>DHW storage: 10 K</li>
  </ul>
</li>
<li><a href=\"modelica://AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN255.Vitocal350AWI114\">Heat pump performance data (Vitocal 350 A)</a></li>
</ul>
</html>"));
end PartialHeatPumpSimpleHOM;
