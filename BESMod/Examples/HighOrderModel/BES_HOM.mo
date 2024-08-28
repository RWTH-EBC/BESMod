within BESMod.Examples.HighOrderModel;
model BES_HOM
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.AixLibHighOrder building(
      energyDynamicsWalls=Modelica.Fluid.Types.Dynamics.FixedInitial,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      useConstVentRate=false,
      TimeCorrection=0,
      DiffWeatherDataTime=Modelica.Units.Conversions.to_hour(weaDat.timZon),
      redeclare AixLib.DataBase.Walls.Collections.OFD.EnEV2009Heavy wallTypes,
      redeclare model WindowModel =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.WindowSimple,
      redeclare AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2009
        Type_Win,
      redeclare model CorrSolarGainWin =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorGSimple,
      redeclare BESMod.Systems.Demand.Building.Components.AixLibHighOrderOFD
        HOMBuiEnv),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum(
          genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,

          TBiv=parameterStudy.TBiv,
          scalingFactor=hydraulic.generation.parHeaPum.QPri_flow_nominal/
              parameterStudy.QHP_flow_biv,
          dpCon_nominal=0,
          dpEva_nominal=0,
          use_refIne=false,
          refIneFre_constant=0),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea,
        redeclare model PerDataMainHP =
            AixLib.Obsolete.Year2024.DataBase.HeatPump.PerformanceData.VCLibMap
            (
            QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,
            refrigerant="Propane",
            flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen),
      redeclare BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoDHW(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal),
      redeclare BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra)),
    redeclare BESMod.Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles userProfiles(
        redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
        redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile),
    redeclare HOMSystem systemParameters,
    redeclare DesignOptimization.ParametersToChange parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  extends Modelica.Icons.Example;
  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HighOrderModel/BES_HOM.mos"
        "Simulate and plot"));
end BES_HOM;
