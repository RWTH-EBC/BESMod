within BESMod.Systems.Control;
model DHWSuperheating "Increase the DHW set temperature at 12 pm for 1 h"
  extends BaseClasses.PartialControl;
  Modelica.Blocks.Sources.RealExpression realExpression(y=mod(time, 86400))
    annotation (Placement(transformation(extent={{-92,-44},{-72,-24}})));
  Modelica.Blocks.Logical.OnOffController onOffController(bandwidth=dtOveHea)
    annotation (Placement(transformation(extent={{-58,-28},{-38,-8}})));
  Modelica.Blocks.Sources.Constant const(k=houOveHea)
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
  parameter Modelica.Units.SI.Time houOveHea(displayUnit="h") = 43200
    "Time of the day where overheating of DHW starts";
  parameter Modelica.Units.SI.Time dtOveHea(displayUnit="h") = 3600
    "Time prior and after houOveHea to activate overheating";
  parameter Modelica.Units.SI.Temperature TSetDHW "DHW set temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTDHW=5
    "Temperature added to DHW setpoint on overheating";

  Modelica.Blocks.Sources.Constant const1(k=TSetDHW + dTDHW)
    annotation (Placement(transformation(extent={{-94,24},{-74,44}})));
  Electrical.Interfaces.SystemControlBus systemControlBus annotation (Placement(
        transformation(extent={{-14,-118},{18,-84}}), iconTransformation(extent=
           {{-14,-118},{18,-84}})));
equation
  connect(realExpression.y, onOffController.u) annotation (Line(points={{-71,-34},
          {-66,-34},{-66,-24},{-60,-24}}, color={0,0,127}));
  connect(onOffController.y, sigBusHyd.overwriteTSetDHW) annotation (Line(
        points={{-37,-18},{-26,-18},{-26,-86},{-79,-86},{-79,-101}}, color={255,
          0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(onOffController.reference, const.y) annotation (Line(points={{-60,-12},
          {-66,-12},{-66,0},{-71,0}}, color={0,0,127}));
  connect(const1.y, sigBusHyd.TSetDHW) annotation (Line(points={{-73,34},{-26,34},
          {-26,-86},{-79,-86},{-79,-101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end DHWSuperheating;
