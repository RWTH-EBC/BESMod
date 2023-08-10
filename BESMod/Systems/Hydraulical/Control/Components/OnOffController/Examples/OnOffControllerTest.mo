within BESMod.Systems.Hydraulical.Control.Components.OnOffController.Examples;
model OnOffControllerTest
  extends Modelica.Icons.Example;

  OnOffController.ConstantHysteresisTimeBasedHR
    constantHysteresisTimeBasedHR(dt_hr=1800)
    annotation (Placement(transformation(extent={{-28,42},{16,82}})));
  BESMod.Systems.Hydraulical.Control.Components.OnOffController.DegreeMinuteController
    degreeMinuteController(DegreeMinuteReset=100) annotation (Placement(
        transformation(
        extent={{-21,-20},{21,20}},
        rotation=0,
        origin={-5,2})));
  BESMod.Systems.Hydraulical.Control.Components.OnOffController.FloatingHysteresis
    floatingHysteresis(Hysteresis_max=15, Hysteresis_min=2)
    annotation (Placement(transformation(extent={{-26,-76},{16,-38}})));
  Modelica.Blocks.Sources.Constant T_Set(k=323.15)
    annotation (Placement(transformation(extent={{-160,-20},{-124,16}})));
  Modelica.Blocks.Sources.Sine T_Top(
    amplitude=30,
    f=1/3600,
    offset=313.15)
    annotation (Placement(transformation(extent={{-160,44},{-122,82}})));
  Modelica.Blocks.Sources.Constant T_Set1(k=273.15)
    annotation (Placement(transformation(extent={{-152,-90},{-116,-54}})));
equation
  connect(T_Set.y, degreeMinuteController.TSupSet) annotation (Line(points={{-122.2,
          -2},{-106,-2},{-106,0},{-70,0},{-70,-28},{-5,-28},{-5,-20}}, color={0,0,
          127}));
  connect(T_Set.y, floatingHysteresis.TSupSet) annotation (Line(points={{-122.2,-2},
          {-86,-2},{-86,-94},{-5,-94},{-5,-77.9}}, color={0,0,127}));
  connect(T_Set.y, constantHysteresisTimeBasedHR.TSupSet) annotation (Line(points=
         {{-122.2,-2},{-112,-2},{-112,-4},{-80,-4},{-80,32},{-6,32},{-6,40}},
        color={0,0,127}));
  connect(T_Top.y, constantHysteresisTimeBasedHR.TStoTop) annotation (Line(points=
         {{-120.1,63},{-44,63},{-44,76},{-30.2,76}}, color={0,0,127}));
  connect(T_Top.y, constantHysteresisTimeBasedHR.TStoBot) annotation (Line(points=
         {{-120.1,63},{-72,63},{-72,40},{-44,40},{-44,52},{-30.2,52}}, color={0,0,
          127}));
  connect(T_Top.y, degreeMinuteController.TStoTop) annotation (Line(points={{-120.1,
          63},{-96,63},{-96,16},{-28.1,16}}, color={0,0,127}));
  connect(T_Top.y, degreeMinuteController.TStoBot) annotation (Line(points={{-120.1,
          63},{-88,63},{-88,-8},{-28.1,-8}}, color={0,0,127}));
  connect(T_Top.y, floatingHysteresis.TStoTop) annotation (Line(points={{-120.1,
          63},{-92,63},{-92,-43.7},{-28.1,-43.7}}, color={0,0,127}));
  connect(T_Top.y, floatingHysteresis.TStoBot) annotation (Line(points={{-120.1,
          63},{-90,63},{-90,-66.5},{-28.1,-66.5}}, color={0,0,127}));
  connect(T_Set1.y, floatingHysteresis.TOda) annotation (Line(points={{-114.2,-72},
          {-60.1,-72},{-60.1,-35.72},{-5,-35.72}}, color={0,0,127}));
  connect(T_Set1.y, degreeMinuteController.TOda) annotation (Line(points={{-114.2,
          -72},{-58,-72},{-58,24.4},{-5,24.4}}, color={0,0,127}));
  connect(T_Set1.y, constantHysteresisTimeBasedHR.TOda) annotation (Line(points={
          {-114.2,-72},{-60,-72},{-60,84.4},{-6,84.4}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=1));
end OnOffControllerTest;
