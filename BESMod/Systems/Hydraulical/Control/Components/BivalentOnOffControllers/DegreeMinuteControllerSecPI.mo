within BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers;
model DegreeMinuteControllerSecPI
  "Based on degree minute approach with a PI controled secondary Heater"
  extends BaseClasses.PartialOnOffController;

  parameter Real DegreeMinute_HP_on(unit="K.min")=-60 "Degree minute when HP is turned on";
  parameter Real DegreeMinute_HP_off(unit="K.min")=0 "Degree minute when HP is turned off";
  parameter Real DegreeMinute_AuxHeater_on(unit="K.min")=-600 "Degree minute when auxilliar heater is turned on";
  parameter Real DegreeMinuteReset(unit="K.min")=300 "Degree minute when the value is reset. Value based on additional paper, to avoid errors in summer periods";
  parameter Modelica.Units.SI.TemperatureDifference delta_T_AuxHeater_off=10
    "Temperature difference when to turn off the auxilliar heater";
  parameter Modelica.Units.SI.TemperatureDifference delta_T_AuxHeater_max_on=-1
    "Max temperature difference when to turn on the auxilliar heater";
  parameter Modelica.Units.SI.TemperatureDifference delta_T_reset=10
    "Temperature difference when to reset the sum to 0";

  Real DegreeMinute(start=0) "Current degree minute value";
  Modelica.Units.SI.TemperatureDifference delta_T=TStoTop - TSupSet;

  RelativeSpeedController.PID pID(P=0.1, timeDer=0)
    annotation (Placement(transformation(extent={{-18,-16},{2,4}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=secGenOn)
    annotation (Placement(transformation(extent={{-54,-68},{-34,-48}})));
algorithm
  when DegreeMinute < DegreeMinute_HP_on then
    priGenOn := true;
  end when;

  when DegreeMinute > DegreeMinute_HP_off then
    priGenOn := false;
  end when;

  when DegreeMinute < DegreeMinute_AuxHeater_on and delta_T < delta_T_AuxHeater_max_on then
    secGenOn := true;
  end when;

  when DegreeMinute > 0 or delta_T > delta_T_AuxHeater_off then
    secGenOn := false;
  end when;

equation
  // TODO: Check why the simple hys wont work?!
  //HP_On = (not pre(HP_On) and DegreeMinute > DegreeMinute_HP_on) or (pre(HP_On) and DegreeMinute < DegreeMinute_HP_off);
  //Auxilliar_Heater_On = (not pre(Auxilliar_Heater_On) and DegreeMinute > DegreeMinute_AuxHeater_on) or (pre(Auxilliar_Heater_On) and delta_T < delta_T_AuxHeater_off);
  if HeaMod then
    der(DegreeMinute) = delta_T /60;
  else
    der(DegreeMinute) = 0;
  end if;
  when (delta_T > delta_T_reset) then
    reinit(DegreeMinute, 0);
  elsewhen (DegreeMinute > DegreeMinuteReset) then
    reinit(DegreeMinute, 0);
  end when;
  connect(TStoTop, pID.TMea) annotation (Line(points={{-120,60},{-28,60},{-28,-28},
          {-8,-28},{-8,-18}}, color={0,0,127}));
  connect(TSupSet, pID.TSet) annotation (Line(points={{0,-118},{0,-20},{10,-20},
          {10,8},{-20,8},{-20,0}}, color={0,0,127}));
  connect(booleanExpression.y, pID.setOn) annotation (Line(points={{-33,-58},{-30,
          -58},{-30,-6},{-20,-6}}, color={255,0,255}));
  connect(booleanExpression.y, pID.isOn) annotation (Line(points={{-33,-58},{-30,
          -58},{-30,-20},{-22,-20},{-22,-26},{-14,-26},{-14,-18}}, color={255,0,
          255}));
  connect(pID.ySet, ySecGenSet) annotation (Line(points={{3,-6},{96,-6},{96,-80},
          {110,-80}}, color={0,0,127}));
  annotation (Icon(graphics={Text(
          extent={{-44,58},{40,-60}},
          lineColor={0,0,0},
          textString="°C
_______

 minute")}), Documentation(info="<html>
<p style=\"margin-left: 30px;\">The method is based on the following paper: https://www.sciencedirect.com/science/article/abs/pii/S037877881300282X</p>
<p><br>&bull; Turn on the heat pump when the sum is lower than &minus;60 degree&ndash;minute.</p>
<p>&bull; Turn off the heat pump when the sum goes back to 0 degree&ndash;minute.</p>
<p>&bull; Turn on the electrical auxiliary heater when the sum is lower than &minus;600 degree&ndash;minute.</p>
<p>&bull; Turn off the electrical auxiliary heater when the supply temperature is 1 K higher than the required temperature.</p>
<p>&bull; Reset the sum to zero whenever the supply temperature is 10 K higher than the required temperature.</p>
</html>"));
end DegreeMinuteControllerSecPI;
