within BESMod.Systems.Control;
model DHWSuperheating "Increase the DHW set temperature at 12 pm for 1 h"
  extends BaseClasses.PartialControl;
  Modelica.Blocks.Sources.RealExpression reaExp(y=mod(time, 86400)) "Time of day"
    annotation (Placement(transformation(extent={{-92,-44},{-72,-24}})));
  Modelica.Blocks.Logical.OnOffController hys(bandwidth=dtOveHea)
    "Hysteresis for overwriting"
    annotation (Placement(transformation(extent={{-58,-28},{-38,-8}})));
  Modelica.Blocks.Sources.Constant const(k=houOveHea)
    "Constant hour of overheating"
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
  parameter Modelica.Units.SI.Time houOveHea(displayUnit="h") = 43200
    "Time of the day where overheating of DHW starts";
  parameter Modelica.Units.SI.Time dtOveHea(displayUnit="h") = 3600
    "Time prior and after houOveHea to activate overheating";
  parameter Modelica.Units.SI.Temperature TSetDHW "DHW set temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTDHW=5
    "Temperature added to DHW setpoint on overheating";

  Modelica.Blocks.Sources.Constant constTSetDHW(k=TSetDHW + dTDHW)
    "Constant set temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Electrical.Interfaces.SystemControlBus systemControlBus annotation (Placement(
        transformation(extent={{-14,-118},{18,-84}}), iconTransformation(extent=
           {{-14,-118},{18,-84}})));
equation
  connect(reaExp.y, hys.u) annotation (Line(points={{-71,-34},{-66,-34},{-66,-24},
          {-60,-24}}, color={0,0,127}));
  connect(hys.reference, const.y) annotation (Line(points={{-60,-12},{-66,-12},{-66,
          0},{-71,0}}, color={0,0,127}));
  connect(constTSetDHW.y, sigBusHyd.TSetDHWOve) annotation (Line(points={{-59,30},
          {-54,30},{-54,-4},{-68,-4},{-68,-20},{-96,-20},{-96,-84},{-79,-84},{-79,
          -101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hys.y, sigBusHyd.oveTSetDHW) annotation (Line(points={{-37,-18},{-26,-18},
          {-26,-86},{-80,-86},{-80,-94},{-79,-94},{-79,-101}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>This supervisory control increases the DHW set temperature by 5 K at 12pm for 1h.</p>
</html>"));
end DHWSuperheating;
