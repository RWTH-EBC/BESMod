within BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers;
model FloatingHysteresis
  "Based on the floating hysteresis approach"
  extends BaseClasses.PartialOnOffController;

  parameter Modelica.Units.SI.TemperatureDifference Hysteresis_max=dTHys
    "Maximum hysteresis";
  parameter Modelica.Units.SI.TemperatureDifference Hysteresis_min=10
    "Minimum hysteresis";
  parameter Modelica.Units.SI.Time time_factor=20
    "The time which should be spent to have the floating hysteresis equal to the average of maximum and minimum hysteresis.";
  parameter Modelica.Units.SI.Time dtEleHea=20*60
    "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period";

  /******************************* Variables *******************************/

  Modelica.Units.SI.Time t1(start=0) "Helper variable for hr algorithm";
  Modelica.Units.SI.TemperatureDifference Hysteresis_floating=Hysteresis_min +
      (Hysteresis_max - Hysteresis_min)/(1 + (t1/time_factor));

algorithm

   // For initialisation: activate both systems
   //when time > 1 then
   //  HP_On := true;
   //  Auxilliar_Heater_On :=true;
   //end when;

   // When upper temperature of storage tank is lower than lower hysteresis value, activate hp
  when TStoTop < TSupSet - Hysteresis_floating/2 then
    priGenOn := true;
     t1 :=time; // Start activation counter
   end when;
   // When second / lower temperature of storage tank is higher than upper hysteresis, deactivate hp
  when TStoBot > TSupSet + Hysteresis_floating/2 then
    priGenOn := false;
    secGenOn := false;
    ySecGenSet := 0;
   end when;

   // Activate hr in case temperature is below lower hysteresis and critical time period is passed
  when (TStoTop < TSupSet - Hysteresis_floating/2) and time > (t1 + dtEleHea)
       and priGenOn then
    secGenOn := true;
    ySecGenSet := 1;
   end when;

  annotation (Icon(graphics={
                           Line(
            points={{-50,48},{80,48}},
            thickness=0.5),Line(
            points={{-10,53},{-20,48},{-10,43}},
            thickness=0.5),Line(
            points={{25,8},{30,19},{35,8}},
            thickness=0.5),Line(
            points={{30,48},{30,-32}},
            thickness=0.5),Line(
            points={{-10,-27},{0,-32},{-10,-37}},
            thickness=0.5), Line(
            points={{-80,-32},{30,-32}},
            thickness=0.5),Line(
            points={{-50,48},{-50,-32}},
            thickness=0.5),Line(
            points={{-55,18},{-50,8},{-44,18}},
            thickness=0.5),Text(
            extent={{-99,40},{-70,56}},
            lineColor={160,160,164},
            textString="true"),Text(
            extent={{-98,-49},{-66,-35}},
            lineColor={160,160,164},
            textString="false"),           Line(points={{-64,86},{-65,-43}},
          color={192,192,192}),Line(points={{-69,48},{-60,48}}, color={160,
          160,164}),Polygon(
            points={{90,-32},{68,-24},{68,-40},{90,-32}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
                               Line(points={{-90,-32},{82,-32}}, color={192,
          192,192}),            Text(
            extent={{19,-49},{44,-32}},
            lineColor={0,0,0},
            textString="uHigh"),Text(
            extent={{-63,-50},{-38,-33}},
            lineColor={0,0,0},
            textString="uLow"),
                    Polygon(
            points={{11,0},{-11,8},{-11,-8},{11,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
          origin={-65,84},
          rotation=90),         Text(
            extent={{-87,-84},{84,-54}},
            lineColor={0,0,0},
          textString="uLow, uHigh=f(h_max, h_min, time)")}), Documentation(info="<html>
<p>This model implements a bivalent on/off controller with a floating hysteresis approach.
</p>
<p>The hysteresis value floats between a maximum and minimum value based on the operation time. 
The controller manages two heat generators (primary and secondary) based on storage tank temperatures 
relative to the supply temperature setpoint and the floating hysteresis band.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>Hysteresis_max</code>: Maximum hysteresis temperature difference (default: dTHys)</li>
  <li><code>Hysteresis_min</code>: Minimum hysteresis temperature difference (default: 10K)</li>
  <li><code>time_factor</code>: Time constant that influences how quickly the floating hysteresis reaches its average value (default: 20s)</li>
  <li><code>dtEleHea</code>: Time delay before activating secondary generator when conditions are met (default: 1200s)</li>
</ul>

<h4>Control Logic</h4>
<ul>
  <li>Primary generator activates when upper storage temperature falls below (TSupSet - Hysteresis_floating/2)</li>
  <li>Both generators deactivate when lower storage temperature exceeds (TSupSet + Hysteresis_floating/2)</li>
  <li>Secondary generator activates if temperature remains low for longer than dtEleHea while primary generator is running</li>
</ul>
</html>"));
end FloatingHysteresis;
