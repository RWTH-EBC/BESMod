within BESMod.Examples.UseCaseAachenTimeBased;
model BES
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.TEASERThermalZone building(
        redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0)),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare BESMod.Systems.Hydraulical.Generation.HeatPumpAndHeatingRod
        generation(
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          heatPumpParameters(genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodParameters,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
        redeclare package Medium_eva = AixLib.Media.Air),
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
          bivalentControlData(
          dTHysBui=parameterStudy.dTHysBuf,
          dTHysDHW=parameterStudy.dTHysDHW,
          dtHeaRodBui=parameterStudy.dt_hrBuf,
          dtHeaRodDHW=parameterStudy.dt_hrDHW),
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
          TSet_DHW),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          bufParameters(dTLoadingHC1=0),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          dhwParameters(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          threeWayValveParameters),
      redeclare BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator
        transfer(redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters, redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
    redeclare BESMod.Systems.Demand.DHW.DHW DHW(
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough calcmFlow),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESMod.Examples.UseCaseAachenTimeBased.ParametersToChange
      parameterStudy,
    redeclare BESMod.Examples.UseCaseAachen.AachenSystem systemParameters)
    annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));

  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end BES;
