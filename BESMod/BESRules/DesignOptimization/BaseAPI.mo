within BESMod.BESRules.DesignOptimization;
model BaseAPI "Model for the python API"
  extends BESMod.BESRules.BaseClasses.PartialBESRulesSystem
                                                    (
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare BESMod.Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare model RefrigerantCycleInertia =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
        TBiv=parameterStudy.TBiv,
        THeaTresh=parameterStudy.THeaThr,
        TSupAtBiv=THydAtBiv_nominal,
        genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel,
        QPriAtTOdaNom_flow_nominal=QPriAtTOdaNom_flow_nominal_internal,
        QSecMin_flow_nominal=hydraulic.distribution.QDHWBefSto_flow_nominal,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen),
      redeclare BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        meaValPriGen=BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.DistributionTemperature,
        dTHysBui=5,
        dTHysDHW=5,
        redeclare model BuildingSupplySetTemperature =
            BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
            (THeaThr=parameterStudy.THeaThr),
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater (TBiv=parameterStudy.TBiv),
        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater (TBiv=parameterStudy.TBiv),
        redeclare model DHWSetTemperature =
            BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW,
        redeclare model SummerMode =
            BESMod.Systems.Hydraulical.Control.Components.SummerMode.No,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedDirectLoading
        distribution(
        designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare replaceable
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.A),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoDHW(dTLoadingHC1=10, energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.A),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal)),
    redeclare replaceable BESMod.Systems.Demand.DHW.StandardProfiles DHW(redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare replaceable
        BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquDynamic calcmFlow),
    redeclare BESMod.BESRules.DesignOptimization.DesignOptimizationVariables
      parameterStudy);

  parameter Modelica.Units.SI.HeatFlowRate QPriAtTOdaNom_flow_nominal_internal;

  BESMod.Utilities.KPIs.CalculateHeatMeanTemperature THeaPumOdaMeanQ_flow(Q_flow=
        hydraulic.generation.heatPump.QCon_flow, T=hydraulic.generation.weaBus.TDryBul)
    annotation (Placement(transformation(extent={{220,-60},{240,-40}})));
  BESMod.Utilities.KPIs.CalculateHeatMeanTemperature THeaPumSupMeanQ_flow(T=
        hydraulic.generation.heatPump.con.vol.T, Q_flow=hydraulic.generation.heatPump.QCon_flow)
    annotation (Placement(transformation(extent={{180,-60},{200,-40}})));
equation
  connect(THeaPumOdaMeanQ_flow.TMea, outputs.THeaPumSouMean) annotation (Line(
        points={{240,-52},{248,-52},{248,-36},{246,-36},{246,0},{285,0}}, color=
         {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(THeaPumSupMeanQ_flow.TMea, outputs.THeaPumSinMean) annotation (Line(
        points={{200,-52},{206,-52},{206,2},{248,2},{248,0},{285,0}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end BaseAPI;
