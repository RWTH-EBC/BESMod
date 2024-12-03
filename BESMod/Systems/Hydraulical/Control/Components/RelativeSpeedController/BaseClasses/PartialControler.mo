within BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.BaseClasses;
partial model PartialControler "Partial controller model"
  parameter Real yMax=1 "Upper limit of output";

  Modelica.Blocks.Interfaces.BooleanInput setOn(final start=true)
    "True if the device is set to turn on"
annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput ySet "Relative set value"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Current set temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TMea(displayUnit="degC", unit="K")
    "Current measured temperature" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Math.Feedback feedback
annotation (Placement(transformation(extent={{4,90},{24,110}})));
  Modelica.Blocks.Continuous.Integrator intAbs "Integrator of absolute error"
    annotation (Placement(transformation(extent={{70,104},{90,124}})));
  Modelica.Blocks.Interfaces.RealOutput IAE "Integral Absolute Error"
annotation (Placement(transformation(extent={{100,90},{120,110}}),
    iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput ISE "Integral Square Error" annotation (
 Placement(transformation(extent={{100,40},{120,60}}), iconTransformation(
      extent={{100,40},{120,60}})));
  Modelica.Blocks.Math.Abs abs1
annotation (Placement(transformation(extent={{36,104},{56,124}})));
  Modelica.Blocks.Continuous.Integrator intSqu "Integrator of squared error"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Blocks.Math.Product pro "Square the difference"
    annotation (Placement(transformation(extent={{38,70},{58,90}})));
  Modelica.Blocks.Interfaces.BooleanInput isOn(final start=true)
    "True if the device is actually on"
                                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
equation
  connect(TSet, feedback.u1) annotation (Line(points={{-120,60},{-100,60},{-100,
          100},{6,100}}, color={0,0,127}));
  connect(TMea, feedback.u2) annotation (Line(points={{0,-120},{0,-84},{-88,-84},
          {-88,88},{14,88},{14,92}}, color={0,0,127}));
  connect(
      feedback.y, abs1.u) annotation (Line(points={{23,100},{24,100},{24,114},{34,
          114}},      color={0,0,127}));
  connect(abs1.y, intAbs.u)
    annotation (Line(points={{57,114},{68,114}}, color={0,0,127}));
  connect(intAbs.y, IAE) annotation (Line(points={{91,114},{96,114},{96,98},{110,
          98},{110,100}}, color={0,0,127}));
  connect(ISE, intSqu.y) annotation (Line(points={{110,50},{100,50},{100,80},{91,
          80}}, color={0,0,127}));
  connect(feedback.y, pro.u1) annotation (Line(points={{23,100},{30,100},{30,86},
          {36,86}}, color={0,0,127}));
  connect(intSqu.u, pro.y)
    annotation (Line(points={{68,80},{59,80}}, color={0,0,127}));
  connect(feedback.y, pro.u2) annotation (Line(points={{23,100},{30,100},{30,74},
          {36,74}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(graphics,
    coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>
This is a partial controller model that serves as a base class for relative speed controllers. 
It includes basic controller functionality with temperature feedback and error calculation. 
The model provides both Integral Absolute Error (IAE) and Integral Square Error (ISE) as performance metrics.
</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>yMax</code>: Upper limit of controller output (default = 1)</li>
</ul>
</html>"));
end PartialControler;
