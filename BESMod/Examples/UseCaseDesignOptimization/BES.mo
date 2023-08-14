within BESMod.Examples.UseCaseDesignOptimization;
model BES
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
          heaLoadFacGrd=0, heaLoadFacOut=0)),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare Systems.Hydraulical.Generation.HeatPumpAndHeatingRod generation(
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
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
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          parHeaRod,
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
            QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,
            refrigerant="Propane",
            flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen),
      redeclare Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
          parTheVal,
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.PartParallelBivalent
            (
            TCutOff=parameterStudy.TCutOff,
            TBiv=parameterStudy.TBiv,
            TOda_nominal=systemParameters.TOda_nominal,
            TRoom=systemParameters.TSetZone_nominal[1],
            QDem_flow_nominal=systemParameters.QBui_flow_nominal[1],
            QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff),
        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.PartParallelBivalent
            (
            TCutOff=parameterStudy.TCutOff,
            TBiv=parameterStudy.TBiv,
            TOda_nominal=systemParameters.TOda_nominal,
            TRoom=systemParameters.TSetZone_nominal[1],
            QDem_flow_nominal=systemParameters.QBui_flow_nominal[1],
            QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff),
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl),
      redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoBuf(
          VPerQ_flow=parameterStudy.VPerQFlow,
          dTLoadingHC1=0,
          energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.B),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoDHW(dTLoadingHC1=10, energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.A),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal),
      redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters, redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum)),
    redeclare Systems.Demand.DHW.DHW DHW(
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare AachenSystem systemParameters(use_ventilation=true),
    redeclare ParametersToChange parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end BES;
