within BESMod.Examples.UseCaseHighOrderModel;
model BES_HOM
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.AixLibHighOrder building(
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
      redeclare BESMod.Systems.Hydraulical.Generation.HeatPumpAndHeatingRod
        generation(
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          heatPumpParameters(
          genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
          TBiv=parameterStudy.TBiv,
          scalingFactor=hydraulic.generation.heatPumpParameters.QPri_flow_nominal
              /parameterStudy.QHP_flow_biv,
          dpCon_nominal=0,
          dpEva_nominal=0,
          use_refIne=false,
          refIneFre_constant=0),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodParameters,
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
            QCon_flow_nominal=hydraulic.generation.heatPumpParameters.QPri_flow_nominal,
            refrigerant="Propane",
            flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          temperatureSensorData),
      redeclare BESMod.Systems.Hydraulical.Control.ConstHys_OnOff_HPSControll
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
          TSet_DHW),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          bufParameters(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          dhwParameters(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          threeWayValveParameters),
      redeclare BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters, redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
    redeclare BESMod.Systems.Demand.DHW.DHW DHW(
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles userProfiles(
        redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
        redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile),
    redeclare HOMSystem systemParameters,
    redeclare UseCaseDesignOptimization.ParametersToChange parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  extends Modelica.Icons.Example;
  annotation (experiment(
      StopTime=172800,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end BES_HOM;
