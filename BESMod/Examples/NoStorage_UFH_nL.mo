within BESMod.Examples;
package NoStorage_UFH_nL
  "HP & HR, no heating storage, UFH pressure based system"
  extends Modelica.Icons.ExamplesPackage;
  model BES
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone_nightLowering building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare
          BESMod.Systems.Hydraulical.Generation.HeatPumpAndHeatingRod_numSwiEachDay
          generation(
          redeclare model PerDataMainHP =
              AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
              QCon_flow_nominal=hydraulic.generation.heatPumpParameters.QPri_flow_nominal,
              refrigerant="Propane",
              flowsheet="VIPhaseSeparatorFlowsheet"),
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
            use_refIne=false),
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
            heatingRodParameters,
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            temperatureSensorData),
        redeclare Systems.Hydraulical.Control.PartBiv_PI_ConOut_HPS control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            thermostaticValveController,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
            thermostaticValveParameters,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl_toOptimize
            bivalentControlData(TBiv=parameterStudy.TBiv),
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.AntiLegionellaControl
            TSet_DHW(triggerEvery=604800),
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
            safetyControl,
          TCutOff=parameterStudy.TCutOff,
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.heatPumpParameters.scalingFactor),
        redeclare BESMod.Systems.Hydraulical.Distribution.NoStorageForHeating
          distribution(
          dTLoaHCBuf=0,
          dpBufHCSto_nominal=0,
          QHRAftBuf_flow_nominal=0,
          use_heatingRodAfterBuffer=false,
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            temperatureSensorData,
          redeclare
            BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            threeWayValveParameters,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage_Direct
            bufParameters(use_HC1=false, use_HC2=false),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
            dhwParameters,
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
            heatingRodAftBufParameters),
        redeclare BESMod.Systems.Hydraulical.Transfer.UFHPressureBased transfer(
          use_preRelVal=true,
          redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData
            UFHParameters,
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
            pumpData,
          redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.UFHSystemPressureLossData
            transferDataBaseDefinition_forUFH)),
      redeclare Systems.Demand.DHW.DHW DHW(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
        redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
          calcmFlow),
      redeclare Systems.UserProfiles.TEASERProfiles_nightLowering userProfiles,
      redeclare AachenSystem systemParameters(THydSup_nominal={313.15},
                                              use_ventilation=true),
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
end NoStorage_UFH_nL;