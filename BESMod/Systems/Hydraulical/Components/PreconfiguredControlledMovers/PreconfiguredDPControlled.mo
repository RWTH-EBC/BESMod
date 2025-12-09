within BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers;
model PreconfiguredDPControlled
  "DPControlled mover using the preconfigured models"
  extends IBPSA.Fluid.Interfaces.PartialTwoPort;
  extends AixLib.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics,
    final mSenFac=1);

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal "Nominal pressure raise, used to normalized the filter if use_riseTime=true,
        to set default values of constantHead and heads, and
        and for default pressure curve if not specified in record per";
  parameter PreconfiguredControlledMovers.Types.ExternalControlType externalCtrlTyp=
      PreconfiguredControlledMovers.Types.ExternalControlType.internal
    "External control interface type";
  parameter AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpTotal
    "Internal pump control mode"
    annotation(Dialog(enable=useDPCtrl));
  parameter Real dpVarBase_nominal = 0.5
    "Percentage of dp_nominal at minimal volume flow rate for dpVar"
    annotation(Dialog(enable=(ctrlType == AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar)));

  parameter Boolean addPowerToMedium=false
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";
  // Classes used to implement the filtered speed
  parameter Boolean use_riseTime=false
    "Set to true to continuously change motor speed"
    annotation(Dialog(tab="Dynamics", group="Motor speed"));

  parameter Modelica.Units.SI.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)" annotation (
      Dialog(
      tab="Dynamics",
      group="Motor speed",
      enable=use_riseTime));

  parameter Real y_start=0 "Initial value of speed"
    annotation(Dialog(tab="Dynamics", group="Motor speed",enable=use_riseTime));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation" annotation (Dialog(tab="Advanced"));
  parameter Boolean verboseExtrapolation=false
    "= true, if warning messages are to be printed if table input is outside the definition range"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.PressureDifference dpConst_nominal[nPreCur]={
    if i == 1 then pressureCurve.dp[2]
    else pressureCurve.dp[i]
      for i in 1:nPreCur}
    "dpConst control curve" annotation (Dialog(tab="Advanced", enable=(ctrlType ==
          AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpConst)));
  parameter Modelica.Units.SI.PressureDifference dpVar_nominal[nPreCur]={
    if i == 1 then pressureCurve.dp[2] * dpVarBase_nominal
    else pressureCurve.dp[i]
      for i in 1:nPreCur} "dpVar control curve" annotation (Dialog(tab="Advanced",
        enable=(ctrlType == AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar)));

  Modelica.Blocks.Tables.CombiTable1Dv ctrl(
    final tableOnFile=false,
    final table=if (ctrlType == AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpConst)
         then [cat(1, pressureCurve.V_flow),cat(1, dpConst_nominal)] elseif (
        ctrlType == AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar)
         then [cat(1, pressureCurve.V_flow),cat(1, dpVar_nominal)] else [cat(1,
        pressureCurve.V_flow),cat(1, pressureCurve.dp)],
    final tableName="NoName",
    final fileName="NoName",
    final verboseRead=true,
    final columns=2:size(ctrl.table, 2),
    smoothness=smoothness,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    u(each final unit="m3/s"),
    y(each final unit="Pa"),
    verboseExtrapolation=verboseExtrapolation) if useDPCtrl
    "Table with points of selected curve to calculate dp from V_flow"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Modelica.Blocks.Interfaces.BooleanInput on if externalCtrlTyp ==
    PreconfiguredControlledMovers.Types.ExternalControlType.onOff
                                             "=false to turn pump off"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,120})));
  Modelica.Blocks.Logical.Switch swi if useDPCtrl
                                     "Switch on or off"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Sources.Constant
                            const(k=0) if useDPCtrl "Set to zero"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Modelica.Blocks.Math.Division div if useDPCtrl
                                    "Divide mass flow by rho"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  IBPSA.Fluid.Movers.Preconfigured.FlowControlled_dp dpControlled_dp(
    redeclare final package Medium = Medium,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final addPowerToMedium=addPowerToMedium,
    use_riseTime=use_riseTime,
    final riseTime=riseTime,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final dp_nominal=dp_nominal) if useDPCtrl "dp controlled Pump"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y speedControlled_y(
    redeclare final package Medium = Medium,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final addPowerToMedium=addPowerToMedium,
    final use_riseTime=use_riseTime,
    final riseTime=riseTime,
    final y_start=y_start,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final dp_nominal=dp_nominal) if not useDPCtrl "Direct speed control pump"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Interfaces.RealInput y if not useDPCtrl
                                         "Constant normalized rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealOutput P(unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Sources.BooleanConstant booCon(k=true) if externalCtrlTyp <>
    PreconfiguredControlledMovers.Types.ExternalControlType.onOff "Set to on"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
protected
  final parameter AixLib.Fluid.Movers.BaseClasses.Characteristics.flowParameters
    pressureCurve(
              V_flow=m_flow_nominal/rho_default*{0, 1, 2},
              dp=if rho_default < 500
                   then dp_nominal*{1.12, 1, 0}
                   else dp_nominal*{1.14, 1, 0.42})
    "General mover curve: volume flow rate vs. total pressure head";

  final parameter Modelica.Units.SI.Density rho_default=
    Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Default medium density";
  final parameter Integer nPreCur=size(pressureCurve.dp, 1)
    "Dimension of pressure curve";
  parameter Boolean useDPCtrl = externalCtrlTyp <>PreconfiguredControlledMovers.Types.ExternalControlType.speed;

  Modelica.Blocks.Sources.RealExpression rho_inlet(y=Medium.density(
        Medium.setState_phX(
        port_a.p,
        inStream(port_a.h_outflow),
        inStream(port_a.Xi_outflow)))) if useDPCtrl
                                       "Density of the inflowing fluid"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression m_flow(y=port_a.m_flow) if useDPCtrl
    "Inflowing mass flow rate "
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(on, swi.u2) annotation (Line(points={{-50,120},{-50,-50},{38,-50}},
                color={255,0,255}));
  connect(ctrl.y[1], swi.u1) annotation (Line(points={{21,-30},{30,-30},{30,-42},
          {38,-42}},
                color={0,0,127}));
  connect(const.y, swi.u3) annotation (Line(points={{1,-70},{30,-70},{30,-58},{38,
          -58}},color={0,0,127}));
  connect(ctrl.u[1], div.y)
    annotation (Line(points={{-2,-30},{-19,-30}},
                                                color={0,0,127}));
  connect(speedControlled_y.y, y) annotation (Line(points={{-10,42},{-10,60},{0,
          60},{0,120}}, color={0,0,127}));
  connect(dpControlled_dp.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(dpControlled_dp.port_a, port_a)
    annotation (Line(points={{40,0},{-100,0}}, color={0,127,255}));
  connect(speedControlled_y.port_a, port_a) annotation (Line(points={{-20,30},{
          -40,30},{-40,0},{-100,0}}, color={0,127,255}));
  connect(speedControlled_y.port_b, port_b) annotation (Line(points={{0,30},{86,
          30},{86,0},{100,0}}, color={0,127,255}));
  connect(swi.y, dpControlled_dp.dp_in) annotation (Line(points={{61,-50},{74,-50},
          {74,-20},{28,-20},{28,18},{50,18},{50,12}}, color={0,0,127}));
  connect(P, speedControlled_y.P) annotation (Line(points={{110,60},{70,60},{70,
          39},{1,39}}, color={0,0,127}));
  connect(P, dpControlled_dp.P) annotation (Line(points={{110,60},{70,60},{70,9},
          {61,9}}, color={0,0,127}));
  connect(booCon.y, swi.u2) annotation (Line(points={{-39,-70},{-32,-70},{-32,
          -50},{38,-50}}, color={255,0,255}));
  connect(m_flow.y, div.u1) annotation (Line(points={{-59,-20},{-54,-20},{-54,
          -24},{-42,-24}}, color={0,0,127}));
  connect(div.u2, rho_inlet.y) annotation (Line(points={{-42,-36},{-54,-36},{
          -54,-40},{-59,-40}}, color={0,0,127}));
  annotation (Line(points={{1,39},{104,39},{104,38}}, color={0,0,127}),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-94,100},{-42,48}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{0,90},{100,90}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,70},{100,70}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,50},{100,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-100,16},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-58,58},{58,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,50},{0,-50},{54,0},{0,50}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{4,16},{36,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Line(
          points={{0,100},{0,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          visible=use_riseTime,
          extent={{-32,40},{34,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_riseTime,
          extent={{-32,100},{34,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_riseTime,
          extent={{-20,92},{22,46}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),
        Line(
          points={{-94,48},{-94,96}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-1,-24},{-1,24}},
          color={0,0,0},
          thickness=0.5,
          origin={-70,49},
          rotation=90),
        Polygon(
          points={{-96,96},{-92,96},{-94,100},{-96,96}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,-2},{2,-2},{0,2},{-2,-2}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-44,48},
          rotation=270),
        Line(
          points={{-94,92},{-68,84},{-56,74},{-48,48}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-94,92},{-68,84},{-56,74},{-48,48}},
          color={255,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash,
          visible=ctrlType==AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpTotal),
        Line(
          points={{-94,84},{-68,84},{-56,74},{-48,48}},
          color={255,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash,
          visible=ctrlType==AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpConst),
        Line(
          points={{-94,66},{-68,84},{-56,74},{-48,48}},
          color={73,175,36},
          thickness=0.5,
          pattern=LinePattern.Dash,
          visible=ctrlType==AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar)}));
end PreconfiguredDPControlled;
