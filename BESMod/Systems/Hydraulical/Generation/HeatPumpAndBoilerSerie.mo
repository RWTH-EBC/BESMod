within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndBoilerSerie "Bivalent heat pump Serienschaltung aktuell"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    m_flow_nominal=(Q_flow_nominal .* f_design ./ dTTra_nominal ./ 4184),
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final dTLoss_nominal=fill(0, nParallelDem),
    dTTra_nominal={if TDem_nominal[i] > 273.15 + 55 then 10 elseif TDem_nominal[
        i] > 44.9 + 273.15 then 8 else 5 for i in 1:nParallelDem},
    dp_nominal={heatPump.dpCon_nominal + boilerNoControl.dp_nominal},
    final nParallelDem=1);
     parameter Boolean use_pressure=false "=true to use a pump which works on pressure difference";
   parameter Boolean use_heaRod=false "=false to disable the heating rod";
    replaceable model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
            QCon_flow_nominal=heatPumpParameters.QPri_flow_nominal,
            refrigerant="Propane",
            flowsheet="VIPhaseSeparatorFlowsheet")
    annotation (__Dymola_choicesAllMatching=true);

  parameter Modelica.Media.Interfaces.Types.Temperature TSoilConst=273.15 + 10
    "Constant soil temperature for ground source heat pumps";
  replaceable package Medium_eva = Modelica.Media.Interfaces.PartialMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
  replaceable parameter
    RecordsCollection.BivalentHeatPumpBaseDataDefinition
    heatPumpParameters(
    QGen_flow_nominal=sum(systemParameters.QBui_flow_nominal),
    THeaTresh=373.15,
    scalingFactor=hydraulic.generation.heatPumpParameters.QGenBiv_flow_nominal/
        5000,
    mEva_flow_nominal=1,
    useAirSource=true,
    use_refIne=false,
    redeclare BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
      TempSensorData) constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition(
     genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel)
                       annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-490,-218},{-438,-176}})));

  AixLib.Fluid.HeatPumps.HeatPump heatPump(
    redeclare package Medium_con = IBPSA.Media.Water,
    redeclare package Medium_eva = IBPSA.Media.Air,
    final use_rev=false,
    final use_autoCalc=false,
    final Q_useNominal=0,
    final scalingFactor=heatPumpParameters.scalingFactor,
    final use_refIne=heatPumpParameters.use_refIne,
    final refIneFre_constant=heatPumpParameters.refIneFre_constant,
    final nthOrder=1,
    final useBusConnectorOnly=true,
    final mFlow_conNominal=m_flow_nominal[1],
    final VCon=heatPumpParameters.VCon,
    final dpCon_nominal=heatPumpParameters.dpCon_nominal,
    final use_conCap=false,
    final CCon=0,
    final GConOut=0,
    final GConIns=0,
    final mFlow_evaNominal=heatPumpParameters.mEva_flow_nominal,
    final VEva=heatPumpParameters.VEva,
    final dpEva_nominal=heatPumpParameters.dpEva_nominal,
    final use_evaCap=false,
    final CEva=0,
    final GEvaOut=0,
    final GEvaIns=0,
    final tauSenT=heatPumpParameters.TempSensorData.tau,
    final transferHeat=true,
    final allowFlowReversalEva=allowFlowReversal,
    final allowFlowReversalCon=allowFlowReversal,
    final tauHeaTraEva=heatPumpParameters.TempSensorData.tauHeaTra,
    final TAmbEva_nominal=heatPumpParameters.TempSensorData.TAmb,
    final tauHeaTraCon=heatPumpParameters.TempSensorData.tauHeaTra,
    final TAmbCon_nominal=heatPumpParameters.TempSensorData.TAmb,
    initType=Modelica.Blocks.Types.Init.NoInit,
    final pCon_start=p_start,
    final TCon_start=T_start,
    final pEva_start=Medium_eva.p_default,
    final TEva_start=Medium_eva.T_default,
    final energyDynamics=energyDynamics,
    final show_TPort=show_T,
    redeclare model PerDataMainHP =
        PerDataMainHP,
    redeclare model PerDataRevHP =
        AixLib.DataBase.Chiller.PerformanceData.LookUpTable2D (final dataTable=
            AixLib.DataBase.Chiller.EN14511.Vitocal200AWO201()))
                                                 annotation (Placement(
        transformation(
        extent={{40.5,-48.5},{-40.5,48.5}},
        rotation=270,
        origin={-378.5,-152.5})));

  IBPSA.Fluid.Sources.Boundary_ph bou_sinkAir(final nPorts=1, redeclare package
      Medium = IBPSA.Media.Air)                          annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-422,-238})));
  IBPSA.Fluid.Sources.MassFlowSource_T bou_air(
    final m_flow=heatPumpParameters.mEva_flow_nominal,
    final use_T_in=true,
    redeclare package Medium = IBPSA.Media.Air,
    final use_m_flow_in=false,
    final nPorts=1)
    annotation (Placement(transformation(extent={{-426,-74},{-406,-54}})));

  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-458,-12})));
  Modelica.Blocks.Sources.BooleanConstant
                                   AirOrSoil(k=heatPumpParameters.useAirSource)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-496,-14})));

  Modelica.Blocks.Sources.Constant TSoil(k=TSoilConst)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-496,-36})));

  IBPSA.Fluid.Movers.SpeedControlled_y pumpGeneration(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal[1],
      final dp_nominal=dpDem_nominal[1] + heatPumpParameters.dpCon_nominal +
          boilerNoControl.dp_nominal,
      final rho=rho,
      final V_flowCurve=pumpData.V_flowCurve,
      final dpCurve=pumpData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=pumpData.addPowerToMedium,
    final tau=pumpData.tau,
    final use_inputFilter=pumpData.use_inputFilter,
    final riseTime=pumpData.riseTimeInpFilter,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1) annotation (Placement(transformation(
        extent={{-17,17},{17,-17}},
        rotation=180,
        origin={-205,-189})));
  AixLib.Fluid.BoilerCHP.BoilerNoControl boilerNoControl(
    redeclare package Medium = AixLib.Media.Water,
    final allowFlowReversal=true,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final initType=Modelica.Blocks.Types.Init.NoInit,
    final transferHeat=false,
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    paramBoiler=AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_15kW())
    annotation (Placement(transformation(extent={{-298,-36},{-216,52}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData(
    V_flowCurve={0,0.99,1,1.01},
    dpCurve={1.01,1,0.99,0},
    speed_rpm_nominal=100,
    addPowerToMedium=false,
    use_inputFilter=false,
    riseTimeInpFilter=10,
    tau=1)   annotation (choicesAllMatching=true, Placement(transformation(extent={{-546,
            -162},{-478,-100}})));
  IBPSA.Fluid.Sources.Boundary_pT bouPumpHP(
    redeclare package Medium = IBPSA.Media.Water,
    final p=p_start,
    final T=T_start,
    final nPorts=1)                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-172,-96})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{26,-166},{46,-146}})));
  Modelica.Blocks.Sources.Constant const4(k=1)
    annotation (Placement(transformation(extent={{-228,-136},{-208,-116}})));
  BESMod.Systems.Hydraulical.Interfaces.GenerationOutputs
    outBusGen1
    annotation (Placement(transformation(extent={{-486,-316},{-466,-296}})));
  Utilities.KPIs.EnergyKPICalculator KPIWel(use_inpCon=true)
    annotation (Placement(transformation(extent={{-568,-300},{-548,-280}})));
  Utilities.KPIs.EnergyKPICalculator KPIQHP(use_inpCon=false, y=heatPump.con.QFlow_in)
    annotation (Placement(transformation(extent={{-568,-328},{-548,-308}})));
  Utilities.KPIs.EnergyKPICalculator KPIWel2(use_inpCon=true)
    annotation (Placement(transformation(extent={{-570,-362},{-550,-342}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    temperatureSensorData annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-58,-264},{36,-206}})));
