within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialHeatPumpSystemController
  "Partial model with replaceable blocks for rule based control of heat pump systems"
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.PartialThermostaticValveControl;
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController
    DHWOnOffContoller annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-128,70},{-112,86}})));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController
    BufferOnOffController annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-118,32},{-102,48}})));
  replaceable BESMod.Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
    safetyControl
    annotation (choicesAllMatching=true,Placement(transformation(extent={{200,30},{220,50}})));
  replaceable parameter RecordsCollection.BivalentHeatPumpControlDataDefinition
    bivalentControlData constrainedby
    RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem)
    "Parameters for bivalent control"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-96,-36},
            {-82,-22}})));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
    TSet_DHW constrainedby
    BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
      final T_DHW=distributionParameters.TDHW_nominal) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-216,66},{-192,
            90}})));
  BESMod.Systems.Hydraulical.Control.Components.HeatingCurve
    heatingCurve(
    GraHeaCurve=bivalentControlData.gradientHeatCurve,
    THeaThres=bivalentControlData.TSetRoomConst,
    dTOffSet_HC=bivalentControlData.dTOffSetHeatCurve)
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Modelica.Blocks.MathBoolean.Or
                             HRactive(nu=3)
                                      annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={15,25})));
  Modelica.Blocks.Logical.Or HP_active
                                      annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={27,91})));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.BaseClasses.PartialHPNSetController
    HP_nSet_Controller annotation (choicesAllMatching=true, Placement(
        transformation(extent={{102,82},{118,98}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,80})));
  Modelica.Blocks.Sources.Constant const_dT_loading1(k=distributionParameters.dTTra_nominal[1])
                                                          annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={14,58})));

  Modelica.Blocks.MathBoolean.Or
                             DHWHysOrLegionella(nu=4)
    "Use the HR if the HP reached its limit" annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-77,69})));
  AixLib.Controls.HeatPump.SafetyControls.SafetyControl securityControl(
    final minRunTime=safetyControl.minRunTime,
    final minLocTime=safetyControl.minLocTime,
    final maxRunPerHou=safetyControl.maxRunPerHou,
    final use_opeEnv=safetyControl.use_opeEnv,
    final use_opeEnvFroRec=false,
    final dataTable=AixLib.DataBase.HeatPump.EN14511.Vitocal200AWO201(
        tableUppBou=[-20,50; -10,60; 30,60; 35,55]),
    final tableUpp=safetyControl.tableUpp,
    final use_minRunTime=safetyControl.use_minRunTime,
    final use_minLocTime=safetyControl.use_minLocTime,
    final use_runPerHou=safetyControl.use_runPerHou,
    final dTHystOperEnv=safetyControl.dT_opeEnv,
    final use_deFro=false,
    final minIceFac=0,
    final use_chiller=false,
    final calcPel_deFro=0,
    final pre_n_start=safetyControl.pre_n_start_hp,
    use_antFre=false) annotation (Placement(transformation(
        extent={{-16,-17},{16,17}},
        rotation=0,
        origin={210,81})));
  Modelica.Blocks.Sources.BooleanConstant hp_mode(final k=true) annotation (
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={155,69})));

  Modelica.Blocks.Logical.Switch switchHR annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={43,25})));
  Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
        transformation(
        extent={{2,-2},{-2,2}},
        rotation=180,
        origin={24,10})));
  Modelica.Blocks.Math.Max max annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={24,38})));

  Modelica.Blocks.Math.Add add_dT_LoadingBuf
    annotation (Placement(transformation(extent={{38,54},{48,64}})));
  Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
         + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={14,74})));
  Modelica.Blocks.Math.Add add_dT_LoadingDHW
    annotation (Placement(transformation(extent={{36,78},{46,88}})));

  Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-50})));
  Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-22})));
  BESMod.Utilities.SupervisoryControl.SupervisoryControl supervisoryControlDHW(
      ctrlType=supCtrlTypeDHWSet)
    annotation (Placement(transformation(extent={{-182,72},{-170,84}})));
  parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory control for DHW Setpoint";
  Modelica.Blocks.Math.MinMax minMax(nu=transferParameters.nParallelDem)
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-170,-50})));
  Modelica.Blocks.Logical.Or HP_or_HR_active annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-170,-20})));
  Components.HeatPumpBusPassThrough heatPumpBusPassThrough annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-230,-90})));
