within BESMod.Utilities.KPIs;
model CountOnTime
  Modelica.Blocks.Sources.IntegerConstant integerConstant(final k=1)
    annotation (Placement(transformation(extent={{-48,26},{-32,42}})));
  Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd(final use_reset=false,
      final y_start=0)
    "To count on-off cycles"
    annotation (Placement(transformation(extent={{-16,24},{0,42}})));
  Modelica.Blocks.Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerOutput numSwi "Integer output signal"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{6,-36},{26,-16}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{6,-78},{26,-58}})));
  Modelica.Blocks.Interfaces.RealOutput onTime
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Continuous.Integrator integrator3
    annotation (Placement(transformation(extent={{76,-56},{88,-44}})));
equation
  connect(integerConstant.y, triggeredAdd.u) annotation (Line(points={{-31.2,34},
          {-23.6,34},{-23.6,33},{-19.2,33}}, color={255,127,0}));
  connect(triggeredAdd.trigger, u) annotation (Line(points={{-12.8,22.2},{-12.8,
          0},{-120,0}}, color={255,0,255}));
  connect(triggeredAdd.y, numSwi) annotation (Line(points={{1.6,33},{39.8,33},{39.8,
          80},{110,80}}, color={255,127,0}));
  connect(u, switch1.u2) annotation (Line(points={{-120,0},{-14,0},{-14,-50},{38,
          -50}}, color={255,0,255}));
  connect(switch1.u1, const.y) annotation (Line(points={{38,-42},{32,-42},{32,-26},
          {27,-26}}, color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{27,-68},{34,-68},{34,-58},
          {38,-58}}, color={0,0,127}));
  connect(switch1.y, integrator3.u)
    annotation (Line(points={{61,-50},{74.8,-50}}, color={0,0,127}));
  connect(onTime, integrator3.y)
    annotation (Line(points={{110,-50},{88.6,-50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-62,52},{66,-68}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%name")}), Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end CountOnTime;
