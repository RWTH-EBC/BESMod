within BESMod.Systems.Hydraulical;
model FMIHydraulicSystemModelicaConferenceUseCase
  extends FMIReplaceableHydraulicSystem(
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare package Medium = IBPSA.Media.Water,
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
          dpCon_nominal=0,
          dpEva_nominal=0,
          use_refIne=false,
          refIneFre_constant=0),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodParameters,
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.LookUpTable2D (dataTable=
                AixLib.DataBase.HeatPump.EN255.Vitocal350AWI114()),
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          temperatureSensorData),
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
      redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
        dTTra_nominal=fill(10, hydraulic.transfer.nParallelDem),
        f_design=fill(1.2, hydraulic.transfer.nParallelDem),
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData),
        redeclare
      BESMod.Systems.Hydraulical.RecordsCollection.HydraulicSystemBaseDataDefinition
      hydraulicSystemParameters(
        nZones=1,
        Q_flow_nominal(displayUnit="W") = {10632.414942943078},
        AZone(displayUnit="m^2") = {185.9548},
        hZone(displayUnit="m") = {2.6},
        ABui(displayUnit="m^2") = 0.0,
        hBui(displayUnit="m") = 0.0,
        TOda_nominal(displayUnit="K") = 265.35,
        TSup_nominal(displayUnit="K") = {328.15},
        TZone_nominal(displayUnit="K") = {293.15},
        TAmb(displayUnit="K") = 293.15,
        ARoo(displayUnit="m^2") = 152.72467724,
        mDHW_flow_nominal(displayUnit="kg/s") = 0.1,
        TDHW_nominal(displayUnit="K") = 323.15,
        TDHWCold_nominal(displayUnit="K") = 283.15,
        VDHWDay(displayUnit="m^3") = 0.123417,
        QDHW_flow_nominal(displayUnit="W") = 16736.0,
        tCrit(displayUnit="s") = 3600.0,
        QCrit = 2.24)));

    parameter Real scalingFactorHP=hydraulic.generation.heatPumpParameters.QPri_flow_nominal
      /13000 "May be overwritten to avoid warnings and thus a fail in the CI";
end FMIHydraulicSystemModelicaConferenceUseCase;