equation
  connect(BufferOnOffController.T_Top, sigBusDistr.TStoBufTopMea) annotation (
      Line(points={{-118.8,45.6},{-118.8,46},{-124,46},{-124,-68},{1,-68},{1,-100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
        points={{-128.8,83.6},{-316,83.6},{-316,-166},{1,-166},{1,-100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heatingCurve.TSet, BufferOnOffController.T_Set) annotation (Line(
        points={{-139,30},{-110,30},{-110,31.2}},   color={0,0,127}));

  connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
        points={{-128.8,74},{-318,74},{-318,-166},{1,-166},{1,-100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HP_active.y, HP_nSet_Controller.HP_On) annotation (Line(points={{32.5,91},
          {32.5,100},{14,100},{14,84},{6,84},{6,50},{100.4,50},{100.4,90}},
                                        color={255,0,255}));
  connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
      points={{1,-100},{-2,-100},{-2,-152},{-292,-152},{-292,77.88},{-216,77.88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(DHWOnOffContoller.Auxilliar_Heater_On, HRactive.u[1]) annotation (
      Line(points={{-110.88,74},{-22,74},{-22,23.8333},{10,23.8333}}, color={
          255,0,255}));
  connect(BufferOnOffController.Auxilliar_Heater_On, HRactive.u[2]) annotation (
     Line(points={{-100.88,36},{-20,36},{-20,25},{10,25}},               color=
          {255,0,255}));
  connect(TSet_DHW.y, HRactive.u[3]) annotation (Line(points={{-190.8,71.04},{-96,
          71.04},{-96,26.1667},{10,26.1667}},                             color=
         {255,0,255}));

  connect(securityControl.modeSet, hp_mode.y) annotation (Line(points={{191.867,
          77.6},{168,77.6},{168,69},{162.7,69}}, color={255,0,255}));
  connect(securityControl.nOut, sigBusGen.yHeaPumSet) annotation (Line(
        points={{227.333,84.4},{264,84.4},{264,-132},{-42,-132},{-42,-99},{-152,
          -99}},                         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_nSet_Controller.n_Set, securityControl.nSet) annotation (Line(
        points={{118.8,90},{118.8,84.4},{191.867,84.4}},        color={0,0,127}));
  connect(BufferOnOffController.HP_On, HP_active.u2) annotation (Line(points={{-100.88,
          45.6},{-100.88,52},{21,52},{21,87}},   color={255,0,255}));
  connect(DHWOnOffContoller.HP_On, HP_active.u1) annotation (Line(points={{-110.88,
          83.6},{-32,83.6},{-32,91},{21,91}},    color={255,0,255}));
  connect(DHWHysOrLegionella.y, switch1.u2) annotation (Line(points={{-71.25,69},
          {-6.625,69},{-6.625,80},{58,80}},       color={255,0,255}));

  connect(TSet_DHW.y, DHWHysOrLegionella.u[1]) annotation (Line(points={{-190.8,
          71.04},{-96,71.04},{-96,67.6875},{-82,67.6875}},    color={255,0,255}));
  connect(DHWOnOffContoller.Auxilliar_Heater_On, DHWHysOrLegionella.u[2])
    annotation (Line(points={{-110.88,74},{-92,74},{-92,68.5625},{-82,68.5625}},
                                                                        color={
          255,0,255}));
  connect(DHWOnOffContoller.HP_On, DHWHysOrLegionella.u[3]) annotation (Line(
        points={{-110.88,83.6},{-90,83.6},{-90,69.4375},{-82,69.4375}},
        color={255,0,255}));
  connect(TSet_DHW.y, DHWHysOrLegionella.u[4]) annotation (Line(points={{-190.8,
          71.04},{-136.4,71.04},{-136.4,70.3125},{-82,70.3125}},
                                                               color={255,0,255}));
  connect(BufferOnOffController.T_bot, sigBusDistr.TStoBufTopMea) annotation (
      Line(points={{-118.8,36},{-120,36},{-120,46},{-124,46},{-124,-68},{1,-68},{
          1,-100}},            color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HRactive.y, switchHR.u2)
    annotation (Line(points={{20.75,25},{37,25}}, color={255,0,255}));
  connect(constZero.y, switchHR.u3) annotation (Line(points={{26.2,10},{28,10},{
          28,21},{37,21}}, color={0,0,127}));
  connect(max.y, switchHR.u1)
    annotation (Line(points={{28.4,38},{37,38},{37,29}}, color={0,0,127}));
  connect(BufferOnOffController.Auxilliar_Heater_set, max.u1) annotation (Line(
        points={{-100.88,33.12},{8,33.12},{8,35.6},{19.2,35.6}},     color={0,0,
          127}));
  connect(DHWOnOffContoller.Auxilliar_Heater_set, max.u2) annotation (Line(
        points={{-110.88,71.12},{-104,71.12},{-104,64},{-10,64},{-10,40.4},{19.2,
          40.4}}, color={0,0,127}));
  connect(switchHR.y, sigBusGen.uHeaRod) annotation (Line(points={{48.5,25},{62,25},
          {62,-48},{-152,-48},{-152,-99}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_nSet_Controller.IsOn, sigBusGen.heaPumIsOn) annotation (Line(
        points={{105.2,80.4},{105.2,48},{-32,48},{-32,-8},{-132,-8},{-132,-46},{
          -152,-46},{-152,-99}},                           color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(const_dT_loading2.y,add_dT_LoadingDHW. u2) annotation (Line(points={{18.4,74},
          {24,74},{24,80},{35,80}},                  color={0,0,127}));
  connect(switch1.y, HP_nSet_Controller.T_Set) annotation (Line(points={{81,80},{
          94,80},{94,94.8},{100.4,94.8}},   color={0,0,127}));
  connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{-139,30},
          {4,30},{4,66},{32,66},{32,62},{37,62}},
                                             color={0,0,127}));
  connect(add_dT_LoadingBuf.y, switch1.u3) annotation (Line(points={{48.5,59},{
          48.5,72},{58,72}},       color={0,0,127}));
  connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{46.5,83},{50,
          83},{50,88},{58,88}},          color={0,0,127}));
  connect(const_dT_loading1.y, add_dT_LoadingBuf.u2) annotation (Line(points={{
          18.4,58},{26,58},{26,56},{37,56}}, color={0,0,127}));
  connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-30,-61},
          {-30,-66},{1,-66},{1,-100}},            color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booleanToReal.u, bufOn.y) annotation (Line(points={{-30,-38},{-30,-33}},
                                       color={255,0,255}));
  connect(bufOn.u, DHWHysOrLegionella.y) annotation (Line(points={{-30,-10},{-30,
          69},{-71.25,69}},                 color={255,0,255}));
  connect(TSet_DHW.TSet_DHW, supervisoryControlDHW.uLoc) annotation (Line(
        points={{-190.8,78},{-188,78},{-188,73.2},{-183.2,73.2}}, color={0,0,
          127}));
  connect(supervisoryControlDHW.y, DHWOnOffContoller.T_Set) annotation (Line(
        points={{-168.8,78},{-150,78},{-150,74},{-122,74},{-122,69.2},{-120,69.2}},
                  color={0,0,127}));
  connect(supervisoryControlDHW.y, add_dT_LoadingDHW.u1) annotation (Line(
        points={{-168.8,78},{-150,78},{-150,76},{-10,76},{-10,86},{35,86}},
        color={0,0,127}));
  connect(supervisoryControlDHW.actInt, sigBusHyd.overwriteTSetDHW) annotation (
     Line(points={{-183.2,78},{-186,78},{-186,94},{-28,94},{-28,101}}, color={
          255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supervisoryControlDHW.uSup, sigBusHyd.TSetDHW) annotation (Line(
        points={{-183.2,82.8},{-183.2,92},{-28,92},{-28,101}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-162,30},{
          -166,30},{-166,24},{-238,24},{-238,2},{-237,2}},
                                        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(BufferOnOffController.T_oda, weaBus.TDryBul) annotation (Line(points={{-110,
          48.96},{-110,56},{-238,56},{-238,2},{-237,2}},                  color=
         {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-120,
          86.96},{-192,86.96},{-192,94},{-248,94},{-248,2},{-237,2}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(minMax.u, useProBus.TZoneSet) annotation (Line(points={{-200,40},{-244,
          40},{-244,104},{-119,104},{-119,103}},                   color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(minMax.yMax, heatingCurve.TSetRoom)
    annotation (Line(points={{-179,46},{-150,46},{-150,42}}, color={0,0,127}));
  connect(booleanToReal1.u, HP_or_HR_active.y)
    annotation (Line(points={{-170,-38},{-170,-31}}, color={255,0,255}));
  connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-170,-61},
          {-172,-61},{-172,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_or_HR_active.u1, HRactive.y) annotation (Line(points={{-170,-8},{
          -134,-8},{-134,-6},{-6,-6},{-6,16},{26,16},{26,26},{20.75,26},{20.75,25}},
                                                                      color={
          255,0,255}));
  connect(HP_or_HR_active.u2, sigBusGen.heaPumIsOn) annotation (Line(
        points={{-178,-8},{-194,-8},{-194,-99},{-152,-99}},   color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heatPumpBusPassThrough.sigBusGen, sigBusGen) annotation (Line(
      points={{-220,-90},{-200,-90},{-200,-80},{-180,-80},{-180,-72},{-152,-72},
          {-152,-99}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heatPumpBusPassThrough.vapourCompressionMachineControlBus,
    securityControl.sigBusHP) annotation (Line(
      points={{-240.2,-89.8},{-252,-89.8},{-252,-80},{72,-80},{72,-38},{192,-38},
          {192,69.27},{192,69.27}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(graphics={
        Rectangle(
          extent={{-240,100},{-50,60}},
          lineColor={238,46,47},
          lineThickness=1),
        Text(
          extent={{-234,94},{-140,128}},
          lineColor={238,46,47},
          lineThickness=1,
          textString="DHW Control"),
        Rectangle(
          extent={{-240,58},{-50,14}},
          lineColor={0,140,72},
          lineThickness=1),
        Text(
          extent={{-220,-12},{-126,22}},
          lineColor={0,140,72},
          lineThickness=1,
          textString="Buffer Control"),
        Rectangle(
          extent={{0,100},{132,52}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{4,122},{108,102}},
          lineColor={28,108,200},
          lineThickness=1,
          textString="Heat Pump Control"),
        Rectangle(
          extent={{0,46},{132,4}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{2,4},{106,-16}},
          lineColor={162,29,33},
          lineThickness=1,
          textString="Heating Rod Control"),
        Rectangle(
          extent={{138,100},{240,52}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{138,122},{242,102}},
          lineColor={28,108,200},
          lineThickness=1,
          textString="Heat Pump Safety")}));
end PartialHeatPumpSystemController;
