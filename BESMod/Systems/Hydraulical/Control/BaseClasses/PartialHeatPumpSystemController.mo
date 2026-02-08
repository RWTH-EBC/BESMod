within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialHeatPumpSystemController
  "Partial model with replaceable blocks for rule based control of heat pump systems"
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.PartialThermostaticValveControl;
   parameter Components.BaseClasses.MeasuredValue meaValPriGen=BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.GenerationSupplyTemperature
    "Control measurement value for primary device"
    annotation (Dialog(group="Heat Pump"));
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlNSetTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory control for compressor speed"
    annotation (Dialog(group="Heat Pump"));
  parameter Components.BaseClasses.MeasuredValue meaValSecGen
    "Control measurement value for secondary device"
    annotation (Dialog(group="Backup heater"));
  parameter Modelica.Units.SI.TemperatureDifference dTHysBui=10
    "Hysteresis for building demand control"
    annotation (Dialog(group="Building control"));
  parameter Modelica.Units.SI.TemperatureDifference dTHysDHW=10
    "Hysteresis for DHW demand control" annotation (Dialog(group="DHW control"));
  parameter Boolean pumGenAlwOn=false
    "=true to let the generation pump run always. May be used for external control."
    annotation(Dialog(tab="Advanced"));
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrHeaCurTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Heating curve supervisory control" annotation(Dialog(group="Building control"));
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Supervisory control approach for DHW supply temperature "
      annotation(Dialog(group="DHW control"));
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlThrWayValTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory control for three way valve"
    annotation (Dialog(group="DHW control"));

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
  parameter Boolean withSolThePumCtrl=false
    "=true to enable solar thermal pump control"
    annotation (Dialog(group="Solar Thermal"));
  parameter Modelica.Units.SI.HeatFlux thrToTurSolTheOn=100
    "Threshold global radiation to turn on solar thermal pump"
    annotation (Dialog(group="Solar Thermal", enable=withSolThePumCtrl));
  parameter Boolean use_opeEncControl=false
    "Use operational envelope limit control"
    annotation (Dialog(tab="Operational Envelope Control"));
  parameter Modelica.Units.SI.Temperature tabUppHea[:,2]=[233.15,373.15; 333.15,373.15]
    "Upper temperature boundary for heating with second column as useful temperature side"
    annotation (Dialog(tab="Operational Envelope Control", enable=use_opeEncControl));
  parameter Modelica.Units.SI.TemperatureDifference dTOpeEnv=2 "Extra temperature difference until limit when bivalent device is turned on"
  annotation (Dialog(tab="Operational Envelope Control", enable=use_opeEncControl));
  replaceable parameter BESMod.Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition
    parPIDHeaPum constrainedby
    BESMod.Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition
    "PID parameters of heat pump"
    annotation (choicesAllMatching=true,
                Dialog(group="Heat Pump"),
                Placement(transformation(extent={{80,40},{100,60}})));

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
    Dialog(group="Heat Pump"),
    choicesAllMatching=true,
    Placement(transformation(extent={{82,82},{98,98}})));

  Modelica.Blocks.MathBoolean.Or anyGenDevIsOn(nu=3)
    "True if any generation device is on and pump must run" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-150,-10})));
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
    final supCtrlThrWayValTyp=supCtrlThrWayValTyp,
    redeclare final model SummerMode = SummerMode,
    redeclare final model DHWHysteresis = DHWHysteresis,
    redeclare final model BuildingHysteresis = BuildingHysteresis,
    redeclare final model DHWSetTemperature = DHWSetTemperature,
    redeclare final model BuildingSupplySetTemperature =
        BuildingSupplySetTemperature,
    final useExtSGSig=useExtSGSig,
    final TAddSta3Bui=TAddSta3Bui,
    final useSGReady=useSGReady,
    final TAddSta4Bui=TAddSta4Bui,
    final filNamSGReady=filNamSGReady,
    final TAddSta3DHW=TAddSta3DHW,
    final TAddSta4DHW=TAddSta4DHW) "Control for building and DHW system"
    annotation (Placement(transformation(extent={{-200,20},{-120,80}})));

  Components.BaseClasses.SetAndMeasuredValueSelector setAndMeaSelPri(
    final meaVal=meaValPriGen,
    final use_dhw=use_dhw,
    final dTTraToDis_nominal=parTra.dTLoss_nominal[1],
    final dTDisToGen_nominal=parDis.dTTra_nominal[1] + parGen.dTLoss_nominal[1],
    final dTDHWToGen_nominal=parDis.dTTraDHW_nominal,
    final dTHysDHW=dTHysDHW,
    final use_opeEncControl=use_opeEncControl,
    final tabUppHea=tabUppHea)
    "Selection of set and measured value for primary generation device"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Components.BaseClasses.SetAndMeasuredValueSelector setAndMeaSelSec(
    final meaVal=meaValSecGen,
    final use_dhw=use_dhw,
    final dTTraToDis_nominal=parTra.dTLoss_nominal[1],
    final dTDisToGen_nominal=parDis.dTTra_nominal[1] + parGen.dTLoss_nominal[1],
    final dTDHWToGen_nominal=parDis.dTTraDHW_nominal,
    final dTHysDHW=dTHysDHW,
    final use_opeEncControl=false,
    final tabUppHea=[233.15,373.15; 333.15,373.15])
    "Selection of set and measured value for secondary generation device"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  BESMod.Utilities.SupervisoryControl.SupervisoryControl supCtrNSet(final ctrlType=
        supCtrlNSetTyp) "Supervisory control of compressor speed"
    annotation (Placement(transformation(extent={{110,80},{130,100}})));

  Modelica.Blocks.Logical.Hysteresis solThePumOn(uLow=thrToTurSolTheOn/2, uHigh
      =thrToTurSolTheOn) if withSolThePumCtrl
    "True to turn on solar thermal pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-210,-50})));
  Modelica.Blocks.Logical.Or secGenOn "True if secondary device should turn on"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,30})));
  Modelica.Blocks.Sources.BooleanConstant noOpeEnvLimCtrl(final k=false)
    if not use_opeEncControl "Always false for bivalent control override"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={30,50})));
  Modelica.Blocks.Sources.BooleanConstant conPumGenAlwOn(final k=pumGenAlwOn)
    "Pump generation is always on" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-192,-12})));

