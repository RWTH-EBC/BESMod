within BESMod.Systems.Hydraulical.Distribution.Components.Valves;
model PressureReliefValve
  extends AixLib.Fluid.Interfaces.PartialTwoPortInterface;
  parameter Modelica.Units.SI.PressureDifference dpFullOpen_nominal "Pressure difference at which valve is fully open";
  parameter Modelica.Units.SI.PressureDifference dpThreshold_nominal = 0.95*dpFullOpen_nominal "Threshold at which valve starts to open";
  AixLib.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime(displayUnit="s") = riseTime,
    final init=init,
    y_start=y_start,
    final dpFixed_nominal=0,
    final l=l)                                            annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  AixLib.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
                                                  annotation (Placement(transformation(extent={{-10,50},{10,30}})));
  parameter Real facDpValve_nominal(min=0, max=1) = 0.5 "Factor to design dpValve_nominal";
  parameter Real l=0.001 "Valve leakage, l=Kv(y=0)/Kv(y=1)";

  parameter Boolean use_inputFilter=true "= true, if opening is filtered with a 2nd order CriticalDamping filter" annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.Units.SI.Time riseTime=10 "Rise time of the filter (time to reach 99.6 % of an opening step)" annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter));

  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput "Type of initialization (no init/steady state/initial state/initial output)" annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter));
  parameter Real y_start=1 "Initial value of output" annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter));
  Modelica.Blocks.Nonlinear.Limiter limiter(final uMax=1, final uMin=0)
                                                            annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=0,
        origin={-50,30})));
  Modelica.Blocks.Math.Add add(final k1=+1, final k2=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,70})));
  Modelica.Blocks.Math.Gain gain(k=1/(dpFullOpen_nominal - dpThreshold_nominal))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,70})));
  Modelica.Blocks.Sources.Constant const(final k=dpThreshold_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,90})));
protected
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal = facDpValve_nominal*(dpFullOpen_nominal - dpThreshold_nominal) + dpThreshold_nominal;

equation
  connect(val.port_a, senRelPre.port_a) annotation (Line(points={{-10,0},{-20,0},{-20,40},{-10,40}}, color={0,127,255}));
  connect(val.port_b, senRelPre.port_b) annotation (Line(points={{10,0},{20,0},{20,40},{10,40}}, color={0,127,255}));
  connect(port_a, val.port_a) annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(val.port_b, port_b) annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senRelPre.p_rel, add.u1) annotation (Line(points={{0,49},{0,56},{20,56},
          {20,64},{2,64}}, color={0,0,127}));
  connect(const.y, add.u2) annotation (Line(points={{19,90},{18,90},{18,76},{2,76}},
        color={0,0,127}));
  connect(limiter.y, val.y) annotation (Line(points={{-39,30},{-26,30},{-26,20},
          {0,20},{0,12}}, color={0,0,127}));
  connect(gain.u, add.y)
    annotation (Line(points={{-38,70},{-21,70}}, color={0,0,127}));
  connect(gain.y, limiter.u) annotation (Line(points={{-61,70},{-68,70},{-68,30},
          {-62,30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                         Rectangle(
      extent={{-24,92},{22,20}},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
        Polygon(
          points={{4,24},{4,66},{8,66},{8,24},{16,66},{20,66},{12,24},{4,24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={44,70},
          rotation=90),
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),        Rectangle(
      extent={{-60,40},{60,-40}},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Polygon(
      points={{0,0},{-76,60},{-76,-60},{0,0}},
      lineColor={0,0,0},
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{0,-0},{76,60},{76,-60},{0,0}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Line(
      points={{0,26},{0,0}}),
        Polygon(
          points={{4,24},{4,66},{8,66},{8,24},{16,66},{20,66},{12,24},{4,24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={44,54},
          rotation=90),
        Polygon(
          points={{4,24},{4,66},{8,66},{8,24},{16,66},{20,66},{12,24},{4,24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={44,38},
          rotation=90),
        Polygon(
          points={{4,24},{4,66},{8,66},{8,24},{16,66},{20,66},{12,24},{4,24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={44,22},
          rotation=90),
        Rectangle(
          extent={{-22,94},{20,90}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-26,94},{-22,20}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{20,94},{24,20}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag)}),                  Diagram(coordinateSystem(preserveAspectRatio=false)));
end PressureReliefValve;
