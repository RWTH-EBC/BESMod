within BESMod.Utilities.KPIs;
model ComfortCalculator_TSet_notConstant "Cacluate the discomort in K*s"

  parameter Modelica.Units.SI.Temperature TComBou;
  parameter Modelica.Units.SI.TemperatureDifference dT_night;
  parameter Modelica.Units.NonSI.Time_hour hMorning;
  parameter Modelica.Units.NonSI.Time_hour timeRamp;

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
  Modelica.Blocks.Interfaces.RealOutput dTComSec(unit="K.s")
                                                 "K*s discomfort"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TZone(unit="K")
                                             "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=dT_night,
    rising=timeRamp*60*60,
    width=(24 - hMorning)*60*60,
    falling=0,
    period=24*60*60,
    offset=TComBou - dT_night,
    startTime=(hMorning - timeRamp)*60*60)
    annotation (Placement(transformation(extent={{-66,-32},{-44,-10}})));
equation
  connect(intDisCom.y, dTComSec) annotation (Line(points={{65,-4},{88,-4},{88,0},
          {110,0}}, color={0,0,127}));
  connect(lim.y, intDisCom.u)
    annotation (Line(points={{29,-4},{42,-4}}, color={0,0,127}));
  connect(add.u1, TZone)
    annotation (Line(points={{-28,0},{-120,0}}, color={0,0,127}));
  connect(add.y, lim.u)
    annotation (Line(points={{-5,-6},{0,-6},{0,-4},{6,-4}}, color={0,0,127}));
  connect(trapezoid.y, add.u2) annotation (Line(points={{-42.9,-21},{-34,-21},{-34,
          -12},{-28,-12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-62,52},{66,-68}},
          lineColor={0,0,0},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Calculate the comfort during either heating or cooling period. Based on EN 15251, which defines a 2 K bandwith around a set temperature of 22 &deg;C.</p>
</html>"));
end ComfortCalculator_TSet_notConstant;
