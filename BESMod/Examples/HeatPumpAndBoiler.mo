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

  model Serial "Bivalent Heat Pump Systems with serial heat generation"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSerial
          generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
            parHeaPum(
            genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
            TBiv=parameterStudy.TBiv,
            scalingFactor=hydraulic.generation.parHeaPum.QPri_flow_nominal
                /parameterStudy.QHP_flow_biv,
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
        redeclare Systems.Hydraulical.Control.NewControlBivalentSerial control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            thermostaticValveController,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
            parTheVal,
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
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.parHeaPum.scalingFactor,
          CheckTCut_Off(threshold=parameterStudy.TCutOff)),
        redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
          distribution(
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoDHW(dTLoadingHC1=10),
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
      redeclare UseCaseDesignOptimization.AachenSystem systemParameters(
          use_ventilation=true),
      redeclare UseCaseDesignOptimization.ParametersToChange parameterStudy,
      redeclare final package MediumDHW = AixLib.Media.Water,
      redeclare final package MediumZone = AixLib.Media.Air,
      redeclare final package MediumHyd = AixLib.Media.Water,
      redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end Serial;

  model BoilerAfterBufferWithoutDHW
    "Bivalent Heat Pump System with boiler integration after buffer tank without DHW support"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPump generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
          redeclare package Medium_eva = AixLib.Media.Air,
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
            parHeaPum(
            genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
            TBiv=parameterStudy.TBiv,
            scalingFactor=hydraulic.generation.parHeaPum.QPri_flow_nominal
                /parameterStudy.QHP_flow_biv,
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
        redeclare
          Systems.Hydraulical.Control.NewControlBivalentSystem_BoilerAfterBuffer
          control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            thermostaticValveController,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
            parTheVal,
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
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.parHeaPum.scalingFactor,
          CheckTCut_Off(threshold=parameterStudy.TCutOff)),
        redeclare Systems.Hydraulical.Distribution.TwoStoragesBoilerWithoutDHW
          distribution(
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoDHW(dTLoadingHC1=10),
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
      redeclare UseCaseDesignOptimization.AachenSystem systemParameters(
          use_ventilation=true),
      redeclare UseCaseDesignOptimization.ParametersToChange parameterStudy,
      redeclare final package MediumDHW = AixLib.Media.Water,
      redeclare final package MediumZone = AixLib.Media.Air,
      redeclare final package MediumHyd = AixLib.Media.Water,
      redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end BoilerAfterBufferWithoutDHW;

  model Parallel "Bivalent Heat Pump System with parallel heat generation"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel
          generation(
          use_heaRod=false,
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
            parPum,
          redeclare package Medium_eva = AixLib.Media.Air,
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
            parHeaPum(
            genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
            TBiv=parameterStudy.TBiv,
            scalingFactor=hydraulic.generation.parHeaPum.QPri_flow_nominal
                /parameterStudy.QHP_flow_biv,
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
            parTemSen,
          redeclare
            BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayVal,
          threeWayValveWithFlowReturn(redeclare
              BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
              parameters(
              m_flow_nominal=2*m_flow_nominal[1],
              dp_nominal={parHeaPum.dpCon_nominal,boilerNoControl.dp_nominal},
              use_inputFilter=true,
              order=1))),
        redeclare Systems.Hydraulical.Control.NewControlBivalentParallel
          control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            thermostaticValveController,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
            parTheVal,
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
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.parHeaPum.scalingFactor,
          CheckTCut_Off(threshold=parameterStudy.TCutOff)),
        redeclare
          Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
          distribution(
          nParallelSup=1,
          dpSup_nominal={2*(hydraulic.distribution.parThrWayVal.dpValve_nominal
               + max(hydraulic.distribution.parThrWayVal.dp_nominal))},
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            parStoDHW(dTLoadingHC1=10),
          redeclare
            BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
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
      redeclare UseCaseDesignOptimization.AachenSystem systemParameters(
          use_ventilation=true),
      redeclare UseCaseDesignOptimization.ParametersToChange parameterStudy(TCutOff=
            262.15, TBiv=276.15),
      redeclare final package MediumDHW = AixLib.Media.Water,
      redeclare final package MediumZone = AixLib.Media.Air,
      redeclare final package MediumHyd = AixLib.Media.Water,
      redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end Parallel;

  model BoilerAfterBufferWithDHW
    "Bivalent Heat Pump System with boiler integration after buffer tank with DHW support"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPump generation(
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
        redeclare
          Systems.Hydraulical.Control.NewControlBivalentSystem_BoilerAfterBuffer
          control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            thermostaticValveController,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
            parTheVal,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
            bivalentControlData(TBiv=parameterStudy.TBiv),
          redeclare
            Systems.Hydraulical.Control.Components.DHWSetControl.AntiLegionellaControl
            TSet_DHW(triggerEvery(displayUnit="d") = 259200),
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
            safetyControl,
          TCutOff=parameterStudy.TCutOff,
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.parHeaPum.scalingFactor,

          CheckTCut_Off(threshold=parameterStudy.TCutOff)),
        redeclare Systems.Hydraulical.Distribution.TwoStoragesBoilerWithDHW
          distribution(
          designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage,

          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayVal,
          redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi,

          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
          QDHWStoLoss_flow=1,
          VStoDHW(displayUnit="l") = 0.1,
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen,
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayValBoi,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
            parStoBuf,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
            parStoDHW(dTLoadingHC1=10),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
            parHydSep),
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
      redeclare UseCaseDesignOptimization.AachenSystem systemParameters(
          use_ventilation=true),
      redeclare UseCaseDesignOptimization.ParametersToChange parameterStudy(
          TCutOff=262.15, TBiv=276.15),
      redeclare final package MediumDHW = AixLib.Media.Water,
      redeclare final package MediumZone = AixLib.Media.Air,
      redeclare final package MediumHyd = AixLib.Media.Water,
      redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end BoilerAfterBufferWithDHW;

end HeatPumpAndBoiler;
