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
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlThrWayValTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory control for three way valve";
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
    annotation (Placement(transformation(extent={{-58,-44},{-38,-24}})));

  BuildingHysteresis hysBui
    "Hysteresis for building" annotation (Placement(
        transformation(extent={{-60,-106},{-40,-86}})));
  BuildingSupplySetTemperature TSetBuiSup
    "Building supply set temperature module"  annotation (
      Placement(transformation(extent={{-170,-106},{-150,-86}})));
  DHWHysteresis hysDHW if use_dhw
    "Hysteresis for DHW system" annotation (Placement(
        transformation(extent={{-40,34},{-20,54}})));
  DHWSetTemperature TSetDHW if use_dhw
                            "DHW set temperature module" annotation (
      Placement(transformation(extent={{-180,54},{-160,74}})));


  Modelica.Blocks.Logical.Or priGenOn if use_dhw
                                      "Turn on primary generation device"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={132,-116})));
  Modelica.Blocks.MathBoolean.Or orDHW(nu=3) if use_dhw
                                             "If any is true, dhw is activated"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,44})));
  BESMod.Utilities.SupervisoryControl.SupervisoryControl supCtrDHW(ctrlType=supCtrDHWTyp)
    if use_dhw "Supervisory control of DHW"
    annotation (Placement(transformation(extent={{-100,34},{-80,54}})));
  Modelica.Blocks.Interfaces.RealInput TOda(unit="K", displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,-46},{-200,-6}})));
  Modelica.Blocks.Interfaces.RealOutput TDHWSet(unit="K", displayUnit="degC")
    if use_dhw
    "DHW supply set temperature"
    annotation (Placement(transformation(extent={{200,44},{220,64}})));
  Modelica.Blocks.Math.MinMax maxSecHeaGen(nu=if use_dhw then 3 else 1)
    "Maximal value suggested for secondary heat generator" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,-76})));
  Interfaces.DistributionControlBus sigBusDistr
    "Necessary to control DHW temperatures"
    annotation (Placement(transformation(extent={{-210,34},{-190,54}})));
  Interfaces.SystemControlBus sigBusHyd annotation (Placement(transformation(
          extent={{-20,60},{20,94}}),  iconTransformation(extent={{-18,160},{22,
            194}})));
  Modelica.Blocks.Interfaces.BooleanOutput priGren
    "=true to activate primary generation device"
    annotation (Placement(transformation(extent={{200,-146},{220,-126}})));
  Modelica.Blocks.MathBoolean.Or secGenOn(nu=3) if use_dhw
    "If any is true, secondary heater is activated" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={92,-138})));
  Modelica.Blocks.Interfaces.BooleanOutput secGen
    "=true to activate secondary generator"
    annotation (Placement(transformation(extent={{200,-106},{220,-86}})));
  Modelica.Blocks.Logical.Switch swiAntLeg if use_dhw
    "Switch to full load for anti legionella" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,24})));
  Modelica.Blocks.Interfaces.RealOutput ySecGenSet
    "Suggested relative power of secondary heat generator"
    annotation (Placement(transformation(extent={{200,-76},{220,-56}})));
  Modelica.Blocks.Interfaces.RealInput TZoneMea[nZones](each final unit="K",
      each final displayUnit="degC") "Zones temperatures measurements"
    annotation (Placement(transformation(extent={{-240,-86},{-200,-46}})));
  Modelica.Blocks.Interfaces.RealInput TZoneSet[nZones](each final unit="K",
      each final displayUnit="degC") "Zones set temperatures"
    annotation (Placement(transformation(extent={{-240,-126},{-200,-86}})));
  Utilities.SupervisoryControl.SupervisoryControl supCtrHeaCur(ctrlType=
        supCtrHeaCurTyp)   "Supervisory control of heating curve"
    annotation (Placement(transformation(extent={{-90,-126},{-70,-106}})));
  Modelica.Blocks.Sources.Constant constAntLeg(final k=1) if use_dhw
    "For anti legionella, run secondary device at full load"
    annotation (Placement(transformation(extent={{-180,24},{-160,44}})));
  Modelica.Blocks.Sources.Constant constAntLegOff(final k=0) if use_dhw
    "Disable secondary device if no anti legionella"
    annotation (Placement(transformation(extent={{-180,-6},{-160,14}})));
  Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={170,130})));
  Modelica.Blocks.Math.BooleanToReal booToReal(final realTrue=1, final realFalse=
        0) "Convert singal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,130})));
  Modelica.Blocks.Interfaces.BooleanOutput DHW if use_dhw
                                               "=true for DHW loading"
    annotation (Placement(transformation(extent={{200,16},{220,36}})));
  Modelica.Blocks.Interfaces.RealOutput TBuiSet(unit="K", displayUnit="degC")
    "Building supply set temperature"
    annotation (Placement(transformation(extent={{200,-16},{220,4}})));
  Modelica.Blocks.Logical.LogicalSwitch logSwiDHW if use_dhw
                                                  "Logical switch"
    annotation (Placement(transformation(extent={{60,54},{80,34}})));
  Modelica.Blocks.Sources.BooleanConstant conSumMod(final k=true) if use_dhw
    "Constant DHW true in summer mode"
    annotation (Placement(transformation(extent={{30,54},{50,74}})));
  Modelica.Blocks.Logical.LogicalSwitch logSwiSumModSecGen
    "Logical switch for second heat generator"
    annotation (Placement(transformation(extent={{20,-146},{40,-126}})));
  Modelica.Blocks.Logical.LogicalSwitch logSwiSumModPriGen
    "Logical switch for primary heat generator"
    annotation (Placement(transformation(extent={{20,-106},{40,-86}})));
  Modelica.Blocks.Sources.BooleanConstant conSumModGen(final k=false)
    "Constant summer mode, generators off"
    annotation (Placement(transformation(extent={{-80,-166},{-60,-146}})));

  Modelica.Blocks.Logical.Not winMod "=true for winter mode" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-36})));
  Modelica.Blocks.Routing.RealPassThrough
                                   realPassThrough if use_dhw
    "Disable secondary device if no anti legionella"
    annotation (Placement(transformation(extent={{-100,94},{-80,114}})));
  Modelica.Blocks.Logical.And priGenOffSGRead "Turn off due to SG Ready"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={170,-104})));
  Modelica.Blocks.Logical.And secGenOffSGRead "Turn off due to SG Ready"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={176,-152})));
  SetTemperatureSGReady TSetBuiSupSGReady(
    final useSGReady=useSGReady,
    final filNam=filNamSGReady,
    final TAddSta3=TAddSta3Bui,
    final TAddSta4=TAddSta4Bui,
    final useExtSGSig=useExtSGSig)
                             "Supply set temperature after SG Ready signal"
    annotation (Placement(transformation(extent={{-140,-126},{-120,-106}})));

  SetTemperatureSGReady TSetDHWSGReady(
    final useSGReady=useSGReady,
    final filNam=filNamSGReady,
    final TAddSta3=TAddSta3DHW,
    final TAddSta4=TAddSta4DHW,
    final useExtSGSig=useExtSGSig)
                             if use_dhw
                             "DHW set temperature after SG Ready signal"
    annotation (Placement(transformation(extent={{-140,42},{-120,62}})));
  Modelica.Blocks.Sources.BooleanConstant conDHWOff(final k=false)
    if not use_dhw "Constant DHW true in summer mode"
    annotation (Placement(transformation(extent={{80,-6},{100,14}})));
  BESMod.Utilities.SupervisoryControl.SupervisoryControl supCtrThrWayVal(final
      ctrlType=supCtrlThrWayValTyp) "Supervisory control of DHW" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,130})));

