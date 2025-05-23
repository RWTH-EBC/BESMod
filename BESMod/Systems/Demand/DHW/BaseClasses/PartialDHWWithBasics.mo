within BESMod.Systems.Demand.DHW.BaseClasses;
partial model PartialDHWWithBasics "DHW module with basic models"
  extends BaseClasses.PartialDHW;

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    parPum
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-96,-96},{-84,-84}})));

  replaceable TappingProfiles.BaseClasses.PartialDHW calcmFlow constrainedby
    TappingProfiles.BaseClasses.PartialDHW(
    final TCold=TDHWCold_nominal,
    final dWater=rho,
    final c_p_water=cp,
    final TSetDHW=TDHW_nominal) annotation (choicesAllMatching=true,
      Placement(transformation(
        extent={{-17,18},{17,-18}},
        rotation=180,
        origin={-21,20})));
Modelica.Blocks.Math.UnitConversions.From_degC fromDegC
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,-10})));
  Utilities.KPIs.EnergyKPICalculator integralKPICalculator(use_inpCon=false, y=
        -port_b.m_flow*cp*(TIs.y - TDHWCold_nominal))
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  IBPSA.Fluid.Movers.Preconfigured.FlowControlled_m_flow pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=TDHWCold_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=1E-4*abs(mDHW_flow_nominal),
    final show_T=show_T,
    final m_flow_nominal=mDHW_flow_nominal,
    final dp_nominal(displayUnit="Pa") = if dpDHW_nominal <> 0 then
      dpDHW_nominal else 100,
    final addPowerToMedium=parPum.addPowerToMedium,
    final tau=parPum.tau,
    final use_riseTime=parPum.use_riseTime,
    final riseTime=parPum.riseTimeInpFilter)                 annotation (Placement(transformation(
        extent={{-9.5,9.5},{9.5,-9.5}},
        rotation=180,
        origin={-69.5,-50.5})));
  IBPSA.Fluid.Sources.Boundary_ph bou_sink(
    redeclare package Medium = Medium,
    final p=p_start,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,60})));
  IBPSA.Fluid.Sources.Boundary_pT bouSou(
    final T=TDHWCold_nominal,
    final nPorts=1,
    redeclare final package Medium = Medium,
    final p=p_start)
    annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTableDHWInput(
    final columns=2:5,
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Read the input data from the given file. " annotation (Placement(visible=true,
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,50})));
  Modelica.Blocks.Sources.RealExpression TIs(y=Medium.temperature(
        Medium.setState_phX(
        port_a.p,
        inStream(port_a.h_outflow),
        inStream(port_a.Xi_outflow)))) annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=180,
        origin={30,21})));
equation
  connect(fromDegC.y, calcmFlow.TSet) annotation (Line(points={{19,-10},{8,-10},
          {8,9.2},{-0.6,9.2}}, color={0,0,127}));
  connect(pump.port_a, bouSou.ports[1]) annotation (Line(
      points={{-60,-50.5},{-50,-50.5},{-50,-50},{-40,-50}},
      color={0,127,255}));
  connect(pump.port_b, port_b) annotation (Line(
      points={{-79,-50.5},{-84,-50.5},{-84,-60},{-100,-60}},
      color={0,127,255}));
  connect(calcmFlow.m_flow_out, pump.m_flow_in) annotation (Line(
      points={{-39.7,20},{-69.5,20},{-69.5,-39.1}},
      color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{40,-90},{56,-90},{56,-84},{70,-84},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(combiTimeTableDHWInput.y[4], fromDegC.u)
    annotation (Line(points={{59,50},{48,50},{48,-10},{42,-10}},
                                               color={0,0,127}));
  connect(combiTimeTableDHWInput.y[2], calcmFlow.m_flow_in) annotation (Line(
        points={{59,50},{48,50},{48,64},{6,64},{6,30.8},{-0.6,30.8}},
                                                     color={0,0,127}));
  connect(TIs.y, calcmFlow.TIs) annotation (Line(points={{19,21},{18,21},{18,20},
          {-0.6,20}}, color={0,0,127}));
  connect(port_a, bou_sink.ports[1])
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(integralKPICalculator.KPI, outBusDHW.Q_flow) annotation (Line(points={
          {82.2,-50},{100,-50},{100,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end PartialDHWWithBasics;
