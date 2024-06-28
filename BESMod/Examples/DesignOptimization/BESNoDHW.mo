within BESMod.Examples.DesignOptimization;
model BESNoDHW "Example to demonstrate usage without DHW"
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      ABui=sum(building.zoneParam.VAir)^(2/3),
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ARoo=sum(building.zoneParam.ARoof),
      redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0),
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare Systems.Hydraulical.Generation.HeatPumpAndElectricHeater generation(
        redeclare model PerDataRevHP =
            AixLib.DataBase.Chiller.PerformanceData.PolynomalApproach (redeclare
              function PolyData =
                AixLib.DataBase.HeatPump.Functions.Characteristics.ConstantCoP
                ( powerCompressor=2000, CoP=2)),
        redeclare
          BESMod.Systems.Hydraulical.Components.Frosting.ZhuIceFacCalculation
          frost(density=200, redeclare function frostMapFunc =
              BESMod.Systems.Hydraulical.Components.Frosting.Functions.ZhuFrostingMapCico),
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
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
          parEleHea,
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
        useSGReady=true,
        useExtSGSig=false,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl),
      redeclare BESMod.Systems.Hydraulical.Distribution.BuildingOnly
        distribution(nParallelDem=1),
      redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra)),
    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare AachenSystem systemParameters(use_ventilation=false, use_dhw=
          false),
    redeclare ParametersToChange parameterStudy(VPerQFlow=1),
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/DesignOptimization/BESNoDHW.mos"
        "Simulate and plot"));
end BESNoDHW;
