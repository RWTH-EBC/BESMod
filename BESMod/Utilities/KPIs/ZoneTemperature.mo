within BESMod.Utilities.KPIs;
model ZoneTemperature "Model for temperature KPIs relevant for a single zone"
  parameter Modelica.Units.SI.TemperatureDifference dTComfort=2
    "Temperature difference to room set temperature at which the comfort is still acceptable";
  parameter Modelica.Units.SI.Temperature TSetZone_nominal "Nominal room set temperature";
  parameter Boolean with_heating=true "=false to disable heating comfort calculation";
  parameter Boolean with_cooling=true "=false to disable cooling comfort calculation";

  Utilities.KPIs.ComfortCalculator comHea(TComBou=TSetZone_nominal - dTComfort,
      for_heating=true) if with_heating
                        "Comfort calculator room temperature for heating"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Utilities.KPIs.ComfortCalculator comCool(TComBou=TSetZone_nominal + dTComfort,
      for_heating=false) if with_cooling
                         "Comfort calculator room temperature for cooling"
    annotation (Placement(transformation(extent={{-60,-58},{-40,-38}})));
  Utilities.KPIs.RoomControlCalculator calCtrl(final for_heating=true, final
      dTComBou=0) "Calculate room control quality"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Interfaces.RealOutput dTComHea "K*s discomfort"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput dTComCoo "K*s discomfort"
    annotation (Placement(transformation(extent={{100,-58},{120,-38}})));
  Modelica.Blocks.Interfaces.RealOutput dTCtrl "K*s control deviation"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TZone(unit="K")
    "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput TZoneSet(unit="K")
    "Zone set temperature"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
equation
  connect(comHea.dTComSec, dTComHea)
    annotation (Line(points={{-39,50},{110,50}}, color={0,0,127}));
  connect(comCool.dTComSec, dTComCoo)
    annotation (Line(points={{-39,-48},{110,-48}}, color={0,0,127}));
  connect(calCtrl.dTComSec, dTCtrl)
    annotation (Line(points={{-39,0},{110,0}}, color={0,0,127}));
  connect(calCtrl.TZone, TZone)
    annotation (Line(points={{-62,0},{-70,0},{-70,50},{-120,50}},
                                                color={0,0,127}));
  connect(TZoneSet, calCtrl.TZoneSet) annotation (Line(points={{-120,-50},{-88,
          -50},{-88,-6},{-62,-6}},
                              color={0,0,127}));
  connect(comCool.TZone, TZone) annotation (Line(points={{-62,-48},{-78,-48},{
          -78,50},{-120,50}},
                        color={0,0,127}));
  connect(comHea.TZone, TZone) annotation (Line(points={{-62,50},{-120,50}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
   Rectangle(
   extent={{-100,100},{102,-100}},
   lineColor={0,0,0},
   fillColor={215,215,215},
   fillPattern=FillPattern.Solid),
  Text(
   extent={{-98,-74},{106,-170}},
   lineColor={0,0,0},
   textString="%name%")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><span style=\"font-family: Courier New;\">In DIN EN 15251, all temperatures below 22 &deg;C - 2 K count as discomfort. Hence the default value. If your room set temperature is lower, consider using smaller values.</span></p>
</html>"));
end ZoneTemperature;
