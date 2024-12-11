within BESMod.Systems.Hydraulical.Distribution.Components.Valves;
model PressureReliefValve
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface;
  parameter Modelica.Units.SI.PressureDifference dpFullOpen_nominal "Pressure difference at which valve is fully open";
  parameter Modelica.Units.SI.PressureDifference dpThreshold_nominal = 0.95*dpFullOpen_nominal "Threshold at which valve starts to open";
  IBPSA.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    final dpValve_nominal=dpValve_nominal,
    final use_strokeTime=use_strokeTime,
    final strokeTime(displayUnit="s") = strokeTime,
    final init=init,
    y_start=y_start,
    final dpFixed_nominal=0,
    final l=l)                                            annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Real facDpValve_nominal(min=0, max=1) = 0.5 "Factor to design dpValve_nominal";
  parameter Real l=0.001 "Valve leakage, l=Kv(y=0)/Kv(y=1)";

  parameter Boolean use_strokeTime=true "= true, if opening is filtered with a 2nd order CriticalDamping filter" annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.Units.SI.Time strokeTime=10 "Rise time of the filter (time to reach 99.6 % of an opening step)" annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_strokeTime));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal = facDpValve_nominal*(dpFullOpen_nominal - dpThreshold_nominal) + dpThreshold_nominal;

  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput "Type of initialization (no init/steady state/initial state/initial output)" annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_strokeTime));
  parameter Real y_start=1 "Initial value of output" annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_strokeTime));
  Modelica.Blocks.Nonlinear.Limiter limiter(final uMax=1, final uMin=0.01)
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
  Modelica.Blocks.Sources.RealExpression
                                   realExpression(y=dp)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,50})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k=1, T=360) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={30,52})));
equation
  connect(port_a, val.port_a) annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(val.port_b, port_b) annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(const.y, add.u2) annotation (Line(points={{19,90},{18,90},{18,76},{2,76}},
        color={0,0,127}));
  connect(limiter.y, val.y) annotation (Line(points={{-39,30},{-26,30},{-26,20},
          {0,20},{0,12}}, color={0,0,127}));
  connect(gain.u, add.y)
    annotation (Line(points={{-38,70},{-21,70}}, color={0,0,127}));
  connect(gain.y, limiter.u) annotation (Line(points={{-61,70},{-68,70},{-68,30},
          {-62,30}}, color={0,0,127}));
  connect(realExpression.y, firstOrder.u)
    annotation (Line(points={{59,50},{59,52},{42,52}}, color={0,0,127}));
  connect(firstOrder.y, add.u1) annotation (Line(points={{19,52},{10,52},{10,64},
          {2,64}}, color={0,0,127}));
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
          fillPattern=FillPattern.CrossDiag)}),                  Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model for a pressure relief valve. If the pressure difference between supply and return passes dpThreshold_nominal, the valve starts to open. At dpFullOpen_nominal, the valve is fully opened. </p>
<p>Using this valve ensure a minimal mass flow rate in a transfer system.</p>
</html>"));
end PressureReliefValve;
