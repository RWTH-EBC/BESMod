within BESMod.Examples.UseCaseModelicaConferencePaper;
partial model PartialModelicaConferenceUseCase
  "Partial model to be extended to replace single subsystems"
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Control.DHWSuperheating control(
        TSetDHW=systemParameters.TSetDHW),
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem
      hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare Systems.Hydraulical.Generation.HeatPumpAndHeatingRod generation(
        dTTra_nominal={10},
        m_flow_nominal=hydraulic.generation.Q_flow_nominal .*hydraulic.generation.f_design
             ./hydraulic.generation.dTTra_nominal  ./ 4184,
        redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpData,
        redeclare package Medium_eva = AixLib.Media.Air,
        use_pressure=false,
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
          bivalentControlData,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
          TSet_DHW,
        supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Internal),
      redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          bufParameters(dTLoadingHC1=0),
          redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          dhwParameters(dTLoadingHC1=10)),
      redeclare Systems.Hydraulical.Transfer.RadiatorTransferSystem transfer(
        dTTra_nominal=fill(10,hydraulic.transfer.nParallelDem),
        m_flow_nominal=hydraulic.transfer.Q_flow_nominal ./ (hydraulic.transfer.dTTra_nominal
             .* 4184),
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters,
        redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpData)),
    redeclare Systems.Demand.DHW.DHW DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      use_pressure=false,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData,
      redeclare
        BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare
      BESMod.Examples.UseCaseModelicaConferencePaper.BESModSystemParas
      systemParameters,
    redeclare
      BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.VentilationSystem
      ventilation(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare
        BESMod.Systems.Ventilation.Generation.ControlledDomesticVentilation
        generation(
        m_flow_nominal={sum(building.AZone .*building.hZone  .* 0.5 ./ 3600 .* 1.225)},
        redeclare
          BESMod.Systems.Ventilation.Generation.RecordsCollection.DummyHeatExchangerRecovery
          parameters,
        redeclare IBPSA.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear
          threeWayValve_b,
        redeclare IBPSA.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear
          threeWayValve_a,
        redeclare
          BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          threeWayValveParas,
        redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          fanData,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          tempSensorData),
      redeclare
        BESMod.Systems.Ventilation.Distribution.SimpleDistribution
        distribution(m_flow_nominal=building.AZone .*building.hZone  .* 0.5 ./
            3600 .* 1.225),
      redeclare
        BESMod.Systems.Ventilation.Control.SummerPIDByPass
        control(use_bypass=false)));

 parameter Real scalingFactorHP=hydraulic.generation.heatPumpParameters.QPri_flow_nominal
      /13000                               "May be overwritten to avoid warnings and thus a fail in the CI";

equation

  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialModelicaConferenceUseCase;
