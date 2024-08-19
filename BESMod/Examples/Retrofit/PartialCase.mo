within BESMod.Examples.Retrofit;
partial model PartialCase
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ABui=sum(building.zoneParam.VAir)^(2/3),
      ARoo=sum(building.zoneParam.ARoof),
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        use_old_design={NoRetrofitHydGen},
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          parHeaPum(
          genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,

          TBiv=TBiv,
          scalingFactor=hydraulic.generation.parHeaPum.QPri_flow_nominal/5000,
          dpCon_nominal=0,
          dpEva_nominal=0,
          use_refIne=false,
          refIneFre_constant=0),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
          parEleHea,
        redeclare model PerDataMainHP =
            AixLib.Obsolete.Year2024.DataBase.HeatPump.PerformanceData.VCLibMap
            (
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
        dTHysBui=10,
        dTHysDHW=10,
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,

        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,

        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedDirectLoading
        distribution(
        use_old_design={NoRetrofitHydDis},
        QHeaAftBuf_flow_nominal=0,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal,
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoBuf(use_QLos=true, T_m=338.15),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoDHW(
          dTLoadingHC1=10,
          use_QLos=true,
          T_m=65 + 273.15),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
          parEleHeaAftBuf),
      redeclare BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
        transfer(
        use_oldRad_design={NoRetrofitHydTra},
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum)),

    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,

      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESParameters systemParameters(QBui_flow_nominal=building.QRec_flow_nominal),

    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  parameter Modelica.Units.SI.Temperature TBiv=271.15
    "Nominal bivalence temperature. = TOda_nominal for monovalent systems.";
  parameter Boolean NoRetrofitHydTra = false
    "If true, hydraulic transfersystem uses QBuiNoRetrofit.";
  parameter Boolean NoRetrofitHydDis = false
    "If true, hydraulic distribution system uses QBuiNoRetrofit.";
  parameter Boolean NoRetrofitHydGen = false
    "If true, hydraulic generation system uses QBuiNoRetrofit.";
  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialCase;
