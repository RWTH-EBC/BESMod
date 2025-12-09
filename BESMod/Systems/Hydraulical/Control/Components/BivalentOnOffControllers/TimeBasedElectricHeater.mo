within BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers;
model TimeBasedElectricHeater
  "Const. hysteresis and time-based auxilliar heater control"
  extends
    BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController;

  parameter Modelica.Units.SI.Time dtEleHea(displayUnit="min")=1800
    "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period";
  parameter Real addSetDelTimEleHea=1
    "Each time electric heater time passes, the output of the electric heater is increased by this amount in percentage. Maximum and default is 100 (on-off hr)%";
  parameter Boolean electricHeaterOnlyBelowBivalenceTemperature=false
    "=true to only allow electric heater usage below bivalence temperature";
  parameter Modelica.Units.SI.Temperature TBiv=273.15 "Bivalence temperature"
    annotation(Dialog(enable=electricHeaterOnlyBelowBivalenceTemperature));

  BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.Utilities.StorageHysteresis
    hysSto(final bandwidth=dTHys, final pre_y_start=true) "Storage hysteresis"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.Utilities.TriggerTime
    trigTime "Trigger once the hysteresis is violated"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Blocks.Sources.RealExpression reaExp(y=min(floor((time - trigTime.y)/
        dtEleHea)*addSetDelTimEleHea, 1))
    "Calculate if electric heater time has elapsed"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Logical.GreaterThreshold greThr(threshold=Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Modelica.Blocks.Logical.Switch swiOn "Switch on or off"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.Constant constOff(final k=0)
    "Turn auxilliar heater off"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Logical.OnOffController hysAuxHea(bandwidth=dTHys/2,
      pre_y_start=true)
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Math.Add add1(k1=-1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-50})));
  Modelica.Blocks.Sources.Constant constdTHys(final k=dTHys/4)
    "Set auxilliar heater hysteresis"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Logical.And andBelBiv
    "Check if should be turned on and is below bivalence temperature"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.BooleanConstant conBelBiv(final k=true)
    if not electricHeaterOnlyBelowBivalenceTemperature
    "Disable below bivalence point check"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Logical.LessEqualThreshold belBiv(final threshold=TBiv)
    if electricHeaterOnlyBelowBivalenceTemperature
    "Is below bivalence temperature"
    annotation (Placement(transformation(extent={{12,60},{32,80}})));
equation
  connect(TStoTop, hysSto.T_top) annotation (Line(points={{-120,60},{-92,60},{
          -92,42},{-72,42},{-72,50},{-62,50}},
                         color={0,0,127}));
  connect(TSupSet, hysSto.T_set) annotation (Line(points={{0,-118},{0,-94},{-56,
          -94},{-56,34},{-70,34},{-70,58},{-62,58}},
                              color={0,0,127}));
  connect(hysSto.y, priGenOn) annotation (Line(points={{-39,50},{94,50},{94,60},
          {110,60}},
                color={255,0,255}));
  connect(greThr.y, secGenOn)
    annotation (Line(points={{81,-30},{96,-30},{96,-60},{110,-60}},
                                                    color={255,0,255}));
  connect(constOff.y, swiOn.u3) annotation (Line(points={{1,-70},{18,-70},{18,
          -38}},         color={0,0,127}));
  connect(swiOn.y, ySecGenSet) annotation (Line(points={{41,-30},{52,-30},{52,
          -80},{110,-80}},
                      color={0,0,127}));
  connect(swiOn.y, greThr.u) annotation (Line(points={{41,-30},{58,-30}},
                       color={0,0,127}));
  connect(reaExp.y, swiOn.u1) annotation (Line(points={{11,0},{18,0},{18,-22}},
                         color={0,0,127}));
  connect(TStoTop, hysSto.T_bot) annotation (Line(points={{-120,60},{-92,60},{
          -92,42},{-72,42},{-72,32},{-62,32},{-62,42}},
                         color={0,0,127}));
  connect(TStoTop, hysAuxHea.u) annotation (Line(points={{-120,60},{-92,60},{
          -92,-16},{-82,-16}},
                      color={0,0,127}));
  connect(constdTHys.y, add1.u1) annotation (Line(points={{-79,-90},{-76,-90},{
          -76,-62}},                    color={0,0,127}));
  connect(add1.y, hysAuxHea.reference)
    annotation (Line(points={{-70,-39},{-70,-28},{-90,-28},{-90,-4},{-82,-4}},
                                                               color={0,0,127}));
  connect(TSupSet, add1.u2) annotation (Line(points={{0,-118},{0,-94},{-56,-94},
          {-56,-70},{-64,-70},{-64,-62}},
                                        color={0,0,127}));
  connect(andBelBiv.y, trigTime.u) annotation (Line(points={{-19,-30},{-16,-30},
          {-16,-20},{-12,-20}}, color={255,0,255}));
  connect(andBelBiv.u2, hysAuxHea.y) annotation (Line(points={{-42,-38},{-54,
          -38},{-54,-10},{-59,-10}}, color={255,0,255}));
  connect(andBelBiv.y, swiOn.u2) annotation (Line(points={{-19,-30},{-14,-30},{
          -14,-34},{16,-34},{16,-30},{18,-30}}, color={255,0,255}));
  connect(belBiv.u, TOda)
    annotation (Line(points={{10,70},{0,70},{0,120}}, color={0,0,127}));
  connect(conBelBiv.y, andBelBiv.u1) annotation (Line(
      points={{-19,10},{-16,10},{-16,-8},{-46,-8},{-46,-30},{-42,-30}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(andBelBiv.u1, belBiv.y) annotation (Line(
      points={{-42,-30},{-46,-30},{-46,28},{40,28},{40,70},{33,70}},
      color={255,0,255},
      pattern=LinePattern.Dash));
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
end TimeBasedElectricHeater;
