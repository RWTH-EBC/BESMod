within BESMod.Examples.UseCaseAachen;
model BES
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem
      hydraulic(
      redeclare Systems.Hydraulical.Generation.HeatPumpAndHeatingRod generation(
        redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpData,
        redeclare package Medium_eva = AixLib.Media.Air,
        use_pressure=false,
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
      redeclare Systems.Hydraulical.Control.PartBiv_PI_ConOut_HPS control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          thermostaticValveController,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
          thermostaticValveParameters,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
          bivalentControlData(TBiv=parameterStudy.TBiv),
        redeclare
          Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
          TSet_DHW,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl,
        TCutOff=parameterStudy.TCutOff,
        QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.heatPumpParameters.scalingFactor),
      redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          bufParameters(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          dhwParameters(dTLoadingHC1=10)),
      redeclare Systems.Hydraulical.Transfer.RadiatorTransferSystem transfer(
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters, redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpData)),
    redeclare Systems.Demand.DHW.DHW DHW(
      use_pressure=false,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData,
      redeclare
        BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles(redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile),
    redeclare AachenSystem systemParameters,
    redeclare ParametersToChange parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation
      ventilation);

  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end BES;
