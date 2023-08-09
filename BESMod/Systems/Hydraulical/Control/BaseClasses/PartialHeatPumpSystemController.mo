within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialHeatPumpSystemController
  "Partial model with replaceable blocks for rule based control of heat pump systems"
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.PartialThermostaticValveControl;
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrHeaCurTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Heating curve supervisory control";
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Supervisory control approach for DHW supply temperature ";

  replaceable model DHWHysteresis =
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.ConstantHysteresisTimeBasedHR
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController
    "Hysteresis for DHW system" annotation (choicesAllMatching=true);
  replaceable model BuildingHysteresis =
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.ConstantHysteresisTimeBasedHR
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController
    "Hysteresis for building" annotation (choicesAllMatching=true);
  replaceable model DHWSetTemperature =
      BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
      final TSetDHW_nominal=distributionParameters.TDHW_nominal)
      "DHW set temperture module" annotation (choicesAllMatching=true);

  replaceable BESMod.Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
    safetyControl
    annotation (choicesAllMatching=true,Placement(transformation(extent={{204,84},
            {218,98}})));
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
    BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.BaseClasses.PartialHPNSetController
    HP_nSet_Controller annotation (choicesAllMatching=true, Placement(
        transformation(extent={{102,82},{118,98}})));

  AixLib.Controls.HeatPump.SafetyControls.SafetyControl safCtr(
    final minRunTime=safetyControl.minRunTime,
    final minLocTime=safetyControl.minLocTime,
    final maxRunPerHou=safetyControl.maxRunPerHou,
    final use_opeEnv=safetyControl.use_opeEnv,
    final use_opeEnvFroRec=false,
    final dataTable=AixLib.DataBase.HeatPump.EN14511.Vitocal200AWO201(tableUppBou=
         [-20,50; -10,60; 30,60; 35,55]),
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
    use_antFre=false) "Safety control" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={210,70})));
  Modelica.Blocks.Sources.BooleanConstant heaPumHea(final k=true)
    "Heat pump is always heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={170,90})));

  Modelica.Blocks.Math.BooleanToReal booToRea "Turn pump on if any device is on"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-170,-50})));
  Modelica.Blocks.MathBoolean.Or anyGenDevIsOn(nu=2)
    "True if any generation device is on and pump must run" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-170,-20})));
  Components.HeatPumpBusPassThrough heaPumSigBusPasThr
    "Bus connector pass through for OpenModelica" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={170,64})));
  Components.BuildingAndDHWControl buiAndDHWCtr(
    final nZones=transferParameters.nParallelDem,
    final TSup_nominal=max(transferParameters.TSup_nominal),
    final TRet_nominal=max(transferParameters.TSup_nominal - transferParameters.dTTra_nominal),
    final TOda_nominal=generationParameters.TOda_nominal,
    final TSetDHW_nominal=distributionParameters.TDHW_nominal,
    final nHeaTra=transferParameters.nHeaTra,
    final supCtrHeaCurTyp=supCtrHeaCurTyp,
    final supCtrDHWTyp=supCtrDHWTyp,
    redeclare final model DHWHysteresis = DHWHysteresis,
    redeclare final model BuildingHysteresis = BuildingHysteresis,
    redeclare final model DHWSetTemperature = DHWSetTemperature)
    "Control for building and DHW system"
    annotation (Placement(transformation(extent={{-200,20},{-120,80}})));

  Components.SetAndMeasuredValueSelector setAndMeaSelPri
    "Selection of set and measured value for primary generation device"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Components.SetAndMeasuredValueSelector setAndMeaSelSec
    "Selection of set and measured value for secondary generation device"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation

  connect(safCtr.modeSet, heaPumHea.y) annotation (Line(points={{198.667,68},{186,
          68},{186,90},{181,90}}, color={255,0,255}));
  connect(safCtr.nOut, sigBusGen.yHeaPumSet) annotation (Line(points={{220.833,72},
          {254,72},{254,-118},{-152,-118},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_nSet_Controller.n_Set, safCtr.nSet) annotation (Line(points={{118.8,
          90},{154,90},{154,76},{190,76},{190,72},{198.667,72}}, color={0,0,127}));

  connect(HP_nSet_Controller.IsOn, sigBusGen.heaPumIsOn) annotation (Line(
        points={{105.2,80.4},{105.2,78},{106,78},{106,48},{260,48},{260,-114},{-152,
          -114},{-152,-99}},                               color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booToRea.u, anyGenDevIsOn.y)
    annotation (Line(points={{-170,-38},{-170,-31.5}}, color={255,0,255}));
  connect(booToRea.y, sigBusGen.uPump) annotation (Line(points={{-170,-61},{-172,
          -61},{-172,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heaPumSigBusPasThr.sigBusGen, sigBusGen) annotation (Line(
      points={{160,64},{154,64},{154,-56},{-16,-56},{-16,-70},{-126,-70},{-126,
          -68},{-152,-68},{-152,-99}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heaPumSigBusPasThr.vapourCompressionMachineControlBus, safCtr.sigBusHP)
    annotation (Line(
      points={{180.2,64.2},{190,64.2},{190,63.1},{198.75,63.1}},
      color={255,204,51},
      thickness=0.5));
  connect(buiAndDHWCtr.TZoneSet, useProBus.TZoneSet) annotation (Line(points={{
          -204,35},{-238,35},{-238,103},{-119,103}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.TZoneMea, buiMeaBus.TZoneMea) annotation (Line(points={{
          -204,45},{-250,45},{-250,118},{64,118},{64,103},{65,103}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusDistr, buiAndDHWCtr.sigBusDistr) annotation (Line(
      points={{1,-100},{1,-116},{-250,-116},{-250,72.5},{-200,72.5}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.sigBusHyd, sigBusHyd) annotation (Line(
      points={{-185.6,80.25},{-185.6,112},{-186,112},{-186,118},{-28,118},{-28,
          101}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.TOda, weaBus.TDryBul) annotation (Line(points={{-204,55},{
          -244,55},{-244,2},{-237,2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.secGen, anyGenDevIsOn.u[1]) annotation (Line(points={{-118,
          37.5},{-110,37.5},{-110,6},{-168,6},{-168,-6},{-171.75,-6},{-171.75,-10}},
        color={255,0,255}));
  connect(buiAndDHWCtr.priGren, anyGenDevIsOn.u[2]) annotation (Line(points={{
          -118,27.5},{-110,27.5},{-110,6},{-168,6},{-168,-6},{-168.25,-6},{
          -168.25,-10}}, color={255,0,255}));
  connect(HP_nSet_Controller.HP_On, buiAndDHWCtr.priGren) annotation (Line(points={{100.4,
          90},{96,90},{96,40},{-80,40},{-80,27.5},{-118,27.5}},          color={
          255,0,255}));
  connect(setAndMeaSelPri.DHW, buiAndDHWCtr.DHW) annotation (Line(points={{39,76},
          {28,76},{28,74},{-106,74},{-106,68},{-118,68}}, color={0,0,127}));
  connect(buiAndDHWCtr.TDHWSet, setAndMeaSelPri.TDHWSet) annotation (Line(points={
          {-118,75},{-118,74},{28,74},{28,78.8},{39,78.8}}, color={0,0,127}));
  connect(setAndMeaSelPri.TBuiSet, buiAndDHWCtr.TBuiSet) annotation (Line(points={
          {39,72.8},{38,72.8},{38,74},{-106,74},{-106,60},{-118,60}}, color={0,0,127}));
  connect(setAndMeaSelPri.TSet, HP_nSet_Controller.T_Set) annotation (Line(points=
         {{61,76},{94,76},{94,94.8},{100.4,94.8}}, color={0,0,127}));
  connect(setAndMeaSelPri.TMea, HP_nSet_Controller.T_Meas)
    annotation (Line(points={{61,66},{110,66},{110,80.4}}, color={0,0,127}));
  connect(setAndMeaSelPri.sigBusGen, sigBusGen) annotation (Line(
      points={{40,61.8},{16,61.8},{16,62},{-68,62},{-68,-99},{-152,-99}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(setAndMeaSelPri.sigBusDistr, sigBusDistr) annotation (Line(
      points={{40,67.9},{14,67.9},{14,68},{1,68},{1,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(setAndMeaSelSec.TDHWSet, buiAndDHWCtr.TDHWSet) annotation (Line(points={
          {39,18.8},{34,18.8},{34,16},{-28,16},{-28,74},{-120,74},{-120,75},{-118,
          75}}, color={0,0,127}));
  connect(setAndMeaSelSec.TBuiSet, buiAndDHWCtr.TBuiSet) annotation (Line(points={
          {39,12.8},{4,12.8},{4,16},{-28,16},{-28,74},{-106,74},{-106,60},{-118,60}},
        color={0,0,127}));
  connect(setAndMeaSelSec.DHW, buiAndDHWCtr.DHW) annotation (Line(points={{39,16},
          {-28,16},{-28,74},{-106,74},{-106,68},{-118,68}}, color={255,0,255}));
  connect(setAndMeaSelSec.sigBusDistr, sigBusDistr) annotation (Line(
      points={{40,7.9},{40,6},{1,6},{1,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(setAndMeaSelSec.sigBusGen, sigBusGen) annotation (Line(
      points={{40,1.8},{40,-56},{-16,-56},{-16,-70},{-68,-70},{-68,-99},{-152,-99}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  annotation (Diagram(graphics={
        Rectangle(
          extent={{0,100},{132,36}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{4,122},{108,102}},
          lineColor={28,108,200},
          lineThickness=1,
          textString="Heat Pump Control"),
        Rectangle(
          extent={{0,32},{132,-22}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{2,-22},{106,-42}},
          lineColor={162,29,33},
          lineThickness=1,
          textString="Auxilliary Heater Control"),
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
