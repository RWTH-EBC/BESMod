within BESMod.Systems.Hydraulical.Control;
model MonovalentGasBoiler "PI Control of gas boiler"
  extends BaseClasses.SystemWithThermostaticValveControl;
  BESMod.Systems.Hydraulical.Control.Components.HeatingCurve
    heatingCurve(
    GraHeaCurve=monovalentControlParas.gradientHeatCurve,
    THeaThres=monovalentControlParas.TSetRoomConst,
    dTOffSet_HC=monovalentControlParas.dTOffSetHeatCurve)
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
    TSet_DHW(T_DHW=distributionParameters.TDHW_nominal) if use_dhw
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
    HP_nSet_Controller(
    P=monovalentControlParas.k,
    nMin=monovalentControlParas.nMin,
    T_I=monovalentControlParas.T_I,
    Ni=monovalentControlParas.Ni) annotation (choicesAllMatching=true,
      Placement(transformation(extent={{102,42},{138,78}})));
  Modelica.Blocks.Logical.OnOffController BoilerOnOffBuf(bandwidth=
        monovalentControlParas.dTHysBui, pre_y_start=true)
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Modelica.Blocks.Logical.OnOffController boilerOnOffDHW(bandwidth=
        monovalentControlParas.dTHysDHW, pre_y_start=true) if use_dhw
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Modelica.Blocks.Sources.Constant const_dT_loading(k=distributionParameters.dTTra_nominal[1])
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
  Modelica.Blocks.Sources.Constant const_dT_loading1(k=distributionParameters.dTTraDHW_nominal
         + monovalentControlParas.dTHysDHW /2) if use_dhw
                                               annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,90})));
  Modelica.Blocks.Math.Add add_dT_LoadingDHW if use_dhw
    annotation (Placement(transformation(extent={{-60,80},{-40,60}})));
  replaceable parameter RecordsCollection.BivalentHeatPumpControlDataDefinition
    monovalentControlParas constrainedby
    RecordsCollection.BivalentHeatPumpControlDataDefinition(
    TOda_nominal=generationParameters.TOda_nominal,
    TSup_nominal=generationParameters.TSup_nominal[1],
    TSetRoomConst=transferParameters.TDem_nominal[1],
    final TBiv=monovalentControlParas.TOda_nominal)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-218,
            -36},{-204,-22}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=false)
    if not use_dhw annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,-10})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough if not use_dhw
    annotation (Placement(transformation(extent={{46,48},{66,68}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Math.MinMax minMax(nu=transferParameters.nParallelDem)
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
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
  connect(TSet_DHW.TSet_DHW, boilerOnOffDHW.reference) annotation (Line(
        points={{-199,90},{-194,90},{-194,72},{-168,72},{-168,56},{-162,56}},
                                                                color={0,0,
          127}));
  connect(heatingCurve.TSet, BoilerOnOffBuf.reference) annotation (Line(
        points={{-199,30},{-168,30},{-168,16},{-162,16}},         color={0,0,
          127}));
  connect(const_dT_loading.y, add_dT_LoadingBuf.u2) annotation (Line(points={{-99,-10},
          {-88,-10},{-88,4},{-82,4}},            color={0,0,127}));
  connect(BoiOn.y, HP_nSet_Controller.HP_On) annotation (Line(points={{1,30},{4,
          30},{4,46},{98.4,46},{98.4,60}},  color={255,0,255}));
  connect(boilerOnOffDHW.y, BoiOn.u1) annotation (Line(points={{-139,50},{-134,50},
          {-134,46},{-30,46},{-30,36},{-28,36},{-28,30},{-22,30}},
                                      color={255,0,255}));
  connect(BoilerOnOffBuf.y, BoiOn.u2) annotation (Line(points={{-139,10},{-102,10},
          {-102,22},{-22,22}},        color={255,0,255}));
  connect(boilerOnOffDHW.y, switch1.u2) annotation (Line(points={{-139,50},{-134,
          50},{-134,46},{-28,46},{-28,66},{-8,66},{-8,70},{-2,70}},
                                       color={255,0,255}));
  connect(HP_nSet_Controller.T_Meas, sigBusGen.TBoiOut) annotation (Line(
        points={{120,38.4},{116,38.4},{116,30},{28,30},{28,-26},{-152,-26},{-152,
          -99}},                                            color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(HP_nSet_Controller.n_Set, sigBusGen.uBoiSet) annotation (Line(
        points={{139.8,60},{146,60},{146,-30},{-152,-30},{-152,-99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-222,30},
          {-237,30},{-237,2}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(const_dT_loading1.y, add_dT_LoadingDHW.u2) annotation (Line(points={{-79,90},
          {-72,90},{-72,76},{-62,76}},               color={0,0,127}));
  connect(TSet_DHW.TSet_DHW, add_dT_LoadingDHW.u1) annotation (Line(points={{-199,90},
          {-194,90},{-194,72},{-70,72},{-70,64},{-62,64}},
                                                    color={0,0,127}));
  connect(switch1.y, HP_nSet_Controller.T_Set) annotation (Line(points={{21,70},
          {40,70},{40,74},{84,74},{84,70.8},{98.4,70.8}},
                                      color={0,0,127}));
  connect(add_dT_LoadingBuf.y, switch1.u3) annotation (Line(points={{-59,10},{-44,
          10},{-44,54},{-8,54},{-8,62},{-2,62}},
                                             color={0,0,127}));
  connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{-39,70},{-39,
          68},{-14,68},{-14,78},{-2,78}},
                                color={0,0,127}));
  connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{-199,30},
          {-88,30},{-88,16},{-82,16}},                                color={0,
          0,127}));
  connect(BoiOn.y, HP_nSet_Controller.IsOn) annotation (Line(points={{1,30},{4,30},
          {4,46},{90,46},{90,28},{109.2,28},{109.2,38.4}},
                                               color={255,0,255}));
  connect(booleanConstant.y, BoiOn.u1) annotation (Line(points={{-19,-10},{-14,-10},
          {-14,14},{-28,14},{-28,30},{-22,30}}, color={255,0,255}));
  connect(realPassThrough.y, HP_nSet_Controller.T_Set) annotation (Line(points={
          {67,58},{84,58},{84,70.8},{98.4,70.8}}, color={0,0,127}));

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
  connect(minMax.yMax, heatingCurve.TSetRoom)
    annotation (Line(points={{-219,66},{-210,66},{-210,42}}, color={0,0,127}));
  connect(minMax.u, useProBus.TZoneSet) annotation (Line(points={{-240,60},{-244,
          60},{-244,103},{-119,103}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
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
end MonovalentGasBoiler;
