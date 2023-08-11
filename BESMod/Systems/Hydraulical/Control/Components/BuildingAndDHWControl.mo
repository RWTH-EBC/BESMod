within BESMod.Systems.Hydraulical.Control.Components;
model BuildingAndDHWControl
  "Control model to control both building and DHW systems"

  parameter Integer nZones "Number of heated zones";
  parameter Modelica.Units.SI.Temperature TSup_nominal
    "Nominal supply temperature";
  parameter Modelica.Units.SI.Temperature TRet_nominal
    "Nominal supply temperature";
  parameter Modelica.Units.SI.Temperature TOda_nominal
    "Nominal outdoor air temperature";
  parameter Modelica.Units.SI.Temperature TSetDHW_nominal
    "Nominal DHW temperature";
  parameter Real nHeaTra "Exponent of heat transfer system";
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrHeaCurTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Heating curve supervisory control";
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Supervisory control approach for DHW supply temperature ";


  replaceable model DHWHysteresis =
      BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.ConstantHysteresisTimeBasedHeatingRod
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController
    "Hysteresis for DHW system" annotation (choicesAllMatching=true);
  replaceable model BuildingHysteresis =
      BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.ConstantHysteresisTimeBasedHeatingRod
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController
    "Hysteresis for building" annotation (choicesAllMatching=true);
  replaceable model DHWSetTemperature =
      BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      "DHW set temperture module" annotation (choicesAllMatching=true);


  DHWHysteresis hysDHW
    "Hysteresis for DHW system" annotation (Placement(
        transformation(extent={{62,62},{78,78}})));
  BuildingHysteresis hysBui
    "Hysteresis for building" annotation (Placement(
        transformation(extent={{42,-78},{58,-62}})));
  DHWSetTemperature TSetDHW "DHW set temperature module" annotation (
      Placement(transformation(extent={{-78,82},{-62,98}})));

  BESMod.Systems.Hydraulical.Control.Components.HeatingCurve heaCur(
    final TSup_nominal=TSup_nominal,
    final TRet_nominal=TRet_nominal,
    final TOda_nominal=TOda_nominal,
    final nHeaTra=nHeaTra)                                   "Heating curve"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Blocks.Logical.Or priGenOn "Turn on primary generation device"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={170,-70})));
  Modelica.Blocks.MathBoolean.Or orDHW(nu=3) "If any is true, dhw is activated"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,70})));
  BESMod.Utilities.SupervisoryControl.SupervisoryControl supCtrDHW(ctrlType=supCtrDHWTyp)
                           "Supervisory control of DHW"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Math.MinMax minMax(nu=nZones)
    annotation (Placement(transformation(extent={{-80,-76},{-60,-56}})));
  Modelica.Blocks.Interfaces.RealInput TOda(unit="K", displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TDHWSet(unit="K", displayUnit="degC")
    "DHW supply set temperature"
    annotation (Placement(transformation(extent={{300,70},{320,90}})));
  Modelica.Blocks.Math.MinMax maxSecHeaGen(nu=3)
    "Maximal value suggested for secondary heat generator" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-34})));
  Interfaces.DistributionControlBus sigBusDistr
    "Necessary to control DHW temperatures"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Interfaces.SystemControlBus sigBusHyd annotation (Placement(transformation(
          extent={{80,86},{120,120}}), iconTransformation(extent={{-48,84},{-8,
            118}})));
  Modelica.Blocks.Interfaces.BooleanOutput priGren
    "=true to activate primary generation device"
    annotation (Placement(transformation(extent={{300,-120},{320,-100}})));
  Modelica.Blocks.MathBoolean.Or secGenOn(nu=3)
    "If any is true, secondary heater is activated" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-90})));
  Modelica.Blocks.Interfaces.BooleanOutput secGen
    "=true to activate secondary generator"
    annotation (Placement(transformation(extent={{300,-80},{320,-60}})));
  Modelica.Blocks.Logical.Switch swiAntLeg
    "Switch to full load for anti legionella" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,50})));
  Modelica.Blocks.Interfaces.RealOutput ySecGenSet
    "Suggested relative power of secondary heat generator"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}})));
  Modelica.Blocks.Interfaces.RealInput TZoneMea[nZones](each final unit="K",
      each final displayUnit="degC") "Zones temperatures measurements"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TZoneSet[nZones](each final unit="K",
      each final displayUnit="degC") "Zones set temperatures"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Utilities.SupervisoryControl.SupervisoryControl supCtrHeaCur(ctrlType=
        supCtrHeaCurTyp)   "Supervisory control of heating curve"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Blocks.Sources.Constant constAntLeg(final k=1)
    "For anti legionella, run secondary device at full load"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Sources.Constant constAntLegOff(final k=0)
    "Disable secondary device if no anti legionella"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={160,80})));
  Modelica.Blocks.Math.BooleanToReal booToReal(final realTrue=1, final realFalse=
        0) "Convert singal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={200,80})));
  Modelica.Blocks.Interfaces.BooleanOutput DHW "=true for DHW loading"
    annotation (Placement(transformation(extent={{300,42},{320,62}})));
  Modelica.Blocks.Interfaces.RealOutput TBuiSet(unit="K", displayUnit="degC")
    "Building supply set temperature"
    annotation (Placement(transformation(extent={{300,10},{320,30}})));
