within BESMod.Examples.DesignOptimization;
model BES
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      ABui=sum(building.zoneParam.VAir)^(2/3),
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ARoo=sum(building.zoneParam.ARoof),
      redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        redeclare package MediumEva = AixLib.Media.Air,
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D
            (y_nominal=0.8, redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableDataSDF.TableData3D.VCLibPy.VCLibVaporInjectionPhaseSeparatorPropane
              datTab),
        genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,

        TBiv=parameterStudy.TBiv,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen(transferHeat=true)),
      redeclare Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        redeclare model BuildingSupplySetTemperature =
            BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve,
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
          parPIDHeaPum),
      redeclare Systems.Hydraulical.Distribution.SimpleTwoStorageParallel
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
          parRad)),
    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare AachenSystem systemParameters,
    redeclare ParametersToChange parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=172800,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/DesignOptimization/BES.mos"
        "Simulate and plot"));
end BES;
