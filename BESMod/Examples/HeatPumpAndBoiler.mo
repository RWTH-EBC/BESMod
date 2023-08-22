within BESMod.Examples;
package HeatPumpAndBoiler "Bivalent Heat Pump System with Gas Boiler"
  extends Modelica.Icons.ExamplesPackage;

  record ParametersToChange
    extends Systems.RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition;
    // 1. Add parameters like this (WITH Evaluate=false)!
    // parameter Modelica.SIunits.Volume V=0.5 annotation(Evaluate=false);
    // 2. Overwrite the default parameter in the system simulation
    // via the graphical interface, resulting in e.g.
    // Distribution.parameters.V = parameterStudy.V

    parameter Modelica.Units.SI.Temperature TCutOff=263.15 "Cut off temperature"
      annotation (Evaluate=false);
    parameter Modelica.Units.SI.Temperature TBiv=268.15 "Bivalence temperature"
      annotation (Evaluate=false);
    parameter Real VPerQFlow=23.5 "Litre of storage volume per kilowatt thermal power demand" annotation(Evaluate=false);
    parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff=3000
      annotation (Evaluate=false);
    parameter Modelica.Units.SI.HeatFlowRate QHP_flow_biv=4000
      annotation (Evaluate=false);
  end ParametersToChange;

  record AachenSystem
    extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
      use_elecHeating=false,
      nZones=1,
      filNamWea=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/WeatherData/TRY2015_507931060546_Jahr_City_Aachen_Normal.mos"),
      QBui_flow_nominal={10632.414942943078},
      use_ventilation=false,
      THydSup_nominal={328.15},
      TOda_nominal=265.35);

  end AachenSystem;

  model Parallel
    "Bivalent Heat Pump Systems with parallel heat generation"
    extends BaseClasses.PartialHybridSystem(
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel
          generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
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
          redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi,
          redeclare model PerDataMainHP =
              AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
              QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,
              refrigerant="Propane",
              flowsheet="VIPhaseSeparatorFlowsheet"),
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen,
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayVal),
        redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
          distribution(
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoDHW(dTLoadingHC1=10),
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayVal)));

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end Parallel;

  model Serial "Bivalent Heat Pump Systems with serial heat generation"
    extends BaseClasses.PartialHybridSystem(
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSerial
          generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
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
          redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi,
          redeclare model PerDataMainHP =
              AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
              QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,
              refrigerant="Propane",
              flowsheet="VIPhaseSeparatorFlowsheet"),
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen),
        redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
          distribution(
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoDHW(dTLoadingHC1=10),
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayVal)));

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end Serial;

  model AfterBufferWithDHW
    "Bivalent Heat Pump System with boiler integration after buffer tank without DHW support"
    extends BaseClasses.PartialHybridSystem(
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPump
          generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
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
          redeclare model PerDataMainHP =
              AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
              QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,
              refrigerant="Propane",
              flowsheet="VIPhaseSeparatorFlowsheet"),
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen),
        control(boiInGeneration=false),
        redeclare Systems.Hydraulical.Distribution.TwoStoragesBoilerWithDHW
          distribution(
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
            parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
            parStoDHW(dTLoadingHC1=10),
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayVal,
          dTBoiDHWLoa=10,
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayValBoi,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
            parHydSep,
          redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi)));

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end AfterBufferWithDHW;

  model AfterBufferWithoutDHW
    "Bivalent Heat Pump System with boiler integration after buffer tank without DHW support"
    extends BaseClasses.PartialHybridSystem(
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPump
          generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
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
          redeclare model PerDataMainHP =
              AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
              QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,
              refrigerant="Propane",
              flowsheet="VIPhaseSeparatorFlowsheet"),
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen),
        control(boiInGeneration=false),
        redeclare Systems.Hydraulical.Distribution.TwoStoDetailedDirectLoading
          distribution(
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
            parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
            parStoDHW(dTLoadingHC1=10),
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayVal,
          heaAftBufTyp=BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler,
          redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi)));

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end AfterBufferWithoutDHW;

  package BaseClasses "Contains partial example case"
    extends Modelica.Icons.BasesPackage;
    partial model PartialHybridSystem "Partial bivalent heat pump system"
      extends Systems.BaseClasses.PartialBuildingEnergySystem(
        redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
        redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
            BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
              heaLoadFacGrd=0, heaLoadFacOut=0)),
        redeclare BESMod.Systems.Control.NoControl control,
        redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
          redeclare Systems.Hydraulical.Control.HybridHeatPumpSystem control(
            redeclare
              BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
              valCtrl,
            redeclare
              BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
              parTheVal,
            dTHysBui=5,
            dTHysDHW=5,
            meaValPriGen=BESMod.Systems.Hydraulical.Control.Components.MeasuredValue.GenerationSupplyTemperature,
            redeclare model DHWHysteresis =
                BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.ConstantHysteresisTimeBasedHeatingRod,
            redeclare model BuildingHysteresis =
                BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.ConstantHysteresisTimeBasedHeatingRod,
            redeclare model DHWSetTemperature =
                BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW,
            redeclare
              BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
              parPIDHeaPum,
            TBiv=parameterStudy.TBiv,
            boiInGeneration=true,
            redeclare
              BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
              safetyControl,
            TCutOff=parameterStudy.TCutOff,
            redeclare
              BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicBoilerPI
              parPIDBoi),
          redeclare final Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
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
        redeclare UseCaseDesignOptimization.AachenSystem systemParameters(
            use_ventilation=true),
        redeclare UseCaseDesignOptimization.ParametersToChange parameterStudy,
        redeclare final package MediumDHW = AixLib.Media.Water,
        redeclare final package MediumZone = AixLib.Media.Air,
        redeclare final package MediumHyd = AixLib.Media.Water,
        redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

      annotation (experiment(
          StopTime=31536000,
          Interval=600,
          __Dymola_Algorithm="Dassl"));
    end PartialHybridSystem;
  end BaseClasses;
end HeatPumpAndBoiler;
