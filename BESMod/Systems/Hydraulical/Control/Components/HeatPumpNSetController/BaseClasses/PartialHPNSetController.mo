within BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.BaseClasses;
partial model PartialHPNSetController "Partial HP Controller model"
  Modelica.Blocks.Interfaces.BooleanInput HP_On
    "True if heat pump is turned on according to two point controller"
annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput n_Set "Relative compressor set value"
annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput T_Set "Current set temperature"
annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput T_Meas "Current measured temperature"
annotation (Placement(transformation(
    extent={{-20,-20},{20,20}},
    rotation=90,
    origin={0,-120})));
  Modelica.Blocks.Math.Feedback feedback
annotation (Placement(transformation(extent={{4,90},{24,110}})));
  Modelica.Blocks.Continuous.Integrator integrator
annotation (Placement(transformation(extent={{70,104},{90,124}})));
  Modelica.Blocks.Interfaces.RealOutput IAE "Integral Absolute Error"
annotation (Placement(transformation(extent={{100,90},{120,110}}),
    iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput ISE "Integral Square Error" annotation (
 Placement(transformation(extent={{100,70},{120,90}}), iconTransformation(
      extent={{100,50},{120,70}})));
  Modelica.Blocks.Math.Abs abs1
annotation (Placement(transformation(extent={{36,104},{56,124}})));
  Modelica.Blocks.Continuous.Integrator integrator1
annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Blocks.Math.Product product "Square the difference"
annotation (Placement(transformation(extent={{38,70},{58,90}})));
  Modelica.Blocks.Interfaces.BooleanInput IsOn(start=true)
    "True if heat pump is actually on" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
equation
  connect(
      T_Set, feedback.u1) annotation (Line(points={{-120,60},{-100,60},{
      -100,100},{6,100}}, color={0,0,127}));
  connect(
      T_Meas, feedback.u2) annotation (Line(points={{0,-120},{0,-84},{-88,
      -84},{-88,88},{14,88},{14,92}}, color={0,0,127}));
  connect(
      feedback.y, abs1.u) annotation (Line(points={{23,100},{24,100},{24,
      114},{34,114}}, color={0,0,127}));
  connect(
      abs1.y, integrator.u)
annotation (Line(points={{57,114},{68,114}}, color={0,0,127}));
  connect(
      integrator.y, IAE) annotation (Line(points={{91,114},{96,114},{96,98},
      {110,98},{110,100}}, color={0,0,127}));
  connect(
      ISE, integrator1.y)
annotation (Line(points={{110,80},{91,80}}, color={0,0,127}));
  connect(
      feedback.y, product.u1) annotation (Line(points={{23,100},{30,100},{
      30,86},{36,86}}, color={0,0,127}));
  connect(
      integrator1.u, product.y)
annotation (Line(points={{68,80},{59,80}}, color={0,0,127}));
  connect(
      feedback.y, product.u2) annotation (Line(points={{23,100},{30,100},{
      30,74},{36,74}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(
    coordinateSystem(preserveAspectRatio=false)));
end PartialHPNSetController;
