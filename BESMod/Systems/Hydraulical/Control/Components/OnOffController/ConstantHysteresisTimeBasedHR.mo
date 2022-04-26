within BESMod.Systems.Hydraulical.Control.Components.OnOffController;
model ConstantHysteresisTimeBasedHR
  "On-Off controller with a constant hysteresis for a time-based hr control"
  extends
    BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController;

  parameter Modelica.SIunits.TemperatureDifference Hysteresis = 10;
  parameter Modelica.SIunits.Time dt_hr  "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period";
  parameter Real addSet_dt_hr=1 "Each time dt_hr passes, the output of the heating rod is increased by this amount in percentage. Maximum and default is 100 (on-off hr)%";

  BESMod.Systems.Hydraulical.Control.Components.OnOffController.StorageHysteresis
    storageHysteresis(final bandwidth=Hysteresis, final pre_y_start=true)
    annotation (Placement(transformation(extent={{-58,18},{-18,58}})));
  BESMod.Systems.Hydraulical.Control.Components.OnOffController.Utilities.TriggerTime
    triggerTime
    annotation (Placement(transformation(extent={{-32,-88},{-12,-68}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=min(floor((time -
        triggerTime.y)/dt_hr)*addSet_dt_hr, 1))
    annotation (Placement(transformation(extent={{6,-70},{26,-50}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{70,-68},{86,-52}})));

  Modelica.Blocks.Logical.Switch         switch1
    annotation (Placement(transformation(extent={{34,-86},{48,-72}})));
  Modelica.Blocks.Sources.Constant       const(final k=0)
    annotation (Placement(transformation(extent={{14,-98},{24,-88}})));
  Modelica.Blocks.Logical.OnOffController AuxilliarHeaterHys(bandwidth=
        Hysteresis/2, pre_y_start=true)
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-62,-70},{-42,-50}})));
  Modelica.Blocks.Math.Add               add1(k1=-1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-69,-95})));
  Modelica.Blocks.Sources.Constant       const2(final k=Hysteresis/4)
    annotation (Placement(transformation(extent={{-98,-118},{-88,-108}})));
equation
  connect(T_Top, storageHysteresis.T_top) annotation (Line(points={{-120,60},{
          -86,60},{-86,38},{-62,38}},
                                  color={0,0,127}));
  connect(T_Set, storageHysteresis.T_set) annotation (Line(points={{0,-118},{0,
          -20},{-80,-20},{-80,54},{-62,54}},
                                        color={0,0,127}));
  connect(storageHysteresis.y, HP_On) annotation (Line(points={{-16,38},{30,38},
          {30,60},{110,60}}, color={255,0,255}));
  connect(greaterThreshold.y, Auxilliar_Heater_On)
    annotation (Line(points={{86.8,-60},{110,-60}},
                                                  color={255,0,255}));
  connect(const.y, switch1.u3) annotation (Line(points={{24.5,-93},{28,-93},{28,
          -84.6},{32.6,-84.6}}, color={0,0,127}));
  connect(switch1.y, Auxilliar_Heater_set) annotation (Line(points={{48.7,-79},
          {70,-79},{70,-80},{110,-80}}, color={0,0,127}));
  connect(switch1.y, greaterThreshold.u) annotation (Line(points={{48.7,-79},{
          56,-79},{56,-60},{68.4,-60}}, color={0,0,127}));
  connect(realExpression.y, switch1.u1) annotation (Line(points={{27,-60},{30,
          -60},{30,-73.4},{32.6,-73.4}}, color={0,0,127}));
  connect(T_Top, storageHysteresis.T_bot) annotation (Line(points={{-120,60},{
          -92,60},{-92,22},{-62,22}}, color={0,0,127}));
  connect(T_Top, AuxilliarHeaterHys.u) annotation (Line(points={{-120,60},{-92,
          60},{-92,-66},{-64,-66}}, color={0,0,127}));
  connect(const2.y, add1.u1) annotation (Line(points={{-87.5,-113},{-74,-113},{
          -74,-103.4},{-73.2,-103.4}}, color={0,0,127}));
  connect(add1.y, AuxilliarHeaterHys.reference) annotation (Line(points={{-69,
          -87.3},{-69,-54},{-64,-54}}, color={0,0,127}));
  connect(T_Set, add1.u2) annotation (Line(points={{0,-118},{0,-104},{-20,-104},
          {-20,-103.4},{-64.8,-103.4}}, color={0,0,127}));
  connect(AuxilliarHeaterHys.y, triggerTime.u) annotation (Line(points={{-41,-60},
          {-38,-60},{-38,-78},{-34,-78}},      color={255,0,255}));
  connect(AuxilliarHeaterHys.y, switch1.u2) annotation (Line(points={{-41,-60},
          {2,-60},{2,-79},{32.6,-79}},                     color={255,0,255}));
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
end ConstantHysteresisTimeBasedHR;
