within BESMod.Systems.Hydraulical.Control;
model HybridHeatPumpSystem
  "Hybrid HPS with PID controlled boiler"
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.PartialHeatPumpSystemController(
      final meaValSecGen=if boiInGeneration then BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.GenerationSupplyTemperature
         else BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.DistributionTemperature);
  parameter Modelica.Units.SI.Temperature TBiv "Bivalence temperature";
  parameter Modelica.Units.SI.Temperature TCutOff "Cutoff temperature";
  parameter Boolean boiInGeneration
    "=true for boiler in generation system, false for distribution";
  replaceable parameter BESMod.Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition parPIDBoi
    constrainedby
    BESMod.Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition
    "PID parameters of boiler" annotation (
    choicesAllMatching=true,
    Dialog(group="Primary device control"),
    Placement(transformation(extent={{100,-20},{120,0}})));
  replaceable BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.PID boiPIDCtrl(
    final yMax=parPIDBoi.yMax,
    final yOff=parPIDBoi.yOff,
    final y_start=parPIDBoi.y_start,
    final yMin=parPIDBoi.yMin,
    final P=parPIDBoi.P,
    final timeInt=parPIDBoi.timeInt,
    final Ni=parPIDBoi.Ni,
    final timeDer=parPIDBoi.timeDer,
    final Nd=parPIDBoi.Nd)
     constrainedby
    BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.BaseClasses.PartialControler
    "PID control of boiler" annotation (choicesAllMatching=true,
      Dialog(group="Boiler control", tab="Advanced"), Placement(
        transformation(extent={{100,10},{120,28}})));

  Components.BoilerInHybridSystem boiInHybSys(final TBiv=TBiv, final TCutOff=
        TCutOff) "Check whether the boiler can turn on"
    annotation (Placement(transformation(extent={{-30,-20},{-12,0}})));

  BESMod.Systems.Hydraulical.Control.Components.BaseClasses.ParallelValveController
    priOrSecDevValCtrl
    "Control the valve to switch between primary and secondary device"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-190,-30})));
equation
  connect(boiInHybSys.secGen, buiAndDHWCtr.secGen) annotation (Line(points={{-31.8,
          -6},{-110,-6},{-110,34},{-118,34}},     color={255,0,255}));
  connect(boiInHybSys.secGenOn,boiPIDCtrl.setOn)  annotation (Line(points={{-9,-10},
          {76,-10},{76,19},{98,19}},
                                   color={255,0,255}));
  connect(boiInHybSys.secGenOn,boiPIDCtrl.isOn)
    annotation (Line(points={{-9,-10},{76,-10},{76,4},{104,4},{104,8.2}},
                                                             color={255,0,255}));
  if boiInGeneration then
    connect(boiPIDCtrl.ySet, sigBusGen.yBoi) annotation (Line(points={{121,19},{188,
            19},{188,10},{256,10},{256,-110},{-152,-110},{-152,-99}},color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
  else
    connect(boiPIDCtrl.ySet, sigBusDistr.yBoi) annotation (Line(points={{121,19},{
            256,19},{256,-120},{1,-120},{1,-100}},
                                              color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
  end if;
  connect(boiPIDCtrl.TMea, setAndMeaSelSec.TMea) annotation (Line(points={{110,8.2},
          {110,6},{61,6}},                 color={0,0,127}));
  connect(boiPIDCtrl.TSet, setAndMeaSelSec.TSet) annotation (Line(points={{98,24.4},
          {96,24.4},{96,16},{61,16}}, color={0,0,127}));
  connect(boiInHybSys.priGenIsOn, sigBusGen.heaPumIsOn) annotation (Line(points={{
          -31.8,-16},{-54,-16},{-54,-70},{-152,-70},{-152,-99}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(boiInHybSys.priGenSetOn, buiAndDHWCtr.priGren) annotation (Line(points={{-32,
          -12.4},{-72,-12.4},{-72,-12},{-110,-12},{-110,26},{-118,26},{-118,
          27.3333}},
        color={255,0,255}));
  connect(boiInHybSys.TOda, weaBus.TDryBul) annotation (Line(points={{-32,-2},{-236.895,
          -2},{-236.895,2.11}},
                         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(boiInHybSys.ySetPriGen, sigBusGen.yHeaPumSet) annotation (Line(points={{
          -32,-9},{-54,-9},{-54,-70},{-152,-70},{-152,-99}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(priOrSecDevValCtrl.secGen, boiInHybSys.secGenOn) annotation (Line(
        points={{-184,-18},{-184,12},{-2,12},{-2,-10},{-9,-10}}, color={255,0,255}));
  connect(priOrSecDevValCtrl.priGen, buiAndDHWCtr.priGren) annotation (Line(
        points={{-196,-18},{-196,12},{-112,12},{-112,26},{-118,26},{-118,
          27.3333}},
        color={255,0,255}));
  connect(priOrSecDevValCtrl.uThrWayVal, sigBusGen.uPriOrSecGen) annotation (Line(
        points={{-190,-41},{-190,-70},{-152,-70},{-152,-99}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiAndDHWCtr.priGren, priGenPIDCtrl.setOn) annotation (Line(points={{-118,
          27.3333},{-118,26},{74,26},{74,74},{96,74},{96,90},{80.4,90}},
        color={255,0,255}));
  connect(anyGenDevIsOn.y, sigBusDistr.pumGenOn) annotation (Line(points={{-150,
          -21.5},{-150,-70},{1,-70},{1,-100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
end HybridHeatPumpSystem;
