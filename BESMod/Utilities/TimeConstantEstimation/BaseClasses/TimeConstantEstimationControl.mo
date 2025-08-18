within BESMod.Utilities.TimeConstantEstimation.BaseClasses;
model TimeConstantEstimationControl
  "Control model to help time constant estimation"
  extends Systems.Hydraulical.Control.BaseClasses.PartialThermostaticValveControl(redeclare replaceable
      BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
      valCtrl);
  replaceable parameter
    Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition parPID
    "PID parameters for boiler" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{142,84},{162,104}})));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
    supTSet constrainedby
    Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.PartialSetpoint(
    final nZones=parTra.nParallelDem,
    final TSup_nominal=max(parTra.TTra_nominal),
    final TRet_nominal=max(parTra.TTra_nominal - parTra.dTTra_nominal),
    final TOda_nominal=parGen.TOda_nominal,
    final nHeaTra=parTra.nHeaTra) "Supply set temperature" annotation (Placement(
        transformation(extent={{-160,20},{-140,40}})), choicesAllMatching=true);
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
        transformation(extent={{42,22},{78,58}})));

  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=true)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{-102,-64},{-82,-44}})));
equation
  connect(supTSet.TOda, weaBus.TDryBul) annotation (Line(points={{-162,30},{-236.895,
          30},{-236.895,2.11}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  if useOpeTemCtrl then
    connect(supTSet.TZoneMea, buiMeaBus.TZoneOpeMea) annotation (Line(points={{-162,38},
            {-234,38},{-234,40},{-242,40},{-242,103},{65,103}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  else
    connect(supTSet.TZoneMea, buiMeaBus.TZoneMea) annotation (Line(points={{-162,38},
            {-234,38},{-234,40},{-242,40},{-242,103},{65,103}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

  end if;
  connect(supTSet.TZoneSet, useProBus.TZoneSet) annotation (Line(points={{-162,22},
          {-236,22},{-236,24},{-238,24},{-238,103},{-119,103}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(const.y, sigBusGen.uPump) annotation (Line(points={{-199,-50},{-152,-50},
          {-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(PIDCtrl.TMea, sigBusGen.TGenOutMea) annotation (Line(points={{60,18.4},{
          60,-26},{-152,-26},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(PIDCtrl.ySet, sigBusGen.uEleHea) annotation (Line(points={{79.8,40},{88,
          40},{88,-22},{-152,-22},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(booleanConstant.y, PIDCtrl.setOn) annotation (Line(points={{1,30},{18.5,
          30},{18.5,40},{38.4,40}}, color={255,0,255}));
  connect(booleanConstant.y, PIDCtrl.isOn) annotation (Line(points={{1,30},{18,30},
          {18,2},{49.2,2},{49.2,18.4}}, color={255,0,255}));
  connect(PIDCtrl.TSet, supTSet.TSet) annotation (Line(points={{38.4,50.8},{-112,50.8},
          {-112,30},{-139,30}}, color={0,0,127}));
  connect(const1.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-81,-54},
          {1,-54},{1,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TimeConstantEstimationControl;