equation
  connect(hysBui.priGenOn, priGenOn.u2) annotation (Line(points={{59.12,-64.4},{74,
          -64.4},{74,-106},{152,-106},{152,-78},{158,-78}}, color={255,0,255}));
  connect(hysDHW.priGenOn, priGenOn.u1) annotation (Line(points={{79.12,75.6},{79.12,
          74},{106,74},{106,-62},{150,-62},{150,-70},{158,-70}}, color={255,0,255}));
  connect(TSetDHW.y, orDHW.u[1]) annotation (Line(points={{-61.2,85.36},{-54,
          85.36},{-54,50},{-48,50},{-48,34},{90,34},{90,74},{108,74},{108,67.6667},
          {120,67.6667}},                   color={255,0,255}));
  connect(hysDHW.secGenOn, orDHW.u[2]) annotation (Line(points={{79.12,66},{90,66},
          {90,50},{120,50},{120,70}}, color={255,0,255}));
  connect(TSetDHW.TSetDHW, supCtrDHW.uLoc) annotation (Line(points={{-61.2,90},{-10,
          90},{-10,62},{-2,62}}, color={0,0,127}));
  connect(supCtrDHW.y, hysDHW.TSupSet) annotation (Line(points={{22,70},{22,56},{70,
          56},{70,61.2}}, color={0,0,127}));
  connect(minMax.yMax,heaCur.TZoneSet)
    annotation (Line(points={{-59,-60},{-30,-60},{-30,-78}}, color={0,0,127}));
  connect(heaCur.TOda, TOda) annotation (Line(points={{-42,-90},{-94,-90},{-94,0},
          {-120,0}},   color={0,0,127}));
  connect(TSetDHW.sigBusDistr, sigBusDistr) annotation (Line(
      points={{-78,89.92},{-78,90},{-86,90},{-86,70},{-100,70}},
      color={255,204,51},
      thickness=0.5));
  connect(hysBui.TOda, TOda) annotation (Line(points={{50,-61.04},{50,-54},{-54,-54},
          {-54,0},{-120,0}}, color={0,0,127}));
  connect(supCtrDHW.uSup, sigBusHyd.TSetDHWOve) annotation (Line(points={{-2,78},
          {-8,78},{-8,88},{78,88},{78,84},{100,84},{100,103}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrDHW.actInt, sigBusHyd.oveTSetDHW) annotation (Line(points={{-2,70},
          {-8,70},{-8,78},{-6,78},{-6,86},{78,86},{78,84},{100,84},{100,103}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysDHW.priGenOn, orDHW.u[3]) annotation (Line(points={{79.12,75.6},{
          79.12,74},{108,74},{108,72.3333},{120,72.3333}},
                                                     color={255,0,255}));
  connect(priGenOn.y, priGren) annotation (Line(points={{181,-70},{208,-70},{208,
          -110},{310,-110}},
                       color={255,0,255}));
  connect(secGenOn.y, secGen) annotation (Line(points={{141.5,-90},{292,-90},{292,
          -70},{310,-70}},                                         color={255,0,255}));
  connect(secGenOn.u[1], hysBui.secGenOn) annotation (Line(points={{120,-92.3333},
          {114,-92.3333},{114,-74},{59.12,-74}}, color={255,0,255}));
  connect(hysDHW.secGenOn, secGenOn.u[2]) annotation (Line(points={{79.12,66},{90,
          66},{90,50},{114,50},{114,-90},{120,-90}}, color={255,0,255}));
  connect(TSetDHW.y, secGenOn.u[3]) annotation (Line(points={{-61.2,85.36},{-54,
          85.36},{-54,50},{-48,50},{-48,34},{90,34},{90,50},{114,50},{114,
          -87.6667},{120,-87.6667}},
                      color={255,0,255}));
  connect(maxSecHeaGen.u[1], hysDHW.ySecGenSet) annotation (Line(points={{120,
          -31.6667},{86,-31.6667},{86,8},{52,8},{52,54},{79.12,54},{79.12,63.12}},
                                                                         color={0,
          0,127}));
  connect(maxSecHeaGen.u[2], hysBui.ySecGenSet) annotation (Line(points={{120,-34},
          {86,-34},{86,-76.88},{59.12,-76.88}}, color={0,0,127}));
  connect(swiAntLeg.y, maxSecHeaGen.u[3]) annotation (Line(points={{-19,50},{52,
          50},{52,8},{86,8},{86,-36.3333},{120,-36.3333}},
                                       color={0,0,127}));
  connect(TSetDHW.y, swiAntLeg.u2) annotation (Line(points={{-61.2,85.36},{-54,
          85.36},{-54,50},{-42,50}},
                              color={255,0,255}));
  connect(hysDHW.TStoTop, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{61.2,
          75.6},{48,75.6},{48,102},{-90,102},{-90,70},{-100,70}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysDHW.TStoBot, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{61.2,
          66},{48,66},{48,102},{-90,102},{-90,70},{-100,70}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(maxSecHeaGen.yMax, ySecGenSet)
    annotation (Line(points={{141,-40},{310,-40}},
                                               color={0,0,127}));
  connect(TOda, hysDHW.TOda) annotation (Line(points={{-120,0},{-94,0},{-94,102},{
          70,102},{70,78.96}}, color={0,0,127}));
  connect(hysBui.TStoTop, sigBusDistr.TStoBufTopMea) annotation (Line(points={{41.2,
          -64.4},{38,-64.4},{38,-64},{34,-64},{34,6},{-100,6},{-100,70}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysBui.TStoBot, sigBusDistr.TStoBufBotMea) annotation (Line(points={{41.2,
          -74},{34,-74},{34,6},{-100,6},{-100,70}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.y, hysBui.TSupSet)
    annotation (Line(points={{22,-90},{50,-90},{50,-78.8}}, color={0,0,127}));
  connect(supCtrHeaCur.uLoc, heaCur.TSet) annotation (Line(points={{-2,-98},{-14,
          -98},{-14,-90},{-19,-90}}, color={0,0,127}));
  connect(minMax.u, TZoneSet) annotation (Line(points={{-80,-66},{-92,-66},{-92,
          -80},{-120,-80}}, color={0,0,127}));
  connect(constAntLegOff.y, swiAntLeg.u3) annotation (Line(points={{-59,30},{-50,
          30},{-50,42},{-42,42}}, color={0,0,127}));
  connect(constAntLeg.y, swiAntLeg.u1)
    annotation (Line(points={{-59,60},{-59,58},{-42,58}}, color={0,0,127}));
  connect(booToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{211,80},
          {216,80},{216,116},{-100,116},{-100,70}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bufOn.u, orDHW.y) annotation (Line(points={{148,80},{141.5,80},{141.5,
          70}}, color={255,0,255}));
  connect(booToReal.u, bufOn.y)
    annotation (Line(points={{188,80},{171,80}}, color={255,0,255}));
  connect(orDHW.y, DHW) annotation (Line(points={{141.5,70},{144,70},{144,52},{310,
          52}}, color={255,0,255}));
  connect(supCtrHeaCur.uSup, sigBusHyd.TBuiSupOve) annotation (Line(points={{-2,-82},
          {-16,-82},{-16,12},{-106,12},{-106,132},{100,132},{100,103}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.actInt, sigBusHyd.oveTBuiSup) annotation (Line(points={{-2,
          -90},{-16,-90},{-16,12},{-106,12},{-106,132},{100,132},{100,103}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.y, TBuiSet) annotation (Line(points={{22,-90},{56,-90},{56,
          -134},{284,-134},{284,20},{310,20}}, color={0,0,127}));
  connect(supCtrDHW.y, TDHWSet) annotation (Line(points={{22,70},{22,42},{274,42},
          {274,80},{310,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},
            {300,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-140},{300,100}}), graphics={
        Rectangle(
          extent={{-98,102},{222,22}},
          lineColor={238,46,47},
          lineThickness=1),
        Text(
          extent={{-94,92},{0,126}},
          lineColor={238,46,47},
          lineThickness=1,
          textString="DHW Control"),
        Rectangle(
          extent={{-100,-48},{80,-140}},
          lineColor={0,140,72},
          lineThickness=1),
        Text(
          extent={{-100,-146},{-6,-112}},
          lineColor={0,140,72},
          lineThickness=1,
          textString="Building Control")}));
end BuildingAndDHWControl;
