within BESMod.Systems.BaseClasses.TEASERExport;
partial model PartialHeatPumpMonoenergetic
  "Partial model for TEASER export with monoenergetic heat pump"
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare replaceable BESMod.Systems.Demand.Building.TEASERThermalZone
      building(
      hBui=0.1,
      ABui=0.1,
      ARoo=0.1),
    redeclare BESMod.Systems.Electrical.ElectricalSystem electrical(
      redeclare BESMod.Systems.Electrical.Distribution.OwnConsumption
        distribution,
      redeclare BESMod.Systems.Electrical.Generation.PVSystemMultiSub
        generation(
        redeclare model CellTemperature =
            AixLib.Electrical.PVSystem.BaseClasses.CellTemperatureMountingContactToGround,

        redeclare AixLib.DataBase.SolarElectric.SchuecoSPV170SME1 pVParameters,

        lat=weaDat.lat,
        lon=weaDat.lon,
        alt=weaDat.alt,
        timZon=weaDat.timZon,
        ARoo=building.ARoo/2),
      redeclare BESMod.Systems.Electrical.Transfer.NoElectricalTransfer
        transfer,
      redeclare BESMod.Systems.Electrical.Control.NoControl control),
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
      redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      use_hydraulic=true,
      use_ventilation=true,
      use_elecHeating=false,
      QBui_flow_nominal=building.QRec_flow_nominal),
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare final package MediumDHW = IBPSA.Media.Water,
    redeclare final package MediumZone = IBPSA.Media.Air,
    redeclare final package MediumHyd = IBPSA.Media.Water,
    redeclare BESMod.Systems.Ventilation.VentilationSystem ventilation(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare
        BESMod.Systems.Ventilation.Generation.ControlledDomesticVentilation
        generation(
        m_flow_nominal={sum(building.AZone .* building.hZone .* 0.5 ./ 3600 .*
            1.225)},
        redeclare
          BESMod.Systems.Ventilation.Generation.RecordsCollection.DummyHeatExchangerRecovery
          parameters,
        redeclare IBPSA.Fluid.Actuators.Valves.ThreeWayLinear threeWayValve_b,
        redeclare IBPSA.Fluid.Actuators.Valves.ThreeWayLinear threeWayValve_a,
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          threeWayValveParas,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          tempSensorData),
      redeclare BESMod.Systems.Ventilation.Distribution.SimpleDistribution
        distribution(redeclare BESMod.Systems.RecordsCollection.Movers.DPConst
          fanData),
      redeclare BESMod.Systems.Ventilation.Control.SummerPIDByPass control(
          use_bypass=false)));

  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>This is a partial model representing a monoenergetic heat pump system for the TEASER export example <code>HeatPumpMonoenergetic</code>. It implements the following subsystems:</p>

<ul>
<li>Electrical system with PV generation</li>
<li>Heat pump based hydraulic system with electric backup heater and thermal storage</li>
<li>Domestic hot water system with standard tapping profile</li>
<li>Ventilation system with heat recovery</li>
<li>Control system for DHW superheating</li>
<li>Building: <a href=\"modelica://BESMod.Systems.Demand.Building.TEASERThermalZone\">TEASERThermalZone</a> (Automatically set by TEASER)</li>
<li>User Profiles: <a href=\"modelica://BESMod.Systems.UserProfiles.TEASERProfiles\">TEASERProfiles</a> (Automatically set by TEASER)</li>
</ul>

<h4>Important Parameters</h4>
<ul>
<li>Heat pump bivalence temperature: -2 degC (271.15 K)</li>
<li>DHW setpoint temperature: Defined in systemParameters.TSetDHW</li>
<li>PV array area: Half of building roof area (building.ARoo/2)</li>
<li>Ventilation air exchange rate: 0.5/h</li>
<li>Storage loading temperature differences:
  <ul>
    <li>Buffer storage: 0 K</li>
    <li>DHW storage: 10 K</li>
  </ul>
</li>
<li><a href=\"modelica://AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN255.Vitocal350AWI114\">Heat pump performance data (Vitocal 350 A)</a></li>
<li><a href=\"modelica://AixLib.DataBase.SolarElectric.SchuecoSPV170SME1\">PV module data (Schueco SPV 170SME1)</a></li>
</ul>
</html>"));
end PartialHeatPumpMonoenergetic;
