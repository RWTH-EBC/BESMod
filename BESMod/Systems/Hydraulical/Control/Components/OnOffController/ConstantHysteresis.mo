within BESMod.Systems.Hydraulical.Control.Components.OnOffController;
model ConstantHysteresis
  "On-Off controller with a constant hysteresis"
  extends BaseClasses.PartialOnOffController;

  parameter Modelica.Units.SI.TemperatureDifference Hysteresis=10;
  parameter Modelica.Units.SI.Time dt_hr=20*60
    "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period";

  /******************************* Variables *******************************/

  Modelica.Units.SI.Time t1(start=0) "Helper variable for hr algorithm";

algorithm

   // For initialisation: activate both systems
   //when time > 1 then
   //  HP_On := true;
   //  Auxilliar_Heater_On :=true;
   //end when;

   // When upper temperature of storage tank is lower than lower hysteresis value, activate hp
   when T_Top < T_Set - Hysteresis/2 then
     HP_On := true;
     t1 :=time; // Start activation counter
   end when;
   // When second / lower temperature of storage tank is higher than upper hysteresis, deactivate hp
   when T_bot > T_Set + Hysteresis/2 then
     HP_On := false;
     Auxilliar_Heater_On := false;
     Auxilliar_Heater_set := 0;
   end when;

   // Activate hr in case temperature is below lower hysteresis and critical time period is passed
   when (T_Top < T_Set - Hysteresis/2) and time > (t1 + dt_hr) and HP_On then
     Auxilliar_Heater_On :=true;
     Auxilliar_Heater_set := 1;
   end when;

  annotation (Icon(graphics={     Polygon(
            points={{-65,89},{-73,67},{-57,67},{-65,89}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-65,67},{-65,-81}},
          color={192,192,192}),Line(points={{-90,-70},{82,-70}}, color={192,
          192,192}),Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
                            Text(
            extent={{-65,93},{-12,75}},
            lineColor={160,160,164},
            textString="y"),Line(
            points={{-80,-70},{30,-70}},
            thickness=0.5),Line(
            points={{-50,10},{80,10}},
            thickness=0.5),Line(
            points={{-50,10},{-50,-70}},
            thickness=0.5),Line(
            points={{30,10},{30,-70}},
            thickness=0.5),Line(
            points={{-10,-65},{0,-70},{-10,-75}},
            thickness=0.5),Line(
            points={{-10,15},{-20,10},{-10,5}},
            thickness=0.5),Line(
            points={{-55,-20},{-50,-30},{-44,-20}},
            thickness=0.5),Line(
            points={{25,-30},{30,-19},{35,-30}},
            thickness=0.5),Text(
            extent={{-99,2},{-70,18}},
            lineColor={160,160,164},
            textString="true"),Text(
            extent={{-98,-87},{-66,-73}},
            lineColor={160,160,164},
            textString="false"),Text(
            extent={{19,-87},{44,-70}},
            lineColor={0,0,0},
            textString="uHigh"),Text(
            extent={{-63,-88},{-38,-71}},
            lineColor={0,0,0},
            textString="uLow"),Line(points={{-69,10},{-60,10}}, color={160,
          160,164})}));
end ConstantHysteresis;
