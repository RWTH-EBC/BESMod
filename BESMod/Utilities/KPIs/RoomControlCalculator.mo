within BESMod.Utilities.KPIs;
model RoomControlCalculator "Cacluate the room control quality in K*s"

  extends BESMod.Utilities.KPIs.BaseClasses.KPIIcon;
  parameter Boolean for_heating = true "=false to calculate comfort during cooling period (summer). = true for heating";

  Modelica.Blocks.Nonlinear.Limiter lim(final uMax=Modelica.Constants.inf,
      final uMin=0)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Modelica.Blocks.Continuous.Integrator intDisCom(
    final k=1,
    final use_reset=false,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=0)
    annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  Modelica.Blocks.Math.Add add(final k1=if for_heating then -1 else 1,
      final k2=if for_heating then 1 else -1)
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Modelica.Blocks.Sources.Constant const(k=dTComBou)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Interfaces.RealOutput dTComSec(unit="K.s")
                                                 "K*s discomfort"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TZone(unit="K")
                                             "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput TZoneSet
    "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  parameter Real dTComBou=0;
equation
  connect(intDisCom.y, dTComSec) annotation (Line(points={{63,0},{110,0}},
                    color={0,0,127}));
  connect(lim.y, intDisCom.u)
    annotation (Line(points={{29,0},{40,0}},   color={0,0,127}));
  connect(add.u1, TZone)
    annotation (Line(points={{-28,6},{-74,6},{-74,0},{-120,0}},
                                                color={0,0,127}));
  connect(add.y, lim.u)
    annotation (Line(points={{-5,0},{6,0}},                 color={0,0,127}));
  connect(add1.u2, TZoneSet) annotation (Line(points={{-42,-56},{-94,-56},{-94,
          -60},{-120,-60}},     color={0,0,127}));
  connect(const.y, add1.u1) annotation (Line(points={{-59,-30},{-50,-30},{-50,
          -44},{-42,-44}},
                 color={0,0,127}));
  connect(add1.y, add.u2) annotation (Line(points={{-19,-50},{-16,-50},{-16,-24},
          {-38,-24},{-38,-6},{-28,-6}},
                                     color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>Calculate the comfort during either heating or cooling period. Based on EN 15251, which defines a 2 K bandwith around a set temperature of 22 &deg;C.</p>
</html>"));
end RoomControlCalculator;
