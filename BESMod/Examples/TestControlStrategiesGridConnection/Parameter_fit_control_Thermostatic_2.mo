within BESMod.Examples.TestControlStrategiesGridConnection;
model Parameter_fit_control_Thermostatic_2
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

  replaceable
    Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
    TSet_DHW constrainedby
    Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
      final T_DHW=distributionParameters.TDHW_nominal) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-154,72},{
            -130,96}})));
    parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory control for DHW Setpoint";

   replaceable parameter
    Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
    bivalentControlData constrainedby
    Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
    final TOda_nominal=generationParameters.TOda_nominal,
    TSup_nominal=generationParameters.TSup_nominal[1],
    TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

  Modelica.Blocks.Math.Add add_dT_LoadingDHW
    annotation (Placement(transformation(extent={{36,44},{54,62}})));
  Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
         + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={26,34})));
    Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
    HP_nSet_Controller_winter_mode(
    P=bivalentControlData.k,
    nMin=bivalentControlData.nMin,
    T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
      Placement(transformation(extent={{92,10},{130,46}})));
  Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-186,-66})));
  Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-67,-1})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={-67,-31})));
    Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
    DHWOnOffContoller(
    Hysteresis=bivalentControlData.dTHysDHW,
    TCutOff=TCutOff,
    TBiv=bivalentControlData.TBiv,
    TOda_nominal=bivalentControlData.TOda_nominal,
    TRoom=bivalentControlData.TSetRoomConst,
    QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
    QHP_flow_cutOff=QHP_flow_cutOff)
                      annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-32,32},{-16,48}})));
  parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
  parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

  Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-158,-46})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={71,39})));
    Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
    BufferOnOffController(
    Hysteresis=bivalentControlData.dTHysBui,
    TCutOff=TCutOff,
    TBiv=bivalentControlData.TBiv,
    TOda_nominal=bivalentControlData.TOda_nominal,
    TRoom=bivalentControlData.TSetRoomConst,
    QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
    QHP_flow_cutOff=QHP_flow_cutOff)
                          annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-108,8},{-92,22}})));
  Systems.Hydraulical.Control.Components.HeatingCurve
    heatingCurve(
    GraHeaCurve=bivalentControlData.gradientHeatCurve,
    THeaThres=bivalentControlData.TSetRoomConst,
    dTOffSet_HC=bivalentControlData.dTOffSetHeatCurve)
    annotation (Placement(transformation(extent={{-142,-8},{-122,12}})));
  Modelica.Blocks.Math.MinMax minMax(nu=transferParameters.nParallelDem)
    annotation (Placement(transformation(extent={{-184,4},{-164,24}})));
  Modelica.Blocks.Logical.Or HP_active
                                      annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={75,63})));
  Modelica.Blocks.Math.Add add_dT_LoadingBuf
    annotation (Placement(transformation(extent={{36,2},{54,20}})));
  Modelica.Blocks.Sources.Constant const_dT_loading1(k=distributionParameters.dTTra_nominal[
        1])                                               annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={24,2})));
