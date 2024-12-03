within BESMod.Systems.Hydraulical.Control.Components.SummerMode;
model HeatingThresholdAndDateBased "Heating threshold and date based summer mode"
  extends BaseClasses.PartialSummerMode;
  parameter Modelica.Units.SI.Temperature THeaTrh = 273.15+15 "Heating threshold for summer mode";

  parameter Integer sumTimSta= (31+28+31+30) * 86400 "Summer start time, default 01.05";
  parameter Integer sumTimEnd= (31+28+31+30+31+30+31+31+30) * 86400 "Summer end time, default 01.10";
  parameter Modelica.Units.SI.Time delTim=10800 "Delay time to start winter mode";

  BaseClasses.SummerTimeConstraint notSumMod(
    sumTimSta=sumTimSta,
    sumTimEnd=sumTimEnd,
    delTim=delTim)                           "=false if summer mode is present"
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
  Modelica.Blocks.Logical.Not not1 "Not"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Logical.Timer timer
    annotation (Placement(transformation(extent={{2,-10},{22,10}})));
  Modelica.Blocks.Logical.Hysteresis hysSum(
    uLow=THeaTrh - 0.1,
    final uHigh=THeaTrh + 0.1,
    final pre_y_start=false) "Summer mode"
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Blocks.Logical.Not not2 "Not"
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));
equation

  connect(hysSum.u, TOda)
    annotation (Line(points={{-68,0},{-120,0}}, color={0,0,127}));
  connect(not1.u, hysSum.y)
    annotation (Line(points={{-32,0},{-45,0}}, color={255,0,255}));
  connect(not1.y, timer.u)
    annotation (Line(points={{-9,0},{0,0}}, color={255,0,255}));
  connect(notSumMod.u, timer.y)
    annotation (Line(points={{36,0},{23,0}}, color={0,0,127}));
  connect(not2.u, notSumMod.y)
    annotation (Line(points={{66,0},{59,0}}, color={255,0,255}));
  connect(not2.y, sumMod)
    annotation (Line(points={{89,0},{110,0}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>This model implements a summer mode control strategy based on both 
outdoor temperature threshold and calendar dates. 
The summer mode is activated when either:</p>
<ul>
  <li>The outdoor temperature exceeds the heating threshold temperature (with hysteresis)</li>
  <li>The current time falls between the defined summer start and end dates</li>
</ul>
</html>"));
end HeatingThresholdAndDateBased;
