within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialTwoPoint_HPS_Controller
  "Partial model with replaceable blocks for rule based control of HPS using on off heating rods"
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController
    DHWOnOffContoller annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-128,70},{-112,86}})));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController
    BufferOnOffController annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-126,36},{-110,50}})));
  replaceable BESMod.Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
    safetyControl
    annotation (choicesAllMatching=true,Placement(transformation(extent={{200,30},{220,50}})));
  replaceable parameter RecordsCollection.BivalentHeatPumpControlDataDefinition
    bivalentControlData constrainedby
    RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-92,-32},{-70,-10}})));
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
        transformation(extent={{82,64},{112,92}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=0,
        origin={63,73})));
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
  Modelica.Blocks.Sources.Constant hp_iceFac(final k=1) annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-181,-85})));

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
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-38,-36})));
  Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-37,-17})));
  BESMod.Utilities.SupervisoryControl.SupervisoryControl supervisoryControlDHW(
      ctrlType=supCtrlTypeDHWSet)
    annotation (Placement(transformation(extent={{-182,72},{-170,84}})));
  parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory control for DHW Setpoint";
  Modelica.Blocks.Math.MinMax minMax(nu=transferParameters.nParallelDem)
    annotation (Placement(transformation(extent={{-202,32},{-182,52}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-170,-54})));
  Modelica.Blocks.Logical.Or HP_or_HR_active annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-170,-24})));
