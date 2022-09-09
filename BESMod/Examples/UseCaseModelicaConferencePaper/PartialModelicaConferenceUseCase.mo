within BESMod.Examples.UseCaseModelicaConferencePaper;
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
        timZon=3600,
        ARoof=building.ARoo/2),
      redeclare BESMod.Systems.Electrical.Transfer.NoElectricalTransfer
        transfer,
      redeclare BESMod.Systems.Electrical.Control.NoControl control),
    redeclare BESMod.Systems.Control.DHWSuperheating control(TSetDHW=
          systemParameters.TSetDHW),
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare Systems.Hydraulical.Generation.HeatPumpAndHeatingRod generation(
        dTTra_nominal={10},
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,

        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          heatPumpParameters(
          genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,

          TBiv=271.15,
          scalingFactor=scalingFactorHP,
          useAirSource=true,
          dpCon_nominal=0,
          dpEva_nominal=0,
          use_refIne=false,
          refIneFre_constant=0),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodParameters,
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.LookUpTable2D (dataTable=
                AixLib.DataBase.HeatPump.EN255.Vitocal350AWI114())),
      redeclare
        BESMod.Systems.Hydraulical.Control.ConstHys_PI_ConOut_HPSController
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          thermostaticValveController,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
          thermostaticValveParameters,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
          bivalentControlData(dTOffSetHeatCurve=8),
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
          TSet_DHW,
        supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Internal),
      redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          bufParameters(dTLoadingHC1=0),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          dhwParameters(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          threeWayValveParameters),
      redeclare Systems.Hydraulical.Transfer.RadiatorTransferSystem transfer(
        dTTra_nominal=fill(10, hydraulic.transfer.nParallelDem),
        f_design=fill(1.2, hydraulic.transfer.nParallelDem),
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
    redeclare Systems.Demand.DHW.DHW DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare final BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM
        DHWProfile,
      final use_dhwCalc=false,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Examples.UseCaseModelicaConferencePaper.BESModSystemParas
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

 parameter Real scalingFactorHP=hydraulic.generation.heatPumpParameters.QPri_flow_nominal
      /13000                               "May be overwritten to avoid warnings and thus a fail in the CI";


  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialModelicaConferenceUseCase;
