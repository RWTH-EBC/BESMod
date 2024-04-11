within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialHeatPumpSystemController
  "Partial model with replaceable blocks for rule based control of heat pump systems"
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.PartialThermostaticValveControl;
   parameter Components.BaseClasses.MeasuredValue meaValPriGen=BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.GenerationSupplyTemperature
    "Control measurement value for primary device"
    annotation (Dialog(group="Heat Pump"));
  parameter Components.BaseClasses.MeasuredValue meaValSecGen
    "Control measurement value for secondary device"
    annotation (Dialog(group="Backup heater"));
  parameter Modelica.Units.SI.TemperatureDifference dTHysBui=10
    "Hysteresis for building demand control"
    annotation (Dialog(group="Building control"));
  parameter Modelica.Units.SI.TemperatureDifference dTHysDHW=10
    "Hysteresis for DHW demand control" annotation (Dialog(group="DHW control"));

  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrHeaCurTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Heating curve supervisory control" annotation(Dialog(group="Building control"));
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Supervisory control approach for DHW supply temperature "
      annotation(Dialog(group="DHW control"));


  replaceable model BuildingHysteresis =
      BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController(
      final dTHys=dTHysBui)
    "Hysteresis for building" annotation (Dialog(group="Building control"),
    choicesAllMatching=true);
  replaceable model BuildingSupplySetTemperature =
      BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
      constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.PartialSetpoint(
        final TSup_nominal=buiAndDHWCtr.TSup_nominal,
        final TRet_nominal=buiAndDHWCtr.TRet_nominal,
        final TOda_nominal=buiAndDHWCtr.TOda_nominal,
        final nZones=buiAndDHWCtr.nZones,
        final nHeaTra=buiAndDHWCtr.nHeaTra)
      "Supply temperature setpoint model, e.g. heating curve"
    annotation (choicesAllMatching=true, Dialog(group="Building control"));
  replaceable model DHWSetTemperature =
      BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
     final TSetDHW_nominal=parDis.TDHW_nominal)
      "DHW set temperture module" annotation (Dialog(group="DHW control"),
      choicesAllMatching=true);
  replaceable model DHWHysteresis =
      BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses.PartialOnOffController(
      final dTHys=dTHysDHW)
    "Hysteresis for DHW system" annotation (Dialog(group="DHW control"),
    choicesAllMatching=true);
  replaceable model SummerMode =
   BESMod.Systems.Hydraulical.Control.Components.SummerMode.No
   constrainedby
    BESMod.Systems.Hydraulical.Control.Components.SummerMode.BaseClasses.PartialSummerMode
    "Summer mode model" annotation(Dialog(group="Building control"), choicesAllMatching=true);
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

  replaceable parameter BESMod.Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition
    parPIDHeaPum constrainedby
    BESMod.Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition
    "PID parameters of heat pump"
    annotation (choicesAllMatching=true,
                Dialog(group="Heat Pump"),
                Placement(transformation(extent={{100,40},{120,60}})));

  replaceable BESMod.Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
    safetyControl "Parameters for safety control of heat pump"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{204,84},
            {218,98}})), Dialog(group="Component data"));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.PID
    priGenPIDCtrl(
    final yMax=parPIDHeaPum.yMax,
    final yOff=parPIDHeaPum.yOff,
    final y_start=parPIDHeaPum.y_start,
    final yMin=parPIDHeaPum.yMin,
    final P=parPIDHeaPum.P,
    final timeInt=parPIDHeaPum.timeInt,
    final Ni=parPIDHeaPum.Ni,
    final timeDer=parPIDHeaPum.timeDer,
    final Nd=parPIDHeaPum.Nd)                                                                                                             constrainedby
    BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.BaseClasses.PartialControler
    "Control of heat pump" annotation (
    Dialog(group="Heat Pump", tab="Advanced"),
    choicesAllMatching=true,
    Placement(transformation(extent={{102,82},{118,98}})));

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

  Modelica.Blocks.Math.BooleanToReal booToRea(final realTrue=1, final realFalse=0)
                                              "Turn pump on if any device is on"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-150,-50})));
  Modelica.Blocks.MathBoolean.Or anyGenDevIsOn(nu=2)
    "True if any generation device is on and pump must run" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-150,-10})));
  Components.BaseClasses.HeatPumpBusPassThrough heaPumSigBusPasThr
    "Bus connector pass through for OpenModelica" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={170,64})));
  Components.BuildingAndDHWControl buiAndDHWCtr(
    final use_dhw=use_dhw,
    final nZones=parTra.nParallelDem,
    final TSup_nominal=max(parTra.TTra_nominal),
    final TRet_nominal=max(parTra.TTra_nominal .- parTra.dTTra_nominal),
    final TOda_nominal=parGen.TOda_nominal,
    final TSetDHW_nominal=parDis.TDHW_nominal,
    final nHeaTra=parTra.nHeaTra,
    final supCtrHeaCurTyp=supCtrHeaCurTyp,
    final supCtrDHWTyp=supCtrDHWTyp,
    redeclare final model SummerMode = SummerMode,
    redeclare final model DHWHysteresis = DHWHysteresis,
    redeclare final model BuildingHysteresis = BuildingHysteresis,
    redeclare final model DHWSetTemperature = DHWSetTemperature,
    final useExtSGSig=useExtSGSig,
    final TAddSta3Bui=TAddSta3Bui,
    final useSGReady=useSGReady,
    final TAddSta4Bui=TAddSta4Bui,
    final filNamSGReady=filNamSGReady,
    final TAddSta3DHW=TAddSta3DHW,
    final TAddSta4DHW=TAddSta4DHW)
    "Control for building and DHW system"
    annotation (Placement(transformation(extent={{-200,20},{-120,80}})));

  Components.BaseClasses.SetAndMeasuredValueSelector setAndMeaSelPri(
    final meaVal=meaValPriGen,
    final use_dhw=use_dhw,
    final dTTraToDis_nominal=parTra.dTLoss_nominal[1],
    final dTDisToGen_nominal=parDis.dTTra_nominal[1] + parGen.dTLoss_nominal[1],
    final dTDHWToGen_nominal=parDis.dTTraDHW_nominal,
    final dTHysDHW=dTHysDHW)
    "Selection of set and measured value for primary generation device"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Components.BaseClasses.SetAndMeasuredValueSelector setAndMeaSelSec(
    final meaVal=meaValSecGen,
    final use_dhw=use_dhw,
    final dTTraToDis_nominal=parTra.dTLoss_nominal[1],
    final dTDisToGen_nominal=parDis.dTTra_nominal[1] + parGen.dTLoss_nominal[1],
    final dTDHWToGen_nominal=parDis.dTTraDHW_nominal,
    final dTHysDHW=dTHysDHW)
    "Selection of set and measured value for secondary generation device"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

equation

  connect(safCtr.modeSet, heaPumHea.y) annotation (Line(points={{198.667,68},{
          186,68},{186,90},{181,90}},
                                  color={255,0,255}));
  connect(safCtr.nOut, sigBusGen.yHeaPumSet) annotation (Line(points={{220.833,
          72},{254,72},{254,-118},{-152,-118},{-152,-99}},
                                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(priGenPIDCtrl.ySet, safCtr.nSet) annotation (Line(points={{118.8,90},
          {154,90},{154,76},{190,76},{190,72},{198.667,72}},
                                                        color={0,0,127}));

  connect(priGenPIDCtrl.isOn, sigBusGen.heaPumIsOn) annotation (Line(points={{105.2,
          80.4},{105.2,78},{106,78},{106,48},{260,48},{260,-114},{-152,-114},{-152,
          -99}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booToRea.u, anyGenDevIsOn.y)
    annotation (Line(points={{-150,-38},{-150,-21.5}}, color={255,0,255}));
  connect(booToRea.y, sigBusGen.uPump) annotation (Line(points={{-150,-61},{-150,-70},
          {-152,-70},{-152,-99}},                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heaPumSigBusPasThr.sigBusGen, sigBusGen) annotation (Line(
      points={{160,64},{154,64},{154,-56},{0,-56},{0,-70},{-152,-70},{-152,-99}},
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
          -244,55},{-244,2.11},{-236.895,2.11}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.secGen, anyGenDevIsOn.u[1]) annotation (Line(points={{-118,
          37.5},{-118,36},{-112,36},{-112,6},{-151.75,6},{-151.75,0}},
        color={255,0,255}));
  connect(setAndMeaSelPri.DHW, buiAndDHWCtr.DHW) annotation (Line(points={{39,76},
          {28,76},{28,74},{-106,74},{-106,68},{-118,68}}, color={0,0,127}));
  connect(buiAndDHWCtr.TDHWSet, setAndMeaSelPri.TDHWSet) annotation (Line(points={
          {-118,75},{-118,74},{28,74},{28,78.8},{39,78.8}}, color={0,0,127}));
  connect(setAndMeaSelPri.TBuiSet, buiAndDHWCtr.TBuiSet) annotation (Line(points={
          {39,72.8},{38,72.8},{38,74},{-106,74},{-106,60},{-118,60}}, color={0,0,127}));
  connect(setAndMeaSelPri.TSet, priGenPIDCtrl.TSet) annotation (Line(points={{61,76},
          {94,76},{94,94.8},{100.4,94.8}}, color={0,0,127}));
  connect(setAndMeaSelPri.TMea, priGenPIDCtrl.TMea)
    annotation (Line(points={{61,66},{110,66},{110,80.4}}, color={0,0,127}));
  connect(setAndMeaSelPri.sigBusGen, sigBusGen) annotation (Line(
      points={{40,61.8},{20,61.8},{20,62},{0,62},{0,-99},{-152,-99}},
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
      points={{40,1.8},{40,2},{0,2},{0,-70},{-152,-70},{-152,-99}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(anyGenDevIsOn.u[2], sigBusGen.heaPumIsOn) annotation (Line(points={{-148.25,
          0},{-148,0},{-148,6},{-168,6},{-168,-99},{-152,-99}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    annotation (Dialog(group="SG Ready"),
                Dialog(group="SG Ready"),
              Diagram(graphics={
        Rectangle(
          extent={{4,100},{136,36}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{4,122},{108,102}},
          lineColor={28,108,200},
          lineThickness=1,
          textString="Heat Pump Control"),
        Rectangle(
          extent={{4,32},{136,-22}},
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