protected
  parameter Modelica.Units.SI.PressureDifference dpHeaRod_nominal=0;

equation

  connect(bou_air.ports[1], heatPump.port_a2) annotation (Line(
      points={{-406,-64},{-396,-64},{-396,-96},{-402.75,-96},{-402.75,-112}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(heatPump.port_b2, bou_sinkAir.ports[1]) annotation (Line(
      points={{-402.75,-193},{-400,-193},{-400,-238},{-412,-238}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(sigBusGen.hp_bus, heatPump.sigBus) annotation (Line(
      points={{2,98},{-312,98},{-312,-204},{-394.262,-204},{-394.262,-192.595}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(bou_air.T_in, switch2.y)
    annotation (Line(points={{-428,-60},{-436,-60},{-436,-12},{-447,-12}},
                                                   color={0,0,127}));
  connect(sigBusGen.hp_bus.TOdaMea, switch2.u1) annotation (Line(
      points={{2,98},{-472,98},{-472,104},{-504,104},{-504,-4},{-470,-4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(switch2.u2, AirOrSoil.y)
    annotation (Line(points={{-470,-12},{-479.7,-12},{-479.7,-14},{-489.4,-14}},
                                                     color={255,0,255}));

  connect(TSoil.y, switch2.u3) annotation (Line(points={{-489.4,-36},{-480,-36},
          {-480,-20},{-470,-20}},
                                color={0,0,127}));

  connect(pumpGeneration.port_a, bouPumpHP.ports[1]) annotation (Line(points={{-188,
          -189},{-188,-166},{-172,-166},{-172,-106}},
                                                   color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{46,-156},{72,-156},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(const4.y, pumpGeneration.y) annotation (Line(points={{-207,-126},{
          -196,-126},{-196,-156},{-205,-156},{-205,-168.6}},
                                                color={0,0,127}));
  connect(pumpGeneration.y_actual, sigBusGen.PumpSpeed) annotation (Line(points={{-223.7,
          -177.1},{-232,-177.1},{-232,-48},{-172,-48},{-172,98},{2,98}},
                                          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heatPump.port_b1, boilerNoControl.port_a) annotation (Line(points={{
          -354.25,-112},{-352,-112},{-352,-96},{-308,-96},{-308,8},{-298,8}},
        color={0,127,255}));
  connect(portGen_in[1], pumpGeneration.port_a) annotation (Line(points={{100,
          -2},{8,-2},{8,-4},{-96,-4},{-96,-189},{-188,-189}}, color={0,127,255}));
  connect(pumpGeneration.port_b, heatPump.port_a1) annotation (Line(points={{
          -222,-189},{-308,-189},{-308,-204},{-354.25,-204},{-354.25,-193}},
        color={0,127,255}));
  connect(boilerNoControl.port_b, portGen_out[1]) annotation (Line(points={{
          -216,8},{80,8},{80,80},{100,80}}, color={0,127,255}));
  connect(boilerNoControl.T_out, sigBusGen.TBoilerOut) annotation (Line(points={
          {-227.48,22.08},{2,22.08},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boilerNoControl.u_rel, sigBusGen.BoilerON) annotation (Line(points={{
          -285.7,38.8},{-356,38.8},{-356,136},{2,136},{2,98}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIWel.KPI, outBusGen1.PEleHP) annotation (Line(points={{-545.8,-290},
          {-476,-290},{-476,-306}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIWel.u, sigBusGen.hp_bus.PelMea) annotation (Line(points={{-569.8,
          -290},{-592,-290},{-592,180},{2,180},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(outBusGen1.QHP_flow, KPIQHP.KPI) annotation (Line(
      points={{-476,-306},{-476,-292},{-528,-292},{-528,-318},{-545.8,-318}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIWel2.KPI, outBusGen1.QBoi_flow) annotation (Line(points={{-547.8,
          -352},{-508,-352},{-508,-354},{-476,-354},{-476,-306}}, color={135,
          135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boilerNoControl.thermalPower, KPIWel2.u) annotation (Line(points={{
          -227.48,44.96},{-192,44.96},{-192,68},{-660,68},{-660,-352},{-571.8,
          -352}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-560,-300},{240,120}})), Icon(
        coordinateSystem(extent={{-560,-300},{240,120}})));
end HeatPumpAndBoilerSerie;
