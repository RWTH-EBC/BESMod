within BESMod.Systems.Hydraulical.Control.Components.OnOffController;
model DegreeMinuteController
  "OnOff controller based on degree minute approach"
  extends BaseClasses.PartialOnOffController;

  parameter Real DegreeMinute_HP_on(unit="K.min")=-60 "Degree minute when HP is turned on";
  parameter Real DegreeMinute_HP_off(unit="K.min")=0 "Degree minute when HP is turned off";
  parameter Real DegreeMinute_AuxHeater_on(unit="K.min")=-600 "Degree minute when auxilliar heater is turned on";
  parameter Real DegreeMinuteReset(unit="K.min")=300 "Degree minute when the value is reset. Value based on additional paper, to avoid errors in summer periods";
  parameter Modelica.Units.SI.TemperatureDifference delta_T_AuxHeater_off=1
    "Temperature difference when to turn off the auxilliar heater";
  parameter Modelica.Units.SI.TemperatureDifference delta_T_reset=10
    "Temperature difference when to reset the sum to 0";

  Real DegreeMinute(start=0) "Current degree minute value";
  Modelica.Units.SI.TemperatureDifference delta_T=T_Top - T_Set;

algorithm
  when DegreeMinute < DegreeMinute_HP_on then
    HP_On := true;
  end when;

  when DegreeMinute > DegreeMinute_HP_off then
    HP_On := false;
  end when;

  when DegreeMinute < DegreeMinute_AuxHeater_on then
    Auxilliar_Heater_On := true;
    Auxilliar_Heater_set := 1;
  end when;

  when delta_T > delta_T_AuxHeater_off then
    Auxilliar_Heater_On := false;
    Auxilliar_Heater_set := 0;
  end when;

equation
  // TODO: Check why the simple hys wont work?!
  //HP_On = (not pre(HP_On) and DegreeMinute > DegreeMinute_HP_on) or (pre(HP_On) and DegreeMinute < DegreeMinute_HP_off);
  //Auxilliar_Heater_On = (not pre(Auxilliar_Heater_On) and DegreeMinute > DegreeMinute_AuxHeater_on) or (pre(Auxilliar_Heater_On) and delta_T < delta_T_AuxHeater_off);
  der(DegreeMinute) = delta_T /60;
  when (delta_T > delta_T_reset) then
    reinit(DegreeMinute, 0);
  elsewhen (DegreeMinute > DegreeMinuteReset) then
    reinit(DegreeMinute, 0);
  end when;
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
end DegreeMinuteController;
