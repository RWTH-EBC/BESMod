within BESMod.Examples;
package BivalentHeatPumpSystems "Bivalent Heat Pump System with Gas Boiler"
  extends Modelica.Icons.ExamplesPackage;

  record ParametersToChange
    extends
      Systems.RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition;
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

  model BivalentHeatPumpSystems_Serial
    "Bivalent Heat Pump Systems with serial heat generation"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSerial
          generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
            pumpData,
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
        redeclare Systems.Hydraulical.Control.NewControlBivalentSerial
                                                                    control(
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
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.heatPumpParameters.scalingFactor,
          CheckTCut_Off(threshold=parameterStudy.TCutOff)),
        redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
          distribution(
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            bufParameters(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            dhwParameters(dTLoadingHC1=10),
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            threeWayValveParameters),
        redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
            redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
            radParameters, redeclare
            BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
      redeclare Systems.Demand.DHW.DHW DHW(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
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
  end BivalentHeatPumpSystems_Serial;

  model BivalentHeatPumpSystems_BoilerAfterBuffer_WithoutDHW
    "Bivalent Heat Pump System with boiler integration after buffer tank without DHW support"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
          oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.OnlyHeatPump generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
            pumpData,
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
        redeclare
          Systems.Hydraulical.Control.NewControlBivalentSystem_BoilerAfterBuffer
          control(
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
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.heatPumpParameters.scalingFactor,

          CheckTCut_Off(threshold=parameterStudy.TCutOff)),
        redeclare
          Systems.Hydraulical.Distribution.BivalentSystemDistributionWithBoilerAfterBuffer_WithoutDHW
          distribution(
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            bufParameters(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),

          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            dhwParameters(dTLoadingHC1=10),
          redeclare
            BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            threeWayValveParameters),
        redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
            redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
            radParameters, redeclare
            BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
      redeclare Systems.Demand.DHW.DHW DHW(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM
          DHWProfile,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
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
  end BivalentHeatPumpSystems_BoilerAfterBuffer_WithoutDHW;

  model BivalentHeatPumpSystems_Parallel
    "Bivalent Heat Pump System with parallel heat generation"
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
            pumpData,
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
          redeclare model PerDataMainHP =
              AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
              QCon_flow_nominal=hydraulic.generation.heatPumpParameters.QPri_flow_nominal,
              refrigerant="Propane",
              flowsheet="VIPhaseSeparatorFlowsheet"),
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            temperatureSensorData,
          redeclare
            BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            threeWayValveParameters,
          threeWayValveWithFlowReturn(redeclare
              BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
              parameters(
              m_flow_nominal=2*m_flow_nominal[1],
              dp_nominal={heatPumpParameters.dpCon_nominal,boilerNoControl.dp_nominal},
              use_inputFilter=true,
              order=1))),
        redeclare Systems.Hydraulical.Control.NewControlBivalentParallel
          control(
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
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.heatPumpParameters.scalingFactor,
          CheckTCut_Off(threshold=parameterStudy.TCutOff)),
        redeclare
          Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
          distribution(
          nParallelSup=1,
          dpSup_nominal={2*(hydraulic.distribution.threeWayValveParameters.dpValve_nominal
               + max(hydraulic.distribution.threeWayValveParameters.dp_nominal))},
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            bufParameters(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            dhwParameters(dTLoadingHC1=10),
          redeclare
            BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            threeWayValveParameters),
        redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
            redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
            radParameters, redeclare
            BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
      redeclare Systems.Demand.DHW.DHW DHW(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
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
  end BivalentHeatPumpSystems_Parallel;

  model BivalentHeatPumpSystems_BoilerAfterBuffer_WithDHW
    "Bivalent Heat Pump System with boiler integration after buffer tank with DHW support"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
          oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.OnlyHeatPump generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
            pumpData,
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
        redeclare
          Systems.Hydraulical.Control.NewControlBivalentSystem_BoilerAfterBuffer
          control(
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
            Systems.Hydraulical.Control.Components.DHWSetControl.AntiLegionellaControl
            TSet_DHW(triggerEvery(displayUnit="d") = 259200),
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
            safetyControl,
          TCutOff=parameterStudy.TCutOff,
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.heatPumpParameters.scalingFactor,

          CheckTCut_Off(threshold=parameterStudy.TCutOff)),
        redeclare
          Systems.Hydraulical.Distribution.BivalentSystemDistributionWithBoilerAfterBuffer_WithDHW
          distribution(
          designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage,

          QDHWStoLoss_flow=1,
          VStoDHW(displayUnit="l") = 0.1,
          QHRAftBuf_flow_nominal=0,
          use_heatingRodAfterBuffer=false,
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            temperatureSensorData,
          redeclare
            BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            threeWayValveParameters1,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
            bufParameters,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
            dhwParameters(dTLoadingHC1=10),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
            hydParameters),
        redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
            redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
            radParameters, redeclare
            BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
      redeclare Systems.Demand.DHW.DHW DHW(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM
          DHWProfile,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
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
  end BivalentHeatPumpSystems_BoilerAfterBuffer_WithDHW;

end BivalentHeatPumpSystems;
