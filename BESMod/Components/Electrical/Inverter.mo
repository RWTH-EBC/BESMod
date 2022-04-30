within BESMod.Components.Electrical;
model Inverter "Inverter to convert DC to AC current"
  Modelica.Blocks.Sources.RealExpression P_out(y=P_AC_out)
    annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  Modelica.Blocks.Nonlinear.Limiter InverterLimits(uMax=P_Max, uMin=P_Min) "Inverter Limits"  annotation (Placement(transformation(extent={{48,-10},
            {68,10}})));
  Modelica.Blocks.Interfaces.RealInput P_DC "AC charging signal" annotation (
      Placement(transformation(extent={{-122,-20},{-82,20}}),
        iconTransformation(extent={{-122,-20},{-82,20}})));
  Modelica.Blocks.Interfaces.RealOutput P_AC "DC charging signal" annotation (
      Placement(transformation(extent={{96,-10},{116,10}}),  iconTransformation(
          extent={{72,-14},{100,14}})));
  parameter Real P_Max "Maximum inverter power";
  parameter Real P_Min "Minimum inverter power";

  parameter Real a1 = 0.002409 "curve parameter" annotation (choicesAllMatching, Dialog(group="Parameter"));
  parameter Real a2 = 0.00561 "curve parameter" annotation (choicesAllMatching, Dialog(group="Parameter"));
  parameter Real a3 = 0.01228 "curve parameter" annotation (choicesAllMatching, Dialog(group="Parameter"));

  Real eta "Load-dependend inverter efficiency";

  Real P_AC_out "AC power after inverter";
  Real P_0 "Initial relative power";

equation
  P_0 = P_DC / P_Max;
  eta = max(Modelica.Constants.eps,P_0 / (P_0 + a1 + a2* P_0 + a3 * P_0^2));
  P_AC_out = P_DC * eta;
  connect(P_out.y,InverterLimits. u)
    annotation (Line(points={{25,0},{46,0}}, color={0,0,127}));
  connect(InverterLimits.y,P_AC)
    annotation (Line(points={{69,0},{106,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
     Rectangle(
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      extent={{-100,100},{100,-100}}),
        Line(points={{100,100},{-100,-100}}, color={0,0,0}),
        Line(points={{-70,64},{-10,64}}, color={0,0,0}),
        Line(points={{-70,52},{-10,52}}, color={0,0,0}),
        Line(
          points={{12,-56},{14,-50},{16,-48},{18,-46},{24,-44},{30,-44},{34,-46},
              {38,-50},{40,-52},{42,-54},{46,-56},{56,-56},{62,-52},{64,-44}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{14,-72},{16,-66},{18,-64},{20,-62},{26,-60},{32,-60},{36,-62},
              {40,-66},{42,-68},{44,-70},{48,-72},{58,-72},{64,-68},{66,-60}},
          color={0,0,0},
          smooth=Smooth.Bezier)}), Diagram(graphics,
                                           coordinateSystem(preserveAspectRatio=
           false)));
end Inverter;
