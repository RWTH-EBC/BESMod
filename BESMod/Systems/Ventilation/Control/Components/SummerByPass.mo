within BESMod.Systems.Ventilation.Control.Components;
model SummerByPass

  parameter Integer day_summer_start = 31 + 28 + 31 + 30 "Day the summertime starts. Default to 1th of May";
  parameter Integer day_summer_end = day_summer_start + 31 + 30 + 31 + 31 + 30
                                                                              "Day the summertime ends. Default to 30th of September";
  parameter Real k=1 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti=120 "Time constant of Integrator block";
  IBPSA.Controls.Continuous.LimPID conPIDHeatingCooling(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=0,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=0,
    final reverseActing=false)
    annotation (Placement(transformation(extent={{-2,-58},{18,-38}})));
  Modelica.Blocks.Logical.Switch        switch1
    annotation (Placement(transformation(extent={{46,10},{66,-10}})));
  Modelica.Blocks.Sources.Constant constClosed(k=0)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.BooleanExpression isSummer(y=(time > 86400*
        day_summer_start) and (time < 86400*day_summer_end))
    annotation (Placement(transformation(extent={{-74,16},{-44,-10}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Blocks.Logical.Less and2
    annotation (Placement(transformation(extent={{-64,24},{-44,44}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TMea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Connector of first Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TOda(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealInput TZoneSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Connector of first Real input signal"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
equation
  connect(constClosed.y,switch1. u3)
    annotation (Line(points={{21,40},{26,40},{26,8},{44,8}}, color={0,0,127}));
  connect(conPIDHeatingCooling.y,switch1. u1) annotation (Line(points={{19,-48},
          {40,-48},{40,-8},{44,-8}},   color={0,0,127}));
  connect(switch1.u2, and1.y)
    annotation (Line(points={{44,0},{7,0}}, color={255,0,255}));
  connect(isSummer.y, and1.u2) annotation (Line(points={{-42.5,3},{-34,3},{-34,-8},
          {-16,-8}}, color={255,0,255}));
  connect(and2.y, and1.u1) annotation (Line(points={{-43,34},{-28,34},{-28,0},{
          -16,0}},
               color={255,0,255}));
  connect(switch1.y, y)
    annotation (Line(points={{67,0},{110,0}}, color={0,0,127}));
  connect(TMea, conPIDHeatingCooling.u_m) annotation (Line(points={{-120,0},{-78,
          0},{-78,-66},{8,-66},{8,-60}}, color={0,0,127}));
  connect(TZoneSet, conPIDHeatingCooling.u_s) annotation (Line(points={{-120,
          -60},{-44,-60},{-44,-48},{-4,-48}}, color={0,0,127}));
  connect(TOda, and2.u1) annotation (Line(points={{-120,60},{-76,60},{-76,34},{
          -66,34}}, color={0,0,127}));
  connect(TMea, and2.u2) annotation (Line(points={{-120,0},{-88,0},{-88,26},{
          -66,26}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SummerByPass;
