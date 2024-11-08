within BESMod.Utilities.KPIs.BaseClasses;
model SplitGainAndLoss
  "Model to split an energy input value into gain and loss"
  Modelica.Blocks.Nonlinear.Limiter limLoss(final uMax=0, final uMin=-Modelica.Constants.inf)
    "Only use negative values (loss)"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Nonlinear.Limiter limGain(final uMax=Modelica.Constants.inf,
      final uMin=0)  "Only use positive values (gain)"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Utilities.KPIs.EnergyKPICalculator gainKPI(final use_inpCon=true)
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,30})));
  Utilities.KPIs.EnergyKPICalculator lossKPI(final use_inpCon=true)
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-30})));
  Modelica.Blocks.Interfaces.RealInput u "Energy flow"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Utilities.KPIs.BaseClasses.KPIIntegral gain "KPIs for gain" annotation (
      Placement(transformation(extent={{102,40},{122,60}}), iconTransformation(
          extent={{102,40},{122,60}})));
  Utilities.KPIs.BaseClasses.KPIIntegral loss "KPIs for loss" annotation (
      Placement(transformation(extent={{100,-40},{120,-20}}),
        iconTransformation(extent={{102,-60},{122,-40}})));
equation
  connect(limGain.u, u) annotation (Line(points={{-42,30},{-94,30},{-94,0},{-120,
          0}}, color={0,0,127}));
  connect(limLoss.y, lossKPI.u)
    annotation (Line(points={{-19,-30},{18.2,-30}}, color={0,0,127}));
  connect(limGain.y, gainKPI.u)
    annotation (Line(points={{-19,30},{18.2,30}}, color={0,0,127}));
  connect(limLoss.u, u) annotation (Line(points={{-42,-30},{-94,-30},{-94,0},{-120,
          0}}, color={0,0,127}));
  connect(lossKPI.KPI, loss) annotation (Line(points={{42.2,-30},{110,-30}},
        color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gainKPI.KPI, gain) annotation (Line(points={{42.2,30},{78,30},{78,50},
          {112,50}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{102,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                              Text(
          extent={{-102,-70},{102,-166}},
          lineColor={0,0,0},
          textString="%name%")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end SplitGainAndLoss;
