within BESMod.Systems.Hydraulical.Control;
model GasBoiler "PI Control of gas boiler"
  extends BaseClasses.PartialThermostaticValveControl;
  parameter Modelica.Units.SI.TemperatureDifference dTHysBui=10
    "Hysteresis for building demand control"
    annotation (Dialog(group="Building control"));
  parameter Modelica.Units.SI.TemperatureDifference dTHysDHW=10
    "Hysteresis for DHW demand control" annotation (Dialog(group="DHW control"));
  replaceable parameter RecordsCollection.PIDBaseDataDefinition parPID
    "PID parameters for boiler"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{142,84},{162,104}})));
  BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
    heatingCurve(
    final nZones=parTra.nParallelDem,
    TSup_nominal=max(parTra.TTra_nominal),
    TRet_nominal=max(parTra.TTra_nominal - parTra.dTTra_nominal),
    TOda_nominal=parGen.TOda_nominal,
    nHeaTra=parTra.nHeaTra)
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
    TSet_DHW(TSetDHW_nominal=parDis.TDHW_nominal) if use_dhw
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.PID PIDCtrl(
    yMax=parPID.yMax,
    yOff=parPID.yOff,
    y_start=parPID.y_start,
    P=parPID.P,
    yMin=parPID.yMin,
    timeInt=parPID.timeInt,
    Ni=parPID.Ni,
    timeDer=parPID.timeDer,
    Nd=parPID.Nd) "PID control" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{102,42},{138,78}})));
  Modelica.Blocks.Logical.OnOffController BoilerOnOffBuf(bandwidth=dTHysBui,
                                         pre_y_start=true)
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Modelica.Blocks.Logical.OnOffController boilerOnOffDHW(bandwidth=dTHysDHW,
                                         pre_y_start=true) if use_dhw
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Modelica.Blocks.Sources.Constant const_dT_loading(k=parDis.dTTra_nominal[1])
                                     annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,-10})));
  Modelica.Blocks.Math.Add add_dT_LoadingBuf
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Logical.Or BoiOn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,30})));
  Modelica.Blocks.Logical.Switch switch1 if use_dhw
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,70})));
  Modelica.Blocks.Sources.Constant const_dT_loading1(k=parDis.dTTraDHW_nominal
         + dTHysDHW /2) if use_dhw             annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,90})));
  Modelica.Blocks.Math.Add add_dT_LoadingDHW if use_dhw
    annotation (Placement(transformation(extent={{-60,80},{-40,60}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=false)
    if not use_dhw annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,-10})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough if not use_dhw
    annotation (Placement(transformation(extent={{46,48},{66,68}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Logical.Not bufOn if use_dhw
                                    "buffer is charged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-50})));
  Modelica.Blocks.Math.BooleanToReal booToRea(final realTrue=1, final realFalse=
       0) if use_dhw "Convert boolean signal to real for valve" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-50})));

equation
  connect(sigBusDistr,TSet_DHW. sigBusDistr) annotation (Line(
      points={{1,-100},{10,-100},{10,-146},{-280,-146},{-280,89.9},{-220,89.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(BoilerOnOffBuf.u, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-162,4},
          {-168,4},{-168,-32},{-88,-32},{-88,-66},{-30,-66},{-30,-64},{1,-64},{1,
          -100}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(boilerOnOffDHW.u, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-162,44},
          {-162,22},{-128,22},{-128,-68},{-28,-68},{-28,-66},{1,-66},{1,-100}},
                              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSet_DHW.TSetDHW, boilerOnOffDHW.reference) annotation (Line(points={{-199,
          90},{-194,90},{-194,72},{-168,72},{-168,56},{-162,56}}, color={0,0,127}));
  connect(heatingCurve.TSet, BoilerOnOffBuf.reference) annotation (Line(
        points={{-199,30},{-168,30},{-168,16},{-162,16}},         color={0,0,
          127}));
  connect(const_dT_loading.y, add_dT_LoadingBuf.u2) annotation (Line(points={{-99,-10},
          {-88,-10},{-88,4},{-82,4}},            color={0,0,127}));
  connect(BoiOn.y, PIDCtrl.setOn) annotation (Line(points={{1,30},{4,30},{4,46},{98.4,
          46},{98.4,60}}, color={255,0,255}));
  connect(boilerOnOffDHW.y, BoiOn.u1) annotation (Line(points={{-139,50},{-134,50},
          {-134,46},{-30,46},{-30,36},{-28,36},{-28,30},{-22,30}},
                                      color={255,0,255}));
  connect(BoilerOnOffBuf.y, BoiOn.u2) annotation (Line(points={{-139,10},{-102,10},
          {-102,22},{-22,22}},        color={255,0,255}));
  connect(boilerOnOffDHW.y, switch1.u2) annotation (Line(points={{-139,50},{-134,
          50},{-134,46},{-28,46},{-28,66},{-8,66},{-8,70},{-2,70}},
                                       color={255,0,255}));
  connect(PIDCtrl.TMea, sigBusGen.TBoiOut) annotation (Line(points={{120,38.4},{116,
          38.4},{116,30},{28,30},{28,-26},{-152,-26},{-152,-99}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(PIDCtrl.ySet, sigBusGen.uBoiSet) annotation (Line(points={{139.8,60},{146,
          60},{146,-30},{-152,-30},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-222,30},{
          -236.895,30},{-236.895,2.11}},
                                   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(const_dT_loading1.y, add_dT_LoadingDHW.u2) annotation (Line(points={{-79,90},
          {-72,90},{-72,76},{-62,76}},               color={0,0,127}));
  connect(TSet_DHW.TSetDHW, add_dT_LoadingDHW.u1) annotation (Line(points={{-199,
          90},{-194,90},{-194,72},{-70,72},{-70,64},{-62,64}}, color={0,0,127}));
  connect(switch1.y, PIDCtrl.TSet) annotation (Line(points={{21,70},{40,70},{40,74},
          {84,74},{84,70.8},{98.4,70.8}}, color={0,0,127}));
  connect(add_dT_LoadingBuf.y, switch1.u3) annotation (Line(points={{-59,10},{-44,
          10},{-44,54},{-8,54},{-8,62},{-2,62}},
                                             color={0,0,127}));
  connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{-39,70},{-39,
          68},{-14,68},{-14,78},{-2,78}},
                                color={0,0,127}));
  connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{-199,30},
          {-88,30},{-88,16},{-82,16}},                                color={0,
          0,127}));
  connect(BoiOn.y, PIDCtrl.isOn) annotation (Line(points={{1,30},{4,30},{4,46},{90,
          46},{90,28},{109.2,28},{109.2,38.4}}, color={255,0,255}));
  connect(booleanConstant.y, BoiOn.u1) annotation (Line(points={{-19,-10},{-14,-10},
          {-14,14},{-28,14},{-28,30},{-22,30}}, color={255,0,255}));
  connect(realPassThrough.y, PIDCtrl.TSet) annotation (Line(points={{67,58},{84,58},
          {84,70.8},{98.4,70.8}}, color={0,0,127}));

  connect(realPassThrough.u, add_dT_LoadingBuf.y) annotation (Line(points={{44,
          58},{26,58},{26,52},{-26,52},{-26,54},{-44,54},{-44,10},{-59,10}},
        color={0,0,127}));
  connect(BoiOn.y, booleanToReal.u) annotation (Line(points={{1,30},{12,30},{12,
          10},{38,10}}, color={255,0,255}));
  connect(booleanToReal.y, sigBusGen.uPump) annotation (Line(points={{61,10},{
          80,10},{80,-32},{-152,-32},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufOn.y, booToRea.u)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={255,0,255}));
  connect(booToRea.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-19,-50},
          {1,-50},{1,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufOn.u, boilerOnOffDHW.y) annotation (Line(points={{-82,-50},{-122,
          -50},{-122,50},{-139,50}}, color={255,0,255}));
  connect(heatingCurve.TZoneMea, buiMeaBus.TZoneMea) annotation (Line(points={{
          -222,38},{-234,38},{-234,40},{-242,40},{-242,103},{65,103}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heatingCurve.TZoneSet, useProBus.TZoneSet) annotation (Line(points={{
          -222,22},{-236,22},{-236,24},{-238,24},{-238,103},{-119,103}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end GasBoiler;
