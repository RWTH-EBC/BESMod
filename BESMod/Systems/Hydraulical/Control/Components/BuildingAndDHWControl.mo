within BESMod.Systems.Hydraulical.Control.Components;
model BuildingAndDHWControl
  "Control model to control both building and DHW systems"
  parameter Boolean use_dhw = true "=false to disable DHW";
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

  replaceable model BuildingHysteresis =
      BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater
      (dTHys=10)
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController
    "Hysteresis for building" annotation (choicesAllMatching=true);
  replaceable model BuildingSupplySetTemperature =
      BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
      (
      nZones=nZones,
      TSup_nominal=TSup_nominal,
      TRet_nominal=TRet_nominal,
      TOda_nominal=TOda_nominal,
      nHeaTra=nHeaTra)
      constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.PartialSetpoint
    "Supply temperature setpoint model, e.g. heating curve" annotation (
      choicesAllMatching=true);
  replaceable model DHWHysteresis =
      BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater
      (dTHys=10)
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController
    "Hysteresis for DHW system" annotation (choicesAllMatching=true);
  replaceable model DHWSetTemperature =
      BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      "DHW set temperture module" annotation (choicesAllMatching=true);
  replaceable model SummerMode =
   BESMod.Systems.Hydraulical.Control.Components.SummerMode.No
   constrainedby
    BESMod.Systems.Hydraulical.Control.Components.SummerMode.BaseClasses.PartialSummerMode
    "Summer mode model" annotation(choicesAllMatching=true);
  parameter Boolean useSGReady=false "=true to use SG Ready"
    annotation (Dialog(group="SG Ready"));
  parameter Boolean useExtSGSig=true "=true to use external SG ready signal"
    annotation (Dialog(group="SG Ready", enable=useSGReady));
  parameter Modelica.Units.SI.TemperatureDifference TAddSta3Bui=5
    "Increase for SG-Ready state 3 for building supply"
    annotation (Dialog(group="SG Ready", enable=useSGReady));
  parameter Modelica.Units.SI.TemperatureDifference TAddSta4Bui=10
    "Increase for SG-Ready state 4 for building supply"
    annotation (Dialog(group="SG Ready", enable=useSGReady));
  parameter Modelica.Units.SI.TemperatureDifference TAddSta3DHW=5
    "Increase for SG-Ready state 3 for DHW supply"
    annotation (Dialog(group="SG Ready", enable=useSGReady));
  parameter Modelica.Units.SI.TemperatureDifference TAddSta4DHW=10
    "Increase for SG-Ready state 4 for DHW supply"
    annotation (Dialog(group="SG Ready", enable=useSGReady));
  parameter String filNamSGReady=ModelicaServices.ExternalReferences.loadResource("modelica://BESMod/Resources/SGReady/EVU_Sperre_EON.txt")
    "Name of SG Ready scenario input file"
    annotation (Dialog(group="SG Ready", enable=not useExtSGSig and useSGReady));
  SummerMode sumMod "Summer mode instance"
    annotation (Placement(transformation(extent={{42,-18},{62,2}})));

  BuildingHysteresis hysBui
    "Hysteresis for building" annotation (Placement(
        transformation(extent={{40,-80},{60,-60}})));
  BuildingSupplySetTemperature TSetBuiSup
    "Building supply set temperature module"  annotation (
      Placement(transformation(extent={{-70,-80},{-50,-60}})));
  DHWHysteresis hysDHW if use_dhw
    "Hysteresis for DHW system" annotation (Placement(
        transformation(extent={{60,60},{80,80}})));
  DHWSetTemperature TSetDHW if use_dhw
                            "DHW set temperature module" annotation (
      Placement(transformation(extent={{-80,80},{-60,100}})));


  Modelica.Blocks.Logical.Or priGenOn if use_dhw
                                      "Turn on primary generation device"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={232,-90})));
  Modelica.Blocks.MathBoolean.Or orDHW(nu=3) if use_dhw
                                             "If any is true, dhw is activated"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,70})));
  BESMod.Utilities.SupervisoryControl.SupervisoryControl supCtrDHW(ctrlType=supCtrDHWTyp)
    if use_dhw             "Supervisory control of DHW"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Interfaces.RealInput TOda(unit="K", displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TDHWSet(unit="K", displayUnit="degC")
    if use_dhw
    "DHW supply set temperature"
    annotation (Placement(transformation(extent={{300,70},{320,90}})));
  Modelica.Blocks.Math.MinMax maxSecHeaGen(nu=if use_dhw then 3 else 1)
    "Maximal value suggested for secondary heat generator" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={210,-50})));
  Interfaces.DistributionControlBus sigBusDistr
    "Necessary to control DHW temperatures"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Interfaces.SystemControlBus sigBusHyd annotation (Placement(transformation(
          extent={{80,86},{120,120}}), iconTransformation(extent={{-48,84},{-8,
            118}})));
  Modelica.Blocks.Interfaces.BooleanOutput priGren
    "=true to activate primary generation device"
    annotation (Placement(transformation(extent={{300,-120},{320,-100}})));
  Modelica.Blocks.MathBoolean.Or secGenOn(nu=3) if use_dhw
    "If any is true, secondary heater is activated" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={192,-112})));
  Modelica.Blocks.Interfaces.BooleanOutput secGen
    "=true to activate secondary generator"
    annotation (Placement(transformation(extent={{300,-80},{320,-60}})));
  Modelica.Blocks.Logical.Switch swiAntLeg if use_dhw
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
    annotation (Placement(transformation(extent={{10,-100},{30,-80}})));
  Modelica.Blocks.Sources.Constant constAntLeg(final k=1) if use_dhw
    "For anti legionella, run secondary device at full load"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Sources.Constant constAntLegOff(final k=0) if use_dhw
    "Disable secondary device if no anti legionella"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={260,62})));
  Modelica.Blocks.Math.BooleanToReal booToReal(final realTrue=1, final realFalse=
        0) "Convert singal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={260,92})));
  Modelica.Blocks.Interfaces.BooleanOutput DHW if use_dhw
                                               "=true for DHW loading"
    annotation (Placement(transformation(extent={{300,42},{320,62}})));
  Modelica.Blocks.Interfaces.RealOutput TBuiSet(unit="K", displayUnit="degC")
    "Building supply set temperature"
    annotation (Placement(transformation(extent={{300,10},{320,30}})));
  Modelica.Blocks.Logical.LogicalSwitch logSwiDHW if use_dhw
                                                  "Logical switch"
    annotation (Placement(transformation(extent={{160,80},{180,60}})));
  Modelica.Blocks.Sources.BooleanConstant conSumMod(final k=true) if use_dhw
    "Constant DHW true in summer mode"
    annotation (Placement(transformation(extent={{130,80},{150,100}})));
  Modelica.Blocks.Logical.LogicalSwitch logSwiSumModSecGen
    "Logical switch for second heat generator"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Modelica.Blocks.Logical.LogicalSwitch logSwiSumModPriGen
    "Logical switch for primary heat generator"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Modelica.Blocks.Sources.BooleanConstant conSumModGen(final k=false)
    "Constant summer mode, generators off"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));

  Modelica.Blocks.Logical.Not winMod "=true for winter mode" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-10})));
  Modelica.Blocks.Routing.RealPassThrough
                                   realPassThrough if use_dhw
    "Disable secondary device if no anti legionella"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Modelica.Blocks.Logical.And priGenOffSGRead "Turn off due to SG Ready"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={270,-78})));
  Modelica.Blocks.Logical.And secGenOffSGRead "Turn off due to SG Ready"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={276,-126})));
  SetTemperatureSGReady TSetBuiSupSGReady(
    final useSGReady=useSGReady,
    final filNam=filNamSGReady,
    final TAddSta3=TAddSta3Bui,
    final TAddSta4=TAddSta4Bui,
    final useExtSGSig=useExtSGSig)
                             "Supply set temperature after SG Ready signal"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  SetTemperatureSGReady TSetDHWSGReady(
    final useSGReady=useSGReady,
    final filNam=filNamSGReady,
    final TAddSta3=TAddSta3DHW,
    final TAddSta4=TAddSta4DHW,
    final useExtSGSig=useExtSGSig)
                             if use_dhw
                             "DHW set temperature after SG Ready signal"
    annotation (Placement(transformation(extent={{-40,68},{-20,88}})));
  Modelica.Blocks.Sources.BooleanConstant conDHWOff(final k=false)
    if not use_dhw "Constant DHW true in summer mode"
    annotation (Placement(transformation(extent={{180,20},{200,40}})));