equation

  connect(priGenPIDCtrl.isOn, sigBusGen.heaPumIsOn) annotation (Line(points={{85.2,
          80.4},{85.2,62},{66,62},{66,-99},{-152,-99}},
                 color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.TZoneSet, useProBus.TZoneSet) annotation (Line(points={{-204,
          32.3333},{-238,32.3333},{-238,103},{-119,103}},
                                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.TZoneMea, buiMeaBus.TZoneMea) annotation (Line(points={{-204,39},
          {-250,39},{-250,118},{64,118},{64,103},{65,103}},          color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusDistr, buiAndDHWCtr.sigBusDistr) annotation (Line(
      points={{1,-100},{1,-116},{-250,-116},{-250,57.3333},{-200,57.3333}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.sigBusHyd, sigBusHyd) annotation (Line(
      points={{-159.6,79.5},{-159.6,112},{-186,112},{-186,118},{-28,118},{-28,101}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.TOda, weaBus.TDryBul) annotation (Line(points={{-204,
          45.6667},{-244,45.6667},{-244,2.11},{-236.895,2.11}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(setAndMeaSelPri.DHW, buiAndDHWCtr.DHW) annotation (Line(points={{39,76},
          {28,76},{28,74},{-106,74},{-106,54.3333},{-118,54.3333}},
                                                          color={0,0,127}));
  connect(buiAndDHWCtr.TDHWSet, setAndMeaSelPri.TDHWSet) annotation (Line(points={{-118,59},
          {-118,74},{28,74},{28,78.8},{39,78.8}},           color={0,0,127}));
  connect(setAndMeaSelPri.TBuiSet, buiAndDHWCtr.TBuiSet) annotation (Line(points={{39,72.8},
          {38,72.8},{38,74},{-106,74},{-106,49},{-118,49}},           color={0,0,127}));
  connect(setAndMeaSelPri.TSet, priGenPIDCtrl.TSet) annotation (Line(points={{61,76},
          {80.4,76},{80.4,94.8}},          color={0,0,127}));
  connect(setAndMeaSelPri.TMea, priGenPIDCtrl.TMea)
    annotation (Line(points={{61,66},{90,66},{90,80.4}},   color={0,0,127}));
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
  connect(setAndMeaSelSec.TDHWSet, buiAndDHWCtr.TDHWSet) annotation (Line(points={{39,18.8},
          {34,18.8},{34,16},{-28,16},{-28,74},{-120,74},{-120,59},{-118,59}},
                color={0,0,127}));
  connect(setAndMeaSelSec.TBuiSet, buiAndDHWCtr.TBuiSet) annotation (Line(points={{39,12.8},
          {4,12.8},{4,16},{-28,16},{-28,74},{-106,74},{-106,49},{-118,49}},
        color={0,0,127}));
  connect(setAndMeaSelSec.DHW, buiAndDHWCtr.DHW) annotation (Line(points={{39,16},
          {-28,16},{-28,74},{-106,74},{-106,54.3333},{-118,54.3333}},
                                                            color={255,0,255}));
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

  connect(supCtrNSet.y, sigBusGen.yHeaPumSet) annotation (Line(points={{132,90},
          {252,90},{252,-124},{-152,-124},{-152,-99}},           color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(supCtrNSet.uLoc, priGenPIDCtrl.ySet) annotation (Line(points={{108,82},
          {104,82},{104,90},{98.8,90}}, color={0,0,127}));
  connect(buiAndDHWCtr.priGren, anyGenDevIsOn.u[1]) annotation (Line(points={{-118,
          27.3333},{-112,27.3333},{-112,4},{-152.333,4},{-152.333,0}},
                                                                    color={255,
          0,255}));
  connect(anyGenDevIsOn.y, sigBusDistr.pumGenOn) annotation (Line(points={{-150,
          -21.5},{-150,-70},{1,-70},{1,-100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(solThePumOn.u, weaBus.HGloHor) annotation (Line(points={{-210,-38},{-210,
          2.11},{-236.895,2.11}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(solThePumOn.y, sigBusDistr.pumGenOnSec) annotation (Line(points={{-210,
          -61},{-210,-70},{1,-70},{1,-100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(setAndMeaSelPri.TEvaIn, sigBusGen.THeaPumEvaIn) annotation (Line(
        points={{39,70},{-100,70},{-100,-78},{-152,-78},{-152,-99}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(setAndMeaSelPri.bivOn, secGenOn.u1) annotation (Line(points={{61,72},{
          64,72},{64,50},{-96,50},{-96,30},{-92,30}}, color={255,0,255}));
  connect(buiAndDHWCtr.secGen, secGenOn.u2) annotation (Line(points={{-118,34},{
          -108,34},{-108,22},{-92,22}}, color={255,0,255}));
  connect(secGenOn.y, anyGenDevIsOn.u[2]) annotation (Line(points={{-69,30},{-62,
          30},{-62,12},{-150,12},{-150,0}},       color={255,0,255}));
  connect(noOpeEnvLimCtrl.y, secGenOn.u1) annotation (Line(points={{19,50},{-96,
          50},{-96,30},{-92,30}}, color={255,0,255}));
  connect(conPumGenAlwOn.y, anyGenDevIsOn.u[3]) annotation (Line(points={{-181,
          -12},{-166,-12},{-166,6},{-152,6},{-152,0},{-147.667,0}},
                                                               color={255,0,255}));
                                                              annotation (Diagram(graphics={
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
          textString="Auxilliary Heater Control")}));
end PartialHeatPumpSystemController;
