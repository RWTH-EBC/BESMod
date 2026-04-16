within BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers;
model TimeBasedElectricHeaterThreeStep
  "Const. hysteresis and time-based auxilliar heater control"
  extends
    BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController;

  parameter Modelica.Units.SI.Time dtEleHea(displayUnit="min")=1800
    "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period";
  parameter Real addSetDelTimEleHea=1
    "Each time electric heater time passes, the output of the electric heater is increased by this amount in percentage. Maximum and default is 100 (on-off hr)%";

  parameter Modelica.Units.SI.Frequency stepRate = addSetDelTimEleHea/dtEleHea
     "Frequency at which the electric heater is increased";

  BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.Utilities.StorageHysteresis
    hysSto(final bandwidth=dTHys, final pre_y_start=true) "Storage hysteresis"
    annotation (Placement(transformation(extent={{-58,18},{-18,58}})));
  BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.Utilities.TriggerTime
    trigTime "Trigger once the hysteresis is violated"
    annotation (Placement(transformation(extent={{-32,-88},{-12,-68}})));
  Modelica.Blocks.Sources.RealExpression addRate(y=stepRate)
    "Calculate if electric heater time has elapsed"
    annotation (Placement(transformation(extent={{0,-84},{20,-64}})));
  Modelica.Blocks.Logical.GreaterThreshold greThr(threshold=Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{72,-8},{88,8}})));

  Modelica.Blocks.Logical.Switch swiOn "Switch on or off"
    annotation (Placement(transformation(extent={{34,-88},{50,-72}})));
  Modelica.Blocks.Logical.OnOffController hysAuxHea(bandwidth=dTHys/2,
      pre_y_start=true)
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-62,-70},{-42,-50}})));
  Modelica.Blocks.Math.Add add1(k1=-1)
    annotation (Placement(transformation(extent={{-9,-9},{9,9}},
        rotation=90,
        origin={-71,-87})));
  Modelica.Blocks.Sources.Constant constdTHys(final k=dTHys/4)
    "Set auxilliar heater hysteresis"
    annotation (Placement(transformation(extent={{-98,-118},{-88,-108}})));
  Modelica.Blocks.Sources.RealExpression addRate1(y=-stepRate)
    "Calculate if electric heater time has elapsed"
    annotation (Placement(transformation(extent={{0,-102},{20,-82}})));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(
    k=1/addSetDelTimEleHea,
    outMax=1/addSetDelTimEleHea,
    outMin=0)
    annotation (Placement(transformation(extent={{-26,-40},{-6,-20}})));
  Modelica.Blocks.Math.RealToInteger realToInteger
    annotation (Placement(transformation(extent={{8,-40},{28,-20}})));
  Modelica.Blocks.Math.IntegerToReal integerToReal
    annotation (Placement(transformation(extent={{38,-40},{58,-20}})));
  Modelica.Blocks.Math.Gain gain(k=addSetDelTimEleHea)
    annotation (Placement(transformation(extent={{68,-36},{80,-24}})));
equation
  connect(TStoTop, hysSto.T_top) annotation (Line(points={{-120,60},{-86,60},{-86,
          38},{-62,38}}, color={0,0,127}));
  connect(TSupSet, hysSto.T_set) annotation (Line(points={{0,-118},{0,-104},{-86,
          -104},{-86,-74},{-80,-74},{-80,54},{-62,54}},
                              color={0,0,127}));
  connect(hysSto.y, priGenOn) annotation (Line(points={{-16,38},{30,38},{30,60},{110,
          60}}, color={255,0,255}));
  connect(greThr.y, secGenOn)
    annotation (Line(points={{88.8,0},{96,0},{96,-60},{110,-60}},
                                                    color={255,0,255}));
  connect(addRate.y, swiOn.u1) annotation (Line(points={{21,-74},{22,-73.6},{
          32.4,-73.6}}, color={0,0,127}));
  connect(TStoTop, hysSto.T_bot) annotation (Line(points={{-120,60},{-92,60},{-92,
          22},{-62,22}}, color={0,0,127}));
  connect(TStoTop, hysAuxHea.u) annotation (Line(points={{-120,60},{-92,60},{-92,-66},
          {-64,-66}}, color={0,0,127}));
  connect(constdTHys.y, add1.u1) annotation (Line(points={{-87.5,-113},{-76,-113},
          {-76,-97.8},{-76.4,-97.8}},   color={0,0,127}));
  connect(add1.y, hysAuxHea.reference)
    annotation (Line(points={{-71,-77.1},{-71,-54},{-64,-54}}, color={0,0,127}));
  connect(TSupSet, add1.u2) annotation (Line(points={{0,-118},{0,-104},{-66,-104},
          {-66,-97.8},{-65.6,-97.8}},   color={0,0,127}));
  connect(hysAuxHea.y, trigTime.u) annotation (Line(points={{-41,-60},{-38,-60},{-38,
          -78},{-34,-78}}, color={255,0,255}));
  connect(hysAuxHea.y, swiOn.u2) annotation (Line(points={{-41,-60},{-4,-60},{
          -4,-80},{32.4,-80}},
                       color={255,0,255}));
  connect(addRate1.y, swiOn.u3) annotation (Line(points={{21,-92},{22,-92},{22,
          -86},{32.4,-86},{32.4,-86.4}}, color={0,0,127}));
  connect(swiOn.y, limIntegrator.u) annotation (Line(points={{50.8,-80},{54,-80},
          {54,-50},{-38,-50},{-38,-30},{-28,-30}}, color={0,0,127}));
  connect(limIntegrator.y, realToInteger.u)
    annotation (Line(points={{-5,-30},{6,-30}}, color={0,0,127}));
  connect(realToInteger.y, integerToReal.u)
    annotation (Line(points={{29,-30},{36,-30}}, color={255,127,0}));
  connect(integerToReal.y, gain.u)
    annotation (Line(points={{59,-30},{66.8,-30}}, color={0,0,127}));
  connect(gain.y, greThr.u) annotation (Line(points={{80.6,-30},{84,-30},{84,
          -12},{64,-12},{64,0},{70.4,0}}, color={0,0,127}));
  connect(gain.y, ySecGenSet) annotation (Line(points={{80.6,-30},{94,-30},{94,
          -80},{110,-80}}, color={0,0,127}));
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
end TimeBasedElectricHeaterThreeStep;