equation
  connect(hysDHW.priGenOn, priGenOn.u1) annotation (Line(points={{81.4,77},{81.4,
          76},{90,76},{90,32},{176,32},{176,-60},{194,-60},{194,-90},{220,-90}},
                                                                 color={255,0,255}));
  connect(TSetDHW.y, orDHW.u[1]) annotation (Line(points={{-59,84.2},{-54,84.2},
          {-54,34},{94,34},{94,64},{100,64},{100,67.6667}},
                                            color={255,0,255}));
  connect(hysDHW.secGenOn, orDHW.u[2]) annotation (Line(points={{81.4,65},{81.4,
          70},{100,70}},              color={255,0,255}));
  connect(supCtrDHW.y, hysDHW.TSupSet) annotation (Line(points={{22,70},{22,56},
          {70,56},{70,59}},
                          color={0,0,127}));
  connect(TSetBuiSup.TOda, TOda) annotation (Line(points={{-72,-70},{-90,-70},{-90,
          -38},{-54,-38},{-54,0},{-120,0}},
                        color={0,0,127}));
  connect(hysBui.TOda, TOda) annotation (Line(points={{50,-58.8},{50,-54},{-54,-54},
          {-54,0},{-120,0}}, color={0,0,127}));
  connect(supCtrDHW.uSup, sigBusHyd.TSetDHWOve) annotation (Line(points={{-2,78},
          {-8,78},{-8,88},{78,88},{78,84},{100,84},{100,103}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrDHW.actInt, sigBusHyd.oveTSetDHW) annotation (Line(points={{-2,70},
          {-8,70},{-8,88},{78,88},{78,84},{100,84},{100,103}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysDHW.secGenOn, secGenOn.u[1]) annotation (Line(points={{81.4,65},{
          88,65},{88,34},{176,34},{176,-114.333},{182,-114.333}},
                                                     color={255,0,255}));
  connect(TSetDHW.y, secGenOn.u[2]) annotation (Line(points={{-59,84.2},{-54,84.2},
          {-54,34},{176,34},{176,-112},{182,-112}},
                      color={255,0,255}));
  connect(maxSecHeaGen.u[2], hysDHW.ySecGenSet) annotation (Line(points={{200,-50},
          {180,-50},{180,-48},{164,-48},{164,42},{84,42},{84,58},{81.4,58},{81.4,
          61.4}},                                                        color={0,
          0,127}));
  connect(maxSecHeaGen.u[1], hysBui.ySecGenSet) annotation (Line(points={{200,-50},
          {200,-44},{72,-44},{72,-78.6},{61.4,-78.6}},
                                                color={0,0,127}));
  connect(swiAntLeg.y, maxSecHeaGen.u[3]) annotation (Line(points={{-19,50},{164,
          50},{164,-50},{200,-50}},    color={0,0,127}));
  connect(TSetDHW.y, swiAntLeg.u2) annotation (Line(points={{-59,84.2},{-54,84.2},
          {-54,50},{-42,50}}, color={255,0,255}));
  connect(hysDHW.TStoTop, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{59,77},
          {48,77},{48,102},{-90,102},{-90,70},{-100,70}},         color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysDHW.TStoBot, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{59,65},
          {48,65},{48,102},{-90,102},{-90,70},{-100,70}},     color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(maxSecHeaGen.yMax, ySecGenSet)
    annotation (Line(points={{221,-56},{286,-56},{286,-40},{310,-40}},
                                               color={0,0,127}));
  connect(TOda, hysDHW.TOda) annotation (Line(points={{-120,0},{-94,0},{-94,102},
          {70,102},{70,81.2}}, color={0,0,127}));
  connect(hysBui.TStoTop, sigBusDistr.TStoBufTopMea) annotation (Line(points={{39,-63},
          {38,-63},{38,-64},{34,-64},{34,6},{-100,6},{-100,70}},          color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysBui.TStoBot, sigBusDistr.TStoBufBotMea) annotation (Line(points={{39,-75},
          {34,-75},{34,6},{-100,6},{-100,70}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.y, hysBui.TSupSet)
    annotation (Line(points={{32,-90},{50,-90},{50,-81}},   color={0,0,127}));
  connect(constAntLegOff.y, swiAntLeg.u3) annotation (Line(points={{-59,30},{-50,
          30},{-50,42},{-42,42}}, color={0,0,127}));
  connect(constAntLeg.y, swiAntLeg.u1)
    annotation (Line(points={{-59,60},{-59,58},{-42,58}}, color={0,0,127}));
  connect(booToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{260,103},
          {260,112},{-118,112},{-118,70},{-100,70}},color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booToReal.u, bufOn.y)
    annotation (Line(points={{260,80},{260,73}}, color={255,0,255}));
  connect(supCtrHeaCur.uSup, sigBusHyd.TBuiSupOve) annotation (Line(points={{8,-82},
          {4,-82},{4,12},{-106,12},{-106,102},{100,102},{100,103}},     color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.actInt, sigBusHyd.oveTBuiSup) annotation (Line(points={{8,-90},
          {4,-90},{4,12},{-106,12},{-106,102},{100,102},{100,103}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.y, TBuiSet) annotation (Line(points={{32,-90},{90,-90},{90,
          -30},{292,-30},{292,20},{310,20}},   color={0,0,127}));
  connect(supCtrDHW.y, TDHWSet) annotation (Line(points={{22,70},{22,42},{274,42},
          {274,80},{310,80}}, color={0,0,127}));
  connect(logSwiSumModPriGen.y, priGenOn.u2) annotation (Line(points={{141,-70},
          {188,-70},{188,-98},{220,-98}}, color={255,0,255}));
  connect(logSwiSumModSecGen.y, secGenOn.u[3]) annotation (Line(points={{141,
          -110},{141,-109.667},{182,-109.667}},             color={255,0,255}));
  connect(logSwiDHW.y, DHW) annotation (Line(points={{181,70},{212,70},{212,44},
          {294,44},{294,52},{310,52}},
                     color={255,0,255}));
  connect(logSwiSumModSecGen.u3, conSumModGen.y) annotation (Line(points={{118,
          -118},{102,-118},{102,-130},{41,-130}}, color={255,0,255}));
  connect(hysBui.secGenOn, logSwiSumModSecGen.u1) annotation (Line(points={{61.4,
          -75},{104,-75},{104,-102},{118,-102}},       color={255,0,255}));
  connect(logSwiSumModPriGen.u3, conSumModGen.y) annotation (Line(points={{118,
          -78},{64,-78},{64,-130},{41,-130}}, color={255,0,255}));
  connect(hysBui.priGenOn, logSwiSumModPriGen.u1) annotation (Line(points={{61.4,
          -63},{61.4,-62},{118,-62}},          color={255,0,255}));
  connect(conSumMod.y, logSwiDHW.u3) annotation (Line(points={{151,90},{151,84},
          {158,84},{158,78}}, color={255,0,255}));
  connect(logSwiDHW.u1, orDHW.y) annotation (Line(points={{158,62},{126,62},{126,
          70},{121.5,70}},                color={255,0,255}));
  connect(sumMod.TOda, TOda) annotation (Line(points={{40,-8},{-54,-8},{-54,0},{-120,
          0}}, color={0,0,127}));
  connect(winMod.y, logSwiSumModPriGen.u2) annotation (Line(points={{101,-10},{104,
          -10},{104,-70},{118,-70}}, color={255,0,255}));
  connect(winMod.y, logSwiSumModSecGen.u2) annotation (Line(points={{101,-10},{104,
          -10},{104,-110},{118,-110}},                     color={255,0,255}));
  connect(winMod.u, sumMod.sumMod) annotation (Line(points={{78,-10},{66,-10},{66,
          -8},{63,-8}}, color={255,0,255}));
  connect(winMod.y, logSwiDHW.u2) annotation (Line(points={{101,-10},{108,-10},{
          108,54},{132,54},{132,70},{158,70}},
                         color={255,0,255}));
  connect(logSwiDHW.y, bufOn.u) annotation (Line(points={{181,70},{212,70},{212,
          44},{260,44},{260,50}}, color={255,0,255}));
  connect(TSetBuiSup.TSet, sigBusHyd.TBuiLoc) annotation (Line(points={{-49,-70},
          {4,-70},{4,12},{-106,12},{-106,102},{100,102},{100,103}},
                                                           color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough.y, sigBusHyd.TStoDHWTop) annotation (Line(points={{21,130},
          {100,130},{100,103}},                               color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough.u, sigBusDistr.TStoDHWTopMea) annotation (Line(points=
         {{-2,130},{-100,130},{-100,70}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSetBuiSup.TZoneMea, TZoneMea) annotation (Line(points={{-72,-62},{-92,
          -62},{-92,-40},{-120,-40}},
                                 color={0,0,127}));
  connect(TSetBuiSup.TZoneSet, TZoneSet) annotation (Line(points={{-72,-78},{-94,
          -78},{-94,-80},{-120,-80}},
                                 color={0,0,127}));
  connect(TSetDHW.TSetDHW, sigBusHyd.TSetDHW) annotation (Line(points={{-59,90},
          {78,90},{78,84},{100,84},{100,103}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(priGenOffSGRead.y, priGren) annotation (Line(points={{281,-78},{294,
          -78},{294,-110},{310,-110}}, color={255,0,255}));
  connect(secGenOffSGRead.y, secGen) annotation (Line(points={{287,-126},{290,
          -126},{290,-70},{310,-70}}, color={255,0,255}));
  connect(TSetBuiSupSGReady.TSet, supCtrHeaCur.uLoc) annotation (Line(points={{-18,
          -85},{-8,-85},{-8,-98},{8,-98}}, color={0,0,127}));
  connect(TSetBuiSup.TSet, TSetBuiSupSGReady.TSetLocCtrl)
    annotation (Line(points={{-49,-70},{-49,-85},{-42,-85}}, color={0,0,127}));
  connect(TSetBuiSupSGReady.signal, sigBusHyd.SGReady) annotation (Line(points={{-42,-97},
          {-44,-97},{-44,-98},{-46,-98},{-46,12},{-106,12},{-106,103},{100,103}},
                                                      color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrDHW.uLoc, TSetDHWSGReady.TSet) annotation (Line(points={{-2,62},
          {-12,62},{-12,83},{-18,83}}, color={0,0,127}));
  connect(TSetDHWSGReady.TSetLocCtrl, TSetDHW.TSetDHW) annotation (Line(points={
          {-42,83},{-42,82},{-52,82},{-52,90},{-59,90}}, color={0,0,127}));
  connect(TSetDHWSGReady.signal, sigBusHyd.SGReady) annotation (Line(points={{-42,
          71},{-48,71},{-48,103},{100,103}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(secGenOffSGRead.u1, secGenOn.y) annotation (Line(points={{264,-126},{208,
          -126},{208,-112},{203.5,-112}}, color={255,0,255}));
  connect(secGenOffSGRead.u2, TSetBuiSupSGReady.canRun) annotation (Line(points=
         {{264,-134},{92,-134},{92,-110},{-12,-110},{-12,-97},{-18,-97}}, color=
         {255,0,255}));
  connect(TSetBuiSupSGReady.canRun, priGenOffSGRead.u2) annotation (Line(points=
         {{-18,-97},{-16,-97},{-16,-100},{-12,-100},{-12,-110},{92,-110},{92,-134},
          {250,-134},{250,-86},{258,-86}}, color={255,0,255}));
  connect(priGenOn.y, priGenOffSGRead.u1) annotation (Line(points={{243,-90},{246,
          -90},{246,-78},{258,-78}}, color={255,0,255}));
  connect(hysDHW.priGenOn, orDHW.u[3]) annotation (Line(points={{81.4,77},{81.4,
          76},{96,76},{96,72.3333},{100,72.3333}}, color={255,0,255}));
  connect(conDHWOff.y, bufOn.u)
    annotation (Line(points={{201,30},{260,30},{260,50}}, color={255,0,255}));
  if use_dhw then
    connect(TSetDHW.sigBusDistr, sigBusDistr) annotation (Line(
      points={{-80,89.9},{-80,90},{-86,90},{-86,70},{-100,70}},
      color={255,204,51},
      thickness=0.5));
  else
    connect(secGenOffSGRead.u1, logSwiSumModSecGen.y) annotation (Line(
      points={{264,-126},{148,-126},{148,-110},{141,-110}},
      color={255,0,255},
      pattern=LinePattern.Dash));
    connect(logSwiSumModPriGen.y, priGenOffSGRead.u1) annotation (Line(
      points={{141,-70},{250,-70},{250,-78},{258,-78}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  end if;

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
          textString="Building Control"),
        Rectangle(
          extent={{-40,16},{120,-40}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{-44,-30},{24,-42}},
          lineColor={162,29,33},
          lineThickness=1,
          fontSize=12,
          textString="Summer mode")}));
end BuildingAndDHWControl;