equation
  connect(hysDHW.priGenOn, priGenOn.u1) annotation (Line(points={{-18.6,51},{-8,
          51},{-8,-20},{90,-20},{90,-116},{120,-116}},           color={255,0,255}));
  connect(TSetDHW.y, orDHW.u[1]) annotation (Line(points={{-159,58.2},{-150,
          58.2},{-150,70},{-46,70},{-46,28},{-10,28},{-10,41.6667},{0,41.6667}},
                                            color={255,0,255}));
  connect(hysDHW.secGenOn, orDHW.u[2]) annotation (Line(points={{-18.6,39},{-8,39},
          {-8,44},{0,44}},            color={255,0,255}));
  connect(supCtrDHW.y, hysDHW.TSupSet) annotation (Line(points={{-78,44},{-46,44},
          {-46,28},{-30,28},{-30,33}},
                          color={0,0,127}));
  connect(TSetBuiSup.TOda, TOda) annotation (Line(points={{-172,-96},{-194,-96},
          {-194,-26},{-220,-26}},
                        color={0,0,127}));
  connect(hysBui.TOda, TOda) annotation (Line(points={{-50,-84.8},{-50,-50},{-194,
          -50},{-194,-26},{-220,-26}},
                             color={0,0,127}));
  connect(supCtrDHW.uSup, sigBusHyd.TSetDHWOve) annotation (Line(points={{-102,52},
          {-106,52},{-106,77},{0,77}},                         color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrDHW.actInt, sigBusHyd.oveTSetDHW) annotation (Line(points={{-102,44},
          {-106,44},{-106,77},{0,77}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysDHW.secGenOn, secGenOn.u[1]) annotation (Line(points={{-18.6,39},{
          -8,39},{-8,-20},{72,-20},{72,-140.333},{82,-140.333}},
                                                     color={255,0,255}));
  connect(TSetDHW.y, secGenOn.u[2]) annotation (Line(points={{-159,58.2},{-152,58.2},
          {-152,-80},{72,-80},{72,-138},{82,-138}},
                      color={255,0,255}));
  connect(maxSecHeaGen.u[2], hysDHW.ySecGenSet) annotation (Line(points={{100,-76},
          {8,-76},{8,28},{-14,28},{-14,35.4},{-18.6,35.4}},              color={0,
          0,127}));
  connect(maxSecHeaGen.u[1], hysBui.ySecGenSet) annotation (Line(points={{100,-76},
          {-32,-76},{-32,-104.6},{-38.6,-104.6}},
                                                color={0,0,127}));
  connect(swiAntLeg.y, maxSecHeaGen.u[3]) annotation (Line(points={{-119,24},{74,
          24},{74,-76},{100,-76}},     color={0,0,127}));
  connect(TSetDHW.y, swiAntLeg.u2) annotation (Line(points={{-159,58.2},{-152,58.2},
          {-152,24},{-142,24}},
                              color={255,0,255}));
  connect(hysDHW.TStoTop, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-41,51},
          {-74,51},{-74,68},{-154,68},{-154,44},{-200,44}},       color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysDHW.TStoBot, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{-41,39},
          {-68,39},{-68,68},{-154,68},{-154,44},{-200,44}},   color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(maxSecHeaGen.yMax, ySecGenSet)
    annotation (Line(points={{121,-82},{194,-82},{194,-66},{210,-66}},
                                               color={0,0,127}));
  connect(TOda, hysDHW.TOda) annotation (Line(points={{-220,-26},{-64,-26},{-64,
          62},{-30,62},{-30,55.2}},
                               color={0,0,127}));
  connect(hysBui.TStoTop, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-61,-89},
          {-144,-89},{-144,8},{-152,8},{-152,44},{-200,44}},              color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysBui.TStoBot, sigBusDistr.TStoBufBotMea) annotation (Line(points={{-61,
          -101},{-62,-101},{-62,-50},{-154,-50},{-154,44},{-200,44}},
                                                    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.y, hysBui.TSupSet)
    annotation (Line(points={{-68,-116},{-50,-116},{-50,-107}},
                                                            color={0,0,127}));
  connect(constAntLegOff.y, swiAntLeg.u3) annotation (Line(points={{-159,4},{-150,
          4},{-150,16},{-142,16}},color={0,0,127}));
  connect(constAntLeg.y, swiAntLeg.u1)
    annotation (Line(points={{-159,34},{-159,32},{-142,32}},
                                                          color={0,0,127}));
  connect(booToReal.u, bufOn.y)
    annotation (Line(points={{142,130},{159,130}},
                                                 color={255,0,255}));
  connect(supCtrHeaCur.uSup, sigBusHyd.TBuiSupOve) annotation (Line(points={{-92,
          -108},{-96,-108},{-96,28},{0,28},{0,77}},                     color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.actInt, sigBusHyd.oveTBuiSup) annotation (Line(points={{-92,
          -116},{-96,-116},{-96,28},{0,28},{0,77}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrHeaCur.y, TBuiSet) annotation (Line(points={{-68,-116},{90,-116},
          {90,-28},{182,-28},{182,-6},{210,-6}},
                                               color={0,0,127}));
  connect(supCtrDHW.y, TDHWSet) annotation (Line(points={{-78,44},{-46,44},{-46,
          20},{152,20},{152,16},{194,16},{194,54},{210,54}},
                              color={0,0,127}));
  connect(logSwiSumModPriGen.y, priGenOn.u2) annotation (Line(points={{41,-96},{
          112,-96},{112,-124},{120,-124}},color={255,0,255}));
  connect(logSwiSumModSecGen.y, secGenOn.u[3]) annotation (Line(points={{41,-136},
          {74,-136},{74,-135.667},{82,-135.667}},           color={255,0,255}));
  connect(logSwiDHW.y, DHW) annotation (Line(points={{81,44},{144,44},{144,16},{
          194,16},{194,26},{210,26}},
                     color={255,0,255}));
  connect(logSwiSumModSecGen.u3, conSumModGen.y) annotation (Line(points={{18,-144},
          {-54,-144},{-54,-156},{-59,-156}},      color={255,0,255}));
  connect(hysBui.secGenOn, logSwiSumModSecGen.u1) annotation (Line(points={{-38.6,
          -101},{-38.6,-102},{8,-102},{8,-128},{18,-128}},
                                                       color={255,0,255}));
  connect(logSwiSumModPriGen.u3, conSumModGen.y) annotation (Line(points={{18,-104},
          {-34,-104},{-34,-156},{-59,-156}},  color={255,0,255}));
  connect(hysBui.priGenOn, logSwiSumModPriGen.u1) annotation (Line(points={{-38.6,
          -89},{-10.3,-89},{-10.3,-88},{18,-88}},
                                               color={255,0,255}));
  connect(conSumMod.y, logSwiDHW.u3) annotation (Line(points={{51,64},{51,58},{58,
          58},{58,52}},       color={255,0,255}));
  connect(logSwiDHW.u1, orDHW.y) annotation (Line(points={{58,36},{26,36},{26,44},
          {21.5,44}},                     color={255,0,255}));
  connect(sumMod.TOda, TOda) annotation (Line(points={{-60,-34},{-194,-34},{-194,
          -26},{-220,-26}},
               color={0,0,127}));
  connect(winMod.y, logSwiSumModPriGen.u2) annotation (Line(points={{1,-36},{8,-36},
          {8,-96},{18,-96}},         color={255,0,255}));
  connect(winMod.y, logSwiSumModSecGen.u2) annotation (Line(points={{1,-36},{8,-36},
          {8,-136},{18,-136}},                             color={255,0,255}));
  connect(winMod.u, sumMod.sumMod) annotation (Line(points={{-22,-36},{-22,-34},
          {-37,-34}},   color={255,0,255}));
  connect(winMod.y, logSwiDHW.u2) annotation (Line(points={{1,-36},{48,-36},{48,
          44},{58,44}},  color={255,0,255}));
  connect(logSwiDHW.y, bufOn.u) annotation (Line(points={{81,44},{188,44},{188,
          130},{182,130}},        color={255,0,255}));
  connect(TSetBuiSup.TSet, sigBusHyd.TBuiLoc) annotation (Line(points={{-149,-96},
          {-70,-96},{-70,77},{0,77}},                      color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough.y, sigBusHyd.TStoDHWTop) annotation (Line(points={{-79,104},
          {0,104},{0,77}},                                    color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough.u, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-102,
          104},{-200,104},{-200,44}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSetBuiSup.TZoneMea, TZoneMea) annotation (Line(points={{-172,-88},{-194,
          -88},{-194,-66},{-220,-66}},
                                 color={0,0,127}));
  connect(TSetBuiSup.TZoneSet, TZoneSet) annotation (Line(points={{-172,-104},{-194,
          -104},{-194,-106},{-220,-106}},
                                 color={0,0,127}));
  connect(TSetDHW.TSetDHW, sigBusHyd.TSetDHW) annotation (Line(points={{-159,64},
          {-150,64},{-150,77},{0,77}},             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(priGenOffSGRead.y, priGren) annotation (Line(points={{181,-104},{194,-104},
          {194,-136},{210,-136}},      color={255,0,255}));
  connect(secGenOffSGRead.y, secGen) annotation (Line(points={{187,-152},{194,-152},
          {194,-96},{210,-96}},       color={255,0,255}));
  connect(TSetBuiSupSGReady.TSet, supCtrHeaCur.uLoc) annotation (Line(points={{-118,
          -111},{-118,-112},{-100,-112},{-100,-124},{-92,-124}},
                                           color={0,0,127}));
  connect(TSetBuiSup.TSet, TSetBuiSupSGReady.TSetLocCtrl)
    annotation (Line(points={{-149,-96},{-149,-111},{-142,-111}},
                                                             color={0,0,127}));
  connect(TSetBuiSupSGReady.signal, sigBusHyd.SGReady) annotation (Line(points={{-142,
          -123},{-142,-124},{-146,-124},{-146,-132},{-110,-132},{-110,77},{0,77}},
                                                      color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrDHW.uLoc, TSetDHWSGReady.TSet) annotation (Line(points={{-102,36},
          {-110,36},{-110,57},{-118,57}},
                                       color={0,0,127}));
  connect(TSetDHWSGReady.TSetLocCtrl, TSetDHW.TSetDHW) annotation (Line(points={{-142,57},
          {-154,57},{-154,64},{-159,64}},                color={0,0,127}));
  connect(TSetDHWSGReady.signal, sigBusHyd.SGReady) annotation (Line(points={{-142,45},
          {-150,45},{-150,77},{0,77}},       color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(secGenOffSGRead.u1, secGenOn.y) annotation (Line(points={{164,-152},{108,
          -152},{108,-138},{103.5,-138}}, color={255,0,255}));
  connect(secGenOffSGRead.u2, TSetBuiSupSGReady.canRun) annotation (Line(points={{164,
          -160},{-54,-160},{-54,-132},{-118,-132},{-118,-123}},           color=
         {255,0,255}));
  connect(TSetBuiSupSGReady.canRun, priGenOffSGRead.u2) annotation (Line(points={{-118,
          -123},{-118,-124},{-100,-124},{-100,-132},{8,-132},{8,-120},{112,-120},
          {112,-132},{158,-132},{158,-112}},
                                           color={255,0,255}));
  connect(priGenOn.y, priGenOffSGRead.u1) annotation (Line(points={{143,-116},{148,
          -116},{148,-104},{158,-104}},
                                     color={255,0,255}));
  connect(hysDHW.priGenOn, orDHW.u[3]) annotation (Line(points={{-18.6,51},{-8,
          51},{-8,46.3333},{0,46.3333}},           color={255,0,255}));
  connect(conDHWOff.y, bufOn.u)
    annotation (Line(points={{101,4},{106,4},{106,44},{188,44},{188,130},{182,
          130}},                                          color={255,0,255}));
  if use_dhw then
    connect(TSetDHW.sigBusDistr, sigBusDistr) annotation (Line(
      points={{-180,63.9},{-200,63.9},{-200,44}},
      color={255,204,51},
      thickness=0.5));
  else
    connect(secGenOffSGRead.u1, logSwiSumModSecGen.y) annotation (Line(
      points={{164,-152},{108,-152},{108,-154},{46,-154},{46,-136},{41,-136}},
      color={255,0,255},
      pattern=LinePattern.Dash));
    connect(logSwiSumModPriGen.y, priGenOffSGRead.u1) annotation (Line(
      points={{41,-96},{148,-96},{148,-104},{158,-104}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  end if;

  connect(supCtrThrWayVal.uLoc, booToReal.y) annotation (Line(points={{82,138},
          {114,138},{114,130},{119,130}},              color={0,0,127}));
  connect(supCtrThrWayVal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{58,130},
          {-200,130},{-200,44}},                            color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},
            {200,180}})), Diagram(coordinateSystem(extent={{-200,-180},{200,180}}),
                                  graphics={
        Rectangle(
          extent={{-198,76},{122,-4}},
          lineColor={238,46,47},
          lineThickness=1),
        Text(
          extent={{-194,66},{-100,100}},
          lineColor={238,46,47},
          lineThickness=1,
          textString="DHW Control"),
        Rectangle(
          extent={{-200,-74},{-20,-166}},
          lineColor={0,140,72},
          lineThickness=1),
        Text(
          extent={{-200,-172},{-106,-138}},
          lineColor={0,140,72},
          lineThickness=1,
          textString="Building Control"),
        Rectangle(
          extent={{-140,-10},{20,-66}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{-144,-56},{-76,-68}},
          lineColor={162,29,33},
          lineThickness=1,
          fontSize=12,
          textString="Summer mode"),
        Rectangle(
          extent={{200,100},{42,160}},
          lineColor={0,140,72},
          lineThickness=1),
        Text(
          extent={{58,166},{190,176}},
          textColor={0,140,72},
          textString="Three Way Valve Control"),
        Text(
          extent={{42,146},{100,154}},
          textColor={0,140,72},
          textString="External Control")}));
  annotation (Documentation(info="<html>
<p>This control model is for both building and domestic hot water (DHW) systems. 
It includes hysteresis control, supply temperature setpoints, and summer mode handling. 
The model supports SG Ready functionality for adjusting setpoints based on external signals, 
as well as various options to override signals using supervisory control-</p>

<h4>Used models</h4>
<ul>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController\">BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController</a></li>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.PartialSetpoint\">BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.PartialSetpoint</a></li>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control\">BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control</a></li>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.Control.Components.SummerMode.BaseClasses.PartialSummerMode\">BESMod.Systems.Hydraulical.Control.Components.SummerMode.BaseClasses.PartialSummerMode</a></li>
</ul></html>"));
end BuildingAndDHWControl;
