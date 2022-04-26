within BESMod.Systems.Hydraulical.Control;
model MonovalentGasBoiler "PI Control of gas boiler"
  extends BaseClasses.SystemWithThermostaticValveControl;
  BESMod.Systems.Hydraulical.Control.Components.HeatingCurve
    heatingCurve(
    TRoomSet=monovalentControlParas.TSetRoomConst,
    GraHeaCurve=monovalentControlParas.gradientHeatCurve,
    THeaThres=monovalentControlParas.TSetRoomConst,
    dTOffSet_HC=monovalentControlParas.dTOffSetHeatCurve)
    annotation (Placement(transformation(extent={{-220,18},{-198,40}})));
  BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
    TSet_DHW(T_DHW=distributionParameters.TDHW_nominal)
    annotation (Placement(transformation(extent={{-220,74},{-200,96}})));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
    HP_nSet_Controller(
    P=monovalentControlParas.k,
    nMin=monovalentControlParas.nMin,
    T_I=monovalentControlParas.T_I,
    Ni=monovalentControlParas.Ni) annotation (choicesAllMatching=true,
      Placement(transformation(extent={{18,60},{60,96}})));
  Modelica.Blocks.Logical.OnOffController BoilerOnOffBuf(bandwidth=
        monovalentControlParas.dTHysBui, pre_y_start=true)
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-132,22},{-104,50}})));
  Modelica.Blocks.Logical.OnOffController boilerOnOffDHW(bandwidth=
        monovalentControlParas.dTHysDHW, pre_y_start=true)
    "Generates the on/off signal depending on the temperature inputs"
    annotation (Placement(transformation(extent={{-132,70},{-104,98}})));
  Modelica.Blocks.Sources.Constant const_dT_loading(k=distributionParameters.dTTra_nominal[1])
                                     annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={-76,88})));
  Modelica.Blocks.Math.Add add_dT_LoadingBuf
    annotation (Placement(transformation(extent={{-52,84},{-42,94}})));
  Modelica.Blocks.Logical.Or BoiOn annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-8,78})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-29,97})));
  Modelica.Blocks.Sources.Constant const_dT_loading1(k=distributionParameters.dTTraDHW_nominal
         + monovalentControlParas.dTHysDHW /2) annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={-76,104})));
  Modelica.Blocks.Math.Add add_dT_LoadingDHW
    annotation (Placement(transformation(extent={{-54,108},{-44,118}})));
  replaceable parameter RecordsCollection.BivalentHeatPumpControlDataDefinition
    monovalentControlParas constrainedby
    RecordsCollection.BivalentHeatPumpControlDataDefinition(                                     final TBiv=monovalentControlParas.TOda_nominal)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-226,-38},{-206,-18}})));
equation
  connect(sigBusDistr,TSet_DHW. sigBusDistr) annotation (Line(
      points={{1,-100},{10,-100},{10,-146},{-280,-146},{-280,84.89},{-220,84.89}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(BoilerOnOffBuf.u, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-134.8,
          27.6},{-150,27.6},{-150,-66},{1,-66},{1,-100}},
                      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(boilerOnOffDHW.u, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-134.8,
          75.6},{-160,75.6},{-160,-62},{112,-62},{112,-100},{1,-100}},
                              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSet_DHW.TSet_DHW, boilerOnOffDHW.reference) annotation (Line(
        points={{-199,85},{-156,85},{-156,92.4},{-134.8,92.4}}, color={0,0,
          127}));
  connect(heatingCurve.TSet, BoilerOnOffBuf.reference) annotation (Line(
        points={{-196.9,29},{-162,29},{-162,44.4},{-134.8,44.4}}, color={0,0,
          127}));
  connect(const_dT_loading.y, add_dT_LoadingBuf.u2) annotation (Line(points={{
          -71.6,88},{-64,88},{-64,86},{-53,86}}, color={0,0,127}));
  connect(BoiOn.y, HP_nSet_Controller.HP_On) annotation (Line(points={{-1.4,78},
          {13.8,78}},                       color={255,0,255}));
  connect(boilerOnOffDHW.y, BoiOn.u1) annotation (Line(points={{-102.6,84},{-86,
          84},{-86,78},{-15.2,78}},   color={255,0,255}));
  connect(BoilerOnOffBuf.y, BoiOn.u2) annotation (Line(points={{-102.6,36},{-86,
          36},{-86,73.2},{-15.2,73.2}},
                                      color={255,0,255}));
  connect(boilerOnOffDHW.y, switch1.u2) annotation (Line(points={{-102.6,84},{
          -96,84},{-96,97},{-35,97}},  color={255,0,255}));
  connect(boilerOnOffDHW.y, sigBusDistr.dhw_on) annotation (Line(points={{-102.6,
          84},{-96,84},{-96,-60},{1,-60},{1,-100}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_nSet_Controller.T_Meas, sigBusGen.TBoiOut) annotation (Line(
        points={{39,56.4},{39,-54},{-152,-54},{-152,-99}},  color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(HP_nSet_Controller.n_Set, sigBusGen.uBoiSet) annotation (Line(
        points={{62.1,78},{74,78},{74,-48},{-118,-48},{-118,-99},{-152,-99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-222.2,
          29},{-237,29},{-237,2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(const_dT_loading1.y, add_dT_LoadingDHW.u2) annotation (Line(points={{
          -71.6,104},{-66,104},{-66,110},{-55,110}}, color={0,0,127}));
  connect(TSet_DHW.TSet_DHW, add_dT_LoadingDHW.u1) annotation (Line(points={{
          -199,85},{-184,85},{-184,116},{-55,116}}, color={0,0,127}));
  connect(switch1.y, HP_nSet_Controller.T_Set) annotation (Line(points={{-23.5,
          97},{13.8,97},{13.8,88.8}}, color={0,0,127}));
  connect(add_dT_LoadingBuf.y, switch1.u3) annotation (Line(points={{-41.5,89},
          {-38.75,89},{-38.75,93},{-35,93}}, color={0,0,127}));
  connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{-43.5,113},
          {-35,113},{-35,101}}, color={0,0,127}));
  connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{
          -196.9,29},{-176,29},{-176,60},{-60,60},{-60,92},{-53,92}}, color={0,
          0,127}));
  connect(BoiOn.y, HP_nSet_Controller.IsOn) annotation (Line(points={{-1.4,78},{
          4,78},{4,40},{26.4,40},{26.4,56.4}}, color={255,0,255}));
end MonovalentGasBoiler;
