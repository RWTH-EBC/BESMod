within BESMod.Utilities.KPIs;
model ComfortCalculator "Cacluate the discomort in K*s"

  parameter Modelica.Units.SI.Temperature TComBou
    "Comfort boundary temperature";
  parameter Boolean for_heating = true "=false to calculate comfort during cooling period (summer). = true for heating";

  Modelica.Blocks.Nonlinear.Limiter lim(final uMax=Modelica.Constants.inf,
      final uMin=0)
    annotation (Placement(transformation(extent={{8,-14},{28,6}})));
  Modelica.Blocks.Continuous.Integrator intDisCom(
    final k=1,
    final use_reset=false,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=0)
    annotation (Placement(transformation(extent={{44,-14},{64,6}})));
  Modelica.Blocks.Math.Add add(final k1=if for_heating then -1 else 1,
      final k2=if for_heating then 1 else -1)
    annotation (Placement(transformation(extent={{-26,-16},{-6,4}})));
  Modelica.Blocks.Sources.Constant const(k=TComBou)
    annotation (Placement(transformation(extent={{-66,-30},{-46,-10}})));
  Modelica.Blocks.Interfaces.RealOutput dTComSec(unit="K.s")
                                                 "K*s discomfort"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TZone(unit="K")
                                             "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

equation
  connect(add.u2, const.y) annotation (Line(points={{-28,-12},{-38,-12},{-38,-20},
          {-45,-20}}, color={0,0,127}));
  connect(intDisCom.y, dTComSec) annotation (Line(points={{65,-4},{88,-4},{88,0},
          {110,0}}, color={0,0,127}));
  connect(lim.y, intDisCom.u)
    annotation (Line(points={{29,-4},{42,-4}}, color={0,0,127}));
  connect(add.u1, TZone)
    annotation (Line(points={{-28,0},{-120,0}}, color={0,0,127}));
  connect(add.y, lim.u)
    annotation (Line(points={{-5,-6},{0,-6},{0,-4},{6,-4}}, color={0,0,127}));
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
          textString="%name")}),                                 Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Calculate the comfort during either heating or cooling period. Based on EN 15251, which defines a 2 K bandwith around a set temperature of 22 &deg;C.</p>
</html>"));
end ComfortCalculator;
