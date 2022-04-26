within BESMod.Utilities.KPIs;
model CountTimeDiscomfort
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{6,14},{26,34}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{6,-28},{26,-8}})));
  Modelica.Blocks.Interfaces.RealOutput discomfortTime
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Continuous.Integrator integrator3(use_reset=true)
    annotation (Placement(transformation(extent={{76,-6},{88,6}})));
  Modelica.Blocks.Interfaces.RealInput T "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Logical.LessThreshold
                                 switch2(threshold=TRoomSet)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  parameter Modelica.Media.Interfaces.Types.Temperature TRoomSet=293.15
    "Room set temperature";
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{8,-70},{28,-50}})));
equation
  connect(switch1.u1, const.y) annotation (Line(points={{38,8},{32,8},{32,24},{
          27,24}},   color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{27,-18},{34,-18},{34,
          -8},{38,-8}},
                     color={0,0,127}));
  connect(switch1.y, integrator3.u)
    annotation (Line(points={{61,0},{74.8,0}},     color={0,0,127}));
  connect(discomfortTime, integrator3.y)
    annotation (Line(points={{110,0},{88.6,0}}, color={0,0,127}));
  connect(T, switch2.u)
    annotation (Line(points={{-120,0},{-52,0}}, color={0,0,127}));
  connect(switch2.y, switch1.u2)
    annotation (Line(points={{-29,0},{38,0}}, color={255,0,255}));
  connect(not1.y, integrator3.reset) annotation (Line(points={{29,-60},{90,-60},
          {90,-7.2},{85.6,-7.2}}, color={255,0,255}));
  connect(switch2.y, not1.u) annotation (Line(points={{-29,0},{-22,0},{-22,-60},
          {6,-60}}, color={255,0,255}));
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
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Calculate the time discomfort is present. Useful to check if discomfort values are high due to frequent small deviations or some long, possibly big deviations. The latter may indicate the system is undersized for the given demand.</p>
</html>"));
end CountTimeDiscomfort;