equation
  connect(BufferOnOffController.T_Top, sigBusDistr.TStoBufTopMea) annotation (
      Line(points={{-126.8,47.9},{-128,47.9},{-128,48},{-130,48},{-130,-86},{4,-86},
          {4,-100},{1,-100}},
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
        points={{-139,30},{-139,28},{-118,28},{-118,35.3}},
                                                    color={0,0,127}));

  connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
        points={{-128.8,74},{-318,74},{-318,-166},{1,-166},{1,-100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HP_active.y, HP_nSet_Controller.HP_On) annotation (Line(points={{32.5,
          91},{70,91},{70,78},{79,78}}, color={255,0,255}));
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
     Line(points={{-108.88,39.5},{-94,39.5},{-94,25},{10,25}},           color=
          {255,0,255}));
  connect(TSet_DHW.y, HRactive.u[3]) annotation (Line(points={{-190.8,71.04},{
          -96,71.04},{-96,26.1667},{10,26.1667}},                         color=
         {255,0,255}));
  connect(securityControl.sigBusHP, sigBusGen.hp_bus) annotation (Line(
      points={{192,69.27},{180,69.27},{180,70},{184,70},{184,-54},{-152,-54},{-152,
          -99}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(securityControl.modeOut, sigBusGen.hp_bus.modeSet)
    annotation (Line(points={{227.333,77.6},{268,77.6},{268,-136},{-152,-136},{
          -152,-99}},                        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(securityControl.modeSet, hp_mode.y) annotation (Line(points={{191.867,
          77.6},{168,77.6},{168,69},{162.7,69}}, color={255,0,255}));
  connect(securityControl.nOut, sigBusGen.hp_bus.nSet) annotation (Line(
        points={{227.333,84.4},{264,84.4},{264,-132},{-42,-132},{-42,-99},{-152,
          -99}},                         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hp_iceFac.y, sigBusGen.hp_bus.iceFacMea) annotation (Line(
        points={{-173.3,-85},{-156.65,-85},{-156.65,-99},{-152,-99}},
                      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_nSet_Controller.n_Set, securityControl.nSet) annotation (Line(
        points={{113.5,78},{144,78},{144,84.4},{191.867,84.4}}, color={0,0,127}));
  connect(BufferOnOffController.HP_On, HP_active.u2) annotation (Line(points={{-108.88,
          47.9},{-78,47.9},{-78,54},{-38,54},{-38,87},{21,87}},
                                                 color={255,0,255}));
  connect(DHWOnOffContoller.HP_On, HP_active.u1) annotation (Line(points={{-110.88,
          83.6},{-32,83.6},{-32,91},{21,91}},    color={255,0,255}));
  connect(DHWHysOrLegionella.y, switch1.u2) annotation (Line(points={{-71.25,69},
          {-20,69},{-20,73},{57,73}},             color={255,0,255}));

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
      Line(points={{-126.8,39.5},{-130,39.5},{-130,-86},{134,-86},{134,-100},{1,
          -100}},              color={0,0,127}), Text(
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
        points={{-108.88,36.98},{-84,36.98},{-84,35.6},{19.2,35.6}}, color={0,0,
          127}));
  connect(DHWOnOffContoller.Auxilliar_Heater_set, max.u2) annotation (Line(
        points={{-110.88,71.12},{-104,71.12},{-104,64},{-10,64},{-10,40.4},{19.2,
          40.4}}, color={0,0,127}));
  connect(switchHR.y, sigBusGen.hr_on) annotation (Line(points={{48.5,25},{62,25},
          {62,-48},{-152,-48},{-152,-99}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_nSet_Controller.IsOn, sigBusGen.hp_bus.onOffMea) annotation (Line(
        points={{88,61.2},{88,-58},{-152,-58},{-152,-99}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(const_dT_loading2.y,add_dT_LoadingDHW. u2) annotation (Line(points={{18.4,74},
          {24,74},{24,80},{35,80}},                  color={0,0,127}));
  connect(switch1.y, HP_nSet_Controller.T_Set) annotation (Line(points={{68.5,
          73},{70,73},{70,86.4},{79,86.4}}, color={0,0,127}));
  connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{-139,30},
          {-139,28},{4,28},{4,66},{32,66},{32,62},{37,62}},
                                             color={0,0,127}));
  connect(add_dT_LoadingBuf.y, switch1.u3) annotation (Line(points={{48.5,59},{
          54,59},{54,69},{57,69}}, color={0,0,127}));
  connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{46.5,83},{
          51.25,83},{51.25,77},{57,77}}, color={0,0,127}));
  connect(const_dT_loading1.y, add_dT_LoadingBuf.u2) annotation (Line(points={{
          18.4,58},{26,58},{26,56},{37,56}}, color={0,0,127}));
  connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
          -38,-42.6},{-38,-62},{1,-62},{1,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booleanToReal.u, bufOn.y) annotation (Line(points={{-38,-28.8},{-38,
          -26},{-37,-26},{-37,-22.5}}, color={255,0,255}));
  connect(bufOn.u, DHWHysOrLegionella.y) annotation (Line(points={{-37,-11},{
          -37,70},{-71.25,70},{-71.25,69}}, color={255,0,255}));
  connect(TSet_DHW.TSet_DHW, supervisoryControlDHW.uLoc) annotation (Line(
        points={{-190.8,78},{-188,78},{-188,73.2},{-183.2,73.2}}, color={0,0,
          127}));
  connect(supervisoryControlDHW.y, DHWOnOffContoller.T_Set) annotation (Line(
        points={{-168.8,78},{-150,78},{-150,74},{-122,74},{-122,69.2},{-120,69.2}},
                  color={0,0,127}));
  connect(supervisoryControlDHW.y, add_dT_LoadingDHW.u1) annotation (Line(
        points={{-168.8,78},{-150,78},{-150,76},{-10,76},{-10,86},{35,86}},
        color={0,0,127}));
  connect(supervisoryControlDHW.activateInt, sigBusHyd.overwriteTSetDHW)
    annotation (Line(points={{-183.2,78},{-186,78},{-186,94},{-28,94},{-28,101}},
        color={255,0,255}), Text(
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
  connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-162,30},
          {-236,30},{-236,2},{-237,2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(BufferOnOffController.T_oda, weaBus.TDryBul) annotation (Line(points={
          {-118,50.84},{-118,58},{-236,58},{-236,30},{-237,30},{-237,2}}, color=
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
  connect(minMax.u, useProBus.TZoneSet) annotation (Line(points={{-202,42},{-206,
          42},{-206,52},{-208,52},{-208,60},{-119,60},{-119,103}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(minMax.yMax, heatingCurve.TSetRoom)
    annotation (Line(points={{-181,48},{-150,48},{-150,42}}, color={0,0,127}));
  connect(booleanToReal1.u, HP_or_HR_active.y)
    annotation (Line(points={{-170,-42},{-170,-35}}, color={255,0,255}));
  connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-170,-65},
          {-172,-65},{-172,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_or_HR_active.u1, HRactive.y) annotation (Line(points={{-170,-12},{
          -134,-12},{-134,-6},{-6,-6},{-6,18},{20.75,18},{20.75,25}}, color={
          255,0,255}));
  connect(HP_or_HR_active.u2, sigBusGen.hp_bus.onOffMea) annotation (Line(
        points={{-178,-12},{-194,-12},{-194,-99},{-152,-99}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
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
          extent={{-216,-14},{-122,20}},
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
end PartialTwoPoint_HPS_Controller;
