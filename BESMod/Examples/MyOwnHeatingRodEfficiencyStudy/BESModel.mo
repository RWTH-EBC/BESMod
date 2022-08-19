within BESMod.Examples.MyOwnHeatingRodEfficiencyStudy;
model BESModel
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.TEASERThermalZone
      building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0)),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Ventilation.NoVentilation
      ventilation,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem
      hydraulic(
      redeclare
        BESMod.Systems.Hydraulical.Generation.HeatPumpAndHeatingRod
        generation(
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.LookUpTable2D (dataTable=
               AixLib.DataBase.HeatPump.EN255.Vitocal350AWI114()),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          heatPumpParameters(genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel,
            TBiv=266.15),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodParameters(eta_hr=parameterStudy.efficiceny_heating_rod),
        redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpData,
        redeclare package Medium_eva = AixLib.Media.Air),
      redeclare
        BESMod.Systems.Hydraulical.Control.Biv_PI_ConFlow_HPSController
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
          bivalentControlData),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          bufParameters(dTLoadingHC1=10), redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          dhwParameters(dTLoadingHC1=10)),
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RadiatorTransferSystem
        transfer(redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters, redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpData)),
    redeclare BESMod.Systems.Demand.DHW.DHW DHW(redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData, redeclare
        BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough
        calcmFlow),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles
      userProfiles(redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile),
    redeclare
      BESMod.Examples.MyOwnHeatingRodEfficiencyStudy.SimpleStudyOfHeatingRodEfficiency
      parameterStudy,
    redeclare
      BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      THydSup_nominal={328.15},                  use_ventilation=false,
      use_elecHeating=false));
  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=86400,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end BESModel;
