within BESMod.Examples.BAUSimStudy;
model PartialCase
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
        use_pressure=true,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          heatPumpParameters(
          genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
          TBiv=TBiv,
          scalingFactor=hydraulic.generation.heatPumpParameters.QPri_flow_nominal
              /5000,
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
      redeclare Systems.Hydraulical.Control.ConstHys_PI_ConOut_HPSController
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          thermostaticValveController,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
          thermostaticValveParameters,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
          bivalentControlData(TBiv=TBiv),
        redeclare
          Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
          TSet_DHW,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedDirectLoading
        distribution(
        QHRAftDHW_flow_nominal=0,
        QHRAftBuf_flow_nominal=0,
        use_heatingRodAfterDHW=false,
        use_heatingRodAfterBuffer=false,
        discretizationStepsDWHStoHR=0,
        discretizationStepsBufStoHR=0,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          temperatureSensorData,
        redeclare
          BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          threeWayValveParameters,
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          bufParameters(
          dTLoadingHC1=0,
          use_QLos=true,
          QLosPerDay=1.5,
          T_m=338.15),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          dhwParameters(
          dTLoadingHC1=10,
          use_QLos=true,
          QLosPerDay=1.5,
          T_m=65 + 273.15),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodAftBufParameters,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodAftDHWParameters),
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
        transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          transferDataBaseDefinition,
        redeclare
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
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESParameters systemParameters,
    redeclare
      BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation
      ventilation);

  parameter Modelica.SIunits.Temperature TBiv=271.15
    "Nominal bivalence temperature. = TOda_nominal for monovalent systems.";
  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialCase;
