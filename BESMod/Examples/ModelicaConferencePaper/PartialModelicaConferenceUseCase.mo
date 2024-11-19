within BESMod.Examples.ModelicaConferencePaper;
partial model PartialModelicaConferenceUseCase
  "Partial model to be extended to replace single subsystems"
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.ElectricalSystem electrical(
      redeclare Systems.Electrical.Distribution.BatterySystemSimple
        distribution(redeclare
          BuildingSystems.Technologies.ElectricalStorages.Data.LithiumIon.LithiumIonTeslaPowerwall1
          batteryParameters),
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
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
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
      redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
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
        dTTra_nominal=fill(10, hydraulic.transfer.nParallelDem),
        f_design=fill(1.2, hydraulic.transfer.nParallelDem),
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra)),
    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare final BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM
        DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Examples.ModelicaConferencePaper.BESModSystemParas
      systemParameters(use_elecHeating=false),
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
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover fanData,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          tempSensorData),
      redeclare BESMod.Systems.Ventilation.Distribution.SimpleDistribution
        distribution(m_flow_nominal=building.AZone .* building.hZone .* 0.5 ./
            3600 .* 1.225),
      redeclare BESMod.Systems.Ventilation.Control.SummerPIDByPass control(
          use_bypass=false)));


  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>This is a partial model representing a building energy system (BES) example case study. It implements the following subsystems:</p>

<ul>
<li>Electrical system with PV generation and battery storage (Tesla Powerwall)</li>
<li>Heat pump based hydraulic system with electric backup heater and thermal storage</li>
<li>Domestic hot water system with standard tapping profile</li>
<li>Ventilation system with heat recovery</li>
<li>Control system for DHW superheating</li>
</ul>

<h4>Important Parameters</h4>
<ul>
<li>Heat pump bivalence temperature: -2°C (271.15 K)</li>
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
<li><a href=\"modelica://BuildingSystems.Technologies.ElectricalStorages.Data.LithiumIon.LithiumIonTeslaPowerwall1\">Battery data (Tesla Powerwall 1)</a></li>
<li><a href=\"modelica://AixLib.DataBase.SolarElectric.SchuecoSPV170SME1\">PV module data (Schueco SPV 170SME1)</a></li>
</ul>
</html>"));
end PartialModelicaConferenceUseCase;