equation
  connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,34},
          {40,34},{40,47.6},{34.2,47.6}},     color={0,0,127}));
  connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
    annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HP_nSet_Controller_winter_mode.n_Set, sigBusGen.yHeaPumSet)
    annotation (Line(points={{131.9,28},{148,28},{148,-66},{-152,-66},{-152,-99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
      points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,83.88},{-154,83.88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
          {-152,-66},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,77.04},{
          -128.8,76},{-67,76},{-67,5}}, color={255,0,255}));
  connect(bufOn.y, booleanToReal.u)
    annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
  connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
          -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
    annotation (Line(points={{99.6,6.4},{98,6.4},{98,-68},{-152,-68},{-152,-99}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
        points={{-32.8,45.6},{-32.8,44},{-38,44},{-38,-56},{1,-56},{1,-100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWBotMea) annotation (Line(
        points={{-32.8,36},{-34,36},{-34,-54},{1,-54},{1,-100}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{-128.8,
          84},{-36,84},{-36,31.2},{-24,31.2}},        color={0,0,127}));
  connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-24,
          48.96},{-24,60},{-236,60},{-236,2},{-237,2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(add_dT_LoadingDHW.u1, TSet_DHW.TSet_DHW) annotation (Line(points={{
          34.2,58.4},{16,58.4},{16,84},{-128.8,84}}, color={0,0,127}));
  connect(sigBusGen.heaPumIsOn, booleanToReal1.u) annotation (Line(
      points={{-152,-99},{-152,-100},{-142,-100},{-142,-34},{-158,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-158,
          -57},{-158,-64},{-152,-64},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(switch1.y, HP_nSet_Controller_winter_mode.T_Set) annotation (Line(
        points={{78.7,39},{78.7,38},{80,38},{80,38.8},{88.2,38.8}}, color={0,
          0,127}));
  connect(BufferOnOffController.T_Top, sigBusDistr.TStoBufTopMea) annotation (
      Line(points={{-108.8,19.9},{-110,19.9},{-110,20},{-112,20},{-112,-114},
          {22,-114},{22,-100},{1,-100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heatingCurve.TSet,BufferOnOffController. T_Set) annotation (Line(
        points={{-121,2},{-121,0},{-100,0},{-100,7.3}},
                                                    color={0,0,127}));
  connect(BufferOnOffController.T_bot, sigBusDistr.TStoBufTopMea) annotation (
      Line(points={{-108.8,11.5},{-112,11.5},{-112,-114},{152,-114},{152,-100},
          {1,-100}},           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(minMax.u, useProBus.TZoneSet) annotation (Line(points={{-184,14},{
          -188,14},{-188,24},{-190,24},{-190,32},{-119,32},{-119,103}},
                                                                   color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(minMax.yMax,heatingCurve. TSetRoom)
    annotation (Line(points={{-163,20},{-132,20},{-132,14}}, color={0,0,127}));
  connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-144,2},
          {-158,2},{-158,-2},{-210,-2},{-210,2},{-237,2}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(BufferOnOffController.T_oda, weaBus.TDryBul) annotation (Line(
        points={{-100,22.84},{-100,60},{-237,60},{-237,2}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(BufferOnOffController.HP_On, HP_active.u2) annotation (Line(points=
          {{-90.88,19.9},{-90.88,18},{12,18},{12,60},{28,60},{28,68},{64,68},
          {64,59},{69,59}}, color={255,0,255}));
  connect(DHWOnOffContoller.HP_On, HP_active.u1) annotation (Line(points={{
          -14.88,45.6},{-14.88,44},{30,44},{30,42},{58,42},{58,56},{60,56},{
          60,63},{69,63}}, color={255,0,255}));
  connect(HP_active.y, HP_nSet_Controller_winter_mode.HP_On) annotation (Line(
        points={{80.5,63},{80.5,28},{88.2,28}}, color={255,0,255}));
  connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{54.9,53},
          {54.9,50},{62.6,50},{62.6,44.6}}, color={0,0,127}));
  connect(add_dT_LoadingBuf.u2, const_dT_loading1.y) annotation (Line(points=
          {{34.2,5.6},{30,5.6},{30,2},{28.4,2}}, color={0,0,127}));
  connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{
          -121,2},{-78,2},{-78,12},{26,12},{26,16.4},{34.2,16.4}}, color={0,0,
          127}));
  annotation (Diagram(graphics={
        Rectangle(
          extent={{-222,30},{-32,-14}},
          lineColor={0,140,72},
          lineThickness=1),
        Text(
          extent={{-198,-42},{-104,-8}},
          lineColor={0,140,72},
          lineThickness=1,
          textString="Buffer Control")}));
end Parameter_fit_control_Thermostatic_2;
