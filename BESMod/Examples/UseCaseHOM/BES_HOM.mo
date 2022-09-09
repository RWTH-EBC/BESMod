within BESMod.Examples.UseCaseHOM;
model BES_HOM
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.AixLibHighOrder building(
      useConstVentRate=false,
      Latitude=Modelica.Units.Conversions.to_deg(weaDat.lat),
      Longitude=Modelica.Units.Conversions.to_deg(weaDat.lon),
      TimeCorrection=0,
      DiffWeatherDataTime=Modelica.Units.Conversions.to_hour(weaDat.timZon),
      redeclare PCMgoesHIL.DataBase.WallsAndWindows.EnEV2009Heavy_AddIsulation
        wallTypes,
      redeclare model WindowModel =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.WindowSimple,
      redeclare AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2009
        Type_Win,
      redeclare model CorrSolarGainWin =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorGSimple,
      redeclare BESMod.Systems.Demand.Building.Components.AixLibHighOrderOFD
        aixLiBHighOrderOFD),
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
          useAirSource=true,
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
            flowsheet="VIPhaseSeparatorFlowsheet")),
      redeclare BESMod.Systems.Hydraulical.Control.ConstHys_OnOff_HPSControll
        control(
        redeclare
          PCMgoesHIL.Systems.Hydraulic.Control.Components.ThermostaticValveControlHIL
          thermostaticValveController,
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
        distribution(redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          bufParameters(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          dhwParameters(dTLoadingHC1=10)),
      redeclare BESMod.Systems.Hydraulical.Transfer.RadiatorTransferSystem
        transfer(redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters, redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
    redeclare BESMod.Systems.Demand.DHW.DHW DHW(
      use_pressure=false,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles
                                                         userProfiles(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM
        DHWProfile),
    redeclare HOMSystem systemParameters,
    redeclare PCMgoesHIL.UseCaseHOM.ParametersToChange parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end BES_HOM;
