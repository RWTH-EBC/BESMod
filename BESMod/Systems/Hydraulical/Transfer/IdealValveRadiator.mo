within BESMod.Systems.Hydraulical.Transfer;
model IdealValveRadiator
  "Subsystem using a radiator and ideal thermostatic valves"
  extends BaseClasses.PartialWithPipingLosses(
    dp_design=dpPipSca_design .+ rad.dp_nominal,
    final nHeaTra=parRad.n,
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final dTLoss_nominal=fill(0, nParallelDem),
    Q_flow_design={if use_oldRad_design[i] then QOld_flow_design[i] else Q_flow_nominal[i] for i in 1:nParallelDem},
    TTra_design={if use_oldRad_design[i] then TTraOld_design[i] else TTra_nominal[i] for i in 1:nParallelDem});

  parameter Boolean use_oldRad_design[nParallelDem]=fill(false, nParallelDem)
    "If true, radiator design of old building state is used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final nEle=parRad.nEle,
    each final fraRad=parRad.fraRad,
    final Q_flow_nominal=Q_flow_design .* f_design,
    final T_a_nominal=TTra_design,
    final T_b_nominal=TTra_design - dTTra_design,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=parRad.n,
    each final deltaM=0.3,
    final dp_nominal=parRad.perPreLosRad .* dpPipSca_design,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-10,-30})));

  Modelica.Blocks.Math.Gain gain[nParallelDem](final k=rad.m_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,30})));

  replaceable parameter
    BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData parRad
    "Radiator parameters" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-100,-98},{-80,-78}})));
  Utilities.KPIs.EnergyKPICalculator intKPICalHeaFlo(final use_inpCon=false,
      final y=sum(-heatPortRad.Q_flow) + sum(-heatPortCon.Q_flow))
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  IBPSA.Fluid.Movers.Preconfigured.FlowControlled_m_flow pumFixMFlo[nParallelDem](
    redeclare final package Medium = Medium,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_small=1E-4*abs(m_flow_nominal),
    each final show_T=show_T,
    final m_flow_nominal=m_flow_design,
    final dp_nominal=dp_design,
    each final addPowerToMedium=parPum.addPowerToMedium,
    each final tau=parPum.tau,
    each final use_inputFilter=false,
    final m_flow_start=m_flow_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,10})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    parPum "Pump assumptions"
           annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,78},{-78,98}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-106},{50,-86}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpe[nParallelDem] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,70})));
  Modelica.Blocks.Sources.RealExpression senTSup[nParallelSup](final y(
      each final unit="K",
      each displayUnit="degC") = Medium.temperature(Medium.setState_phX(
      portTra_in.p,
      inStream(portTra_in.h_outflow),
      inStream(portTra_in.Xi_outflow)))) "Real expression for supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
  Modelica.Blocks.Sources.RealExpression senTRet[nParallelSup](final y(
      each final unit="K",
      each displayUnit="degC") = Medium.temperature(Medium.setState_phX(
      portTra_out.p,
      inStream(portTra_out.h_outflow),
      inStream(portTra_out.Xi_outflow)))) "Real expression for return temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-10})));
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{-2.8,-32},{40,
          -32},{40,-40},{100,-40}},       color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{-2.8,-28},{
          -2.8,-26},{40,-26},{40,40},{100,40}},    color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(rad[i].port_b, portTra_out[1]) annotation (Line(points={{-10,-40},{
            -10,-42},{-100,-42}},
                       color={0,127,255}));
    connect(portTra_in[1], res[i].port_a)
      annotation (Line(points={{-100,38},{-80,38},{-80,40},{-60,40}},
                                                    color={0,127,255}));
  end for;

  connect(res.port_b, pumFixMFlo.port_a)
    annotation (Line(points={{-40,40},{-10,40},{-10,20}}, color={0,127,255}));
  connect(pumFixMFlo.port_b, rad.port_a) annotation (Line(points={{-10,
          -3.55271e-15},{-10,-20}}, color={0,127,255}));
  connect(gain.y, pumFixMFlo.m_flow_in)
    annotation (Line(points={{10,19},{10,10},{2,10}}, color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-96},{72,-96},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(intKPICalHeaFlo.KPI, outBusTra.QRad_flow) annotation (Line(points={{
          -17.8,-70},{0,-70},{0,-104}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrOpe.y, outBusTra.opening) annotation (Line(points={{
          -1.9984e-15,59},{-1.9984e-15,50},{24,50},{24,-90},{0,-90},{0,-104}},
                                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrOpe.u, traControlBus.opening) annotation (Line(points={{
          2.22045e-15,82},{2.22045e-15,91},{0,91},{0,100}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrOpe.y, gain.u)
    annotation (Line(points={{-1.9984e-15,59},{-1.9984e-15,50},{10,50},{10,42}},
                                                             color={0,0,127}));
  connect(senTSup.y, outBusTra.TSup) annotation (Line(points={{-79,10},{-56,10},
          {-56,-50},{0,-50},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTRet.y, outBusTra.TRet) annotation (Line(points={{-79,-10},{-56,-10},
          {-56,-50},{0,-50},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end IdealValveRadiator;
