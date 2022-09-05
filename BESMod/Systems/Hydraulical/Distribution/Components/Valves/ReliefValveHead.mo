within BESMod.Systems.Hydraulical.Distribution.Components.Valves;
model ReliefValveHead
  parameter Modelica.Units.SI.PressureDifference dpThreshold=0.98*dpFullOpen;
  parameter Modelica.Units.SI.PressureDifference dpFullOpen;
  final parameter Real nu=dpThreshold/(dpFullOpen);
  parameter Real fGain=1 "Gain value multiplied with input signal";
  final parameter Modelica.Units.SI.Area fUnit=1 "To convert unit Pa to N (Pa*m2)";
  final parameter Real offset=0 "Offset for s_rel0";
  parameter Real fSpringConst=1 "Factor for spring constant";

  Modelica.Mechanics.Translational.Components.Fixed
                                 fixed1(s0(displayUnit="m") = 0)
                                                 annotation (Placement(
        transformation(extent={{-86,50},{-66,70}})));
  Modelica.Mechanics.Translational.Components.Spring spring(
    c=-dpThreshold*fUnit/spring.s_rel0,
    s_rel0(displayUnit="m") = nu/(1 - nu) + offset,
    s_rel(
      fixed=false,
      displayUnit="m",
      start=0))  annotation (Placement(transformation(extent={{-56,50},{-36,70}})));
  Modelica.Mechanics.Translational.Sources.Force force annotation (Placement(transformation(extent={{10,50},{-10,70}})));
  Modelica.Mechanics.Translational.Sensors.PositionSensor positionSensor1 annotation (Placement(transformation(extent={{-10,22},{10,42}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=1, uMin=0) annotation (Placement(transformation(extent={{56,14},{66,24}})));
  Modelica.Blocks.Interfaces.RealOutput y(
    unit="1",
    min=0,
    max=1) "Connector of Real output signal" annotation (Placement(transformation(extent={{88,8},{110,30}}), iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealInput pressureSignal(quantity="PressureDifference", unit="Pa") "Input signal connector"         annotation (Placement(transformation(extent={{112,48},{88,72}}), iconTransformation(extent={{120,60},{100,80}})));

  Modelica.Blocks.Math.Gain gain(k=fGain) annotation (Placement(transformation(extent={{28,14},{38,24}})));

  Modelica.Blocks.Math.Gain unitConv(k=fUnit) annotation (Placement(transformation(extent={{52,56},{44,64}})));
initial equation
  assert(
    dpFullOpen > dpThreshold,
    "dpFullOpen must be greater than dpThreshold",
    AssertionLevel.error);
equation
  connect(spring.flange_a, fixed1.flange) annotation (Line(points={{-56,60},{-76,60}}, color={0,127,0}));
  connect(spring.flange_b, force.flange) annotation (Line(points={{-36,60},{-10,60}}, color={0,127,0}));
  connect(force.flange, positionSensor1.flange) annotation (Line(points={{-10,60},{-10,32}}, color={0,127,0}));
  connect(limiter.y, y) annotation (Line(points={{66.5,19},{99,19}},                        color={0,0,127}));
  connect(positionSensor1.s, gain.u) annotation (Line(points={{11,32},{16,32},{16,19},{27,19}}, color={0,0,127}));
  connect(gain.y, limiter.u) annotation (Line(points={{38.5,19},{55,19}}, color={0,0,127}));
  connect(pressureSignal, unitConv.u) annotation (Line(points={{100,60},{52.8,60}}, color={0,0,127}));
  connect(unitConv.y, force.f) annotation (Line(points={{43.6,60},{12,60}}, color={0,0,127}));
  annotation (preferredView="Documentation",
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,70},{80,-62},{70,-62},{70,70},{50,-62},{40,-62},{60,70},{80,70}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,70},{40,-62},{30,-62},{30,70},{10,-62},{0,-62},{20,70},{40,70}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,70},{0,-62},{-10,-62},{-10,70},{-30,-62},{-40,-62},{-20,70},{0,70}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,80},{-80,-72}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-80,80},{88,70}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-80,-62},{88,-72}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag),
        Polygon(
          points={{-40,70},{-40,-62},{-50,-62},{-50,70},{-70,-62},{-80,-62},{-60,70},{-40,70}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>How to use</p>
<p>The bandwidth between <span style=\"font-family: Courier New;\">dpThreshold</span> and <span style=\"font-family: Courier New;\">dpFullOpen</span> is crucial. If a simulation becomes unstabile, make this bandwidth broader.</p>
<p>If the pressure relief valve should open later, raise the parameter <span style=\"font-family: Courier New;\">dpThreshold.</span></p>
</html>"));
end ReliefValveHead;
