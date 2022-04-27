within BESMod.Utilities.KPIs.BaseClasses;
partial model PartialKPICalculator "Partial KPI Calculator"


  parameter String unit "Unit of signal";
  parameter String integralUnit "Unit of integral of signal";
  parameter Real thresholdOn=Modelica.Constants.eps * 100
    "If u is greater or equal to this treshhold the device is considered on.";
  parameter Real thresholdOff=0
    "If u is lower or equal to this treshhold, the device is considered off.";
  parameter Boolean calc_singleOnTime=true
                                      "True to calc singleOnTime";
  parameter Boolean calc_integral=true
                                  "True to calc integral";
  parameter Boolean calc_totalOnTime=true
                                     "True to calc totalOnTime";
  parameter Boolean calc_numSwi=true
                                "True to calc number of device on-switches";
  parameter Boolean calc_movAve=true
                                "True to calc moving average";
  parameter Boolean calc_intBelThres=true
                                "True to calc integral below threshold, e.g. for discomfort";
  parameter Modelica.SIunits.Time aveTime=24*3600
    "Time span for moving average" annotation (Dialog(enable=calc_movAve));
  Modelica.Blocks.Logical.Switch switch1 if calc_singleOnTime
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant const(k=1) if calc_singleOnTime
    annotation (Placement(transformation(extent={{6,14},{26,34}})));
  Modelica.Blocks.Sources.Constant const1(k=0) if calc_singleOnTime
    annotation (Placement(transformation(extent={{6,-28},{26,-8}})));
  Modelica.Blocks.Continuous.Integrator integrator3(use_reset=true, y(unit="s"))
 if calc_singleOnTime
    annotation (Placement(transformation(extent={{76,-6},{88,6}})));
  Modelica.Blocks.Logical.Hysteresis isOn(
    final uLow=thresholdOff,
    final uHigh=thresholdOn,
    final pre_y_start=false) if calc_numSwi or calc_singleOnTime or calc_totalOnTime
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Modelica.Blocks.Logical.Not not1 if calc_singleOnTime
    annotation (Placement(transformation(extent={{8,-70},{28,-50}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(final k=1)
 if calc_numSwi
    annotation (Placement(transformation(extent={{-48,136},{-32,152}})));
  Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd(final use_reset=false,
      final y_start=0) if calc_numSwi
    "To count on-off cycles"
    annotation (Placement(transformation(extent={{-16,134},{0,152}})));
  Modelica.Blocks.Logical.Switch switch3 if calc_totalOnTime
    annotation (Placement(transformation(extent={{40,78},{60,98}})));
  Modelica.Blocks.Sources.Constant const2(k=1) if calc_totalOnTime
    annotation (Placement(transformation(extent={{6,102},{26,122}})));
  Modelica.Blocks.Sources.Constant const3(k=0) if calc_totalOnTime
    annotation (Placement(transformation(extent={{6,60},{26,80}})));
  Modelica.Blocks.Continuous.Integrator integrator1(y(unit="s"))
                                                    if calc_totalOnTime
    annotation (Placement(transformation(extent={{76,82},{88,94}})));

  Modelica.Blocks.Continuous.Integrator integrator2(use_reset=false,
    y_start=Modelica.Constants.eps,                                  y(unit=
          integralUnit))
 if calc_integral
    annotation (Placement(transformation(extent={{72,-90},{84,-78}})));
  Icons.KPIBus KPIBus
    annotation (Placement(transformation(extent={{92,-10},{112,10}})));

  Modelica.Blocks.Routing.RealPassThrough internalU(y(unit=unit))
                                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-78,0})));
  AixLib.Utilities.Math.MovingAverage movingAverage(aveTime=aveTime, y(unit=
          unit))
 if calc_movAve
    annotation (Placement(transformation(extent={{-34,-168},{-14,-148}})));

  Modelica.Blocks.Continuous.Integrator integratorDiscomfort(final k=1,
                                                             use_reset=false,
    y(unit=integralUnit))
 if calc_intBelThres
    annotation (Placement(transformation(extent={{70,-28},{82,-16}})));
  Modelica.Blocks.Sources.Constant const4(k=thresholdOn)
 if calc_intBelThres
    annotation (Placement(transformation(extent={{-46,-54},{-26,-34}})));
  Modelica.Blocks.Math.Add         add(final k1=-1, final k2=+1)
                                                     if calc_intBelThres
    annotation (Placement(transformation(extent={{28,-48},{48,-28}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(final uMax=Modelica.Constants.inf,
      final uMin=0) if calc_intBelThres
    annotation (Placement(transformation(extent={{54,-44},{66,-32}})));
equation
  connect(switch1.u1, const.y) annotation (Line(points={{38,8},{32,8},{32,24},{
          27,24}},   color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{27,-18},{34,-18},{34,
          -8},{38,-8}},
                     color={0,0,127}));
  connect(switch1.y, integrator3.u)
    annotation (Line(points={{61,0},{74.8,0}},     color={0,0,127}));
  connect(isOn.y, switch1.u2)
    annotation (Line(points={{-29,0},{38,0}}, color={255,0,255}));
  connect(not1.y, integrator3.reset) annotation (Line(points={{29,-60},{86,-60},
          {86,-7.2},{85.6,-7.2}}, color={255,0,255}));
  connect(isOn.y, not1.u) annotation (Line(points={{-29,0},{-22,0},{-22,-60},{6,
          -60}}, color={255,0,255}));
  connect(integerConstant.y,triggeredAdd. u) annotation (Line(points={{-31.2,144},
          {-23.6,144},{-23.6,143},{-19.2,143}},
                                             color={255,127,0}));
  connect(switch3.u1, const2.y) annotation (Line(points={{38,96},{32,96},{32,112},
          {27,112}}, color={0,0,127}));
  connect(const3.y,switch3. u3) annotation (Line(points={{27,70},{34,70},{34,80},
          {38,80}},  color={0,0,127}));
  connect(switch3.y,integrator1. u)
    annotation (Line(points={{61,88},{74.8,88}},   color={0,0,127}));
  connect(integrator2.y, KPIBus.integral) annotation (Line(points={{84.6,-84},{102,
          -84},{102,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(triggeredAdd.y, KPIBus.numSwi) annotation (Line(points={{1.6,143},{102,
          143},{102,0}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(isOn.y, switch3.u2) annotation (Line(points={{-29,0},{-18,0},{-18,88},
          {38,88}}, color={255,0,255}));
  connect(isOn.y, triggeredAdd.trigger) annotation (Line(points={{-29,0},{-12.8,
          0},{-12.8,132.2}}, color={255,0,255}));
  connect(integrator3.y, KPIBus.singleOnTime) annotation (Line(points={{88.6,0},
          {102,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(integrator1.y, KPIBus.totalOnTime) annotation (Line(points={{88.6,88},
          {90,88},{90,0},{102,0}},             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(isOn.u, internalU.y)
    annotation (Line(points={{-52,0},{-67,0}}, color={0,0,127}));
  connect(internalU.y, integrator2.u)
    annotation (Line(points={{-67,0},{-62,0},{-62,-84},{70.8,-84}},
                                                            color={0,0,127}));
  connect(internalU.y, KPIBus.value) annotation (Line(points={{-67,0},{-62,0},{-62,
          -132},{102,-132},{102,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(internalU.y, movingAverage.u) annotation (Line(points={{-67,0},{-64,0},
          {-64,2},{-62,2},{-62,-158},{-36,-158}}, color={0,0,127}));
  connect(movingAverage.y, KPIBus.movAve) annotation (Line(points={{-13,-158},{102,
          -158},{102,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(internalU.y, add.u1) annotation (Line(points={{-67,0},{-62,0},{
          -62,-32},{26,-32}},           color={0,0,127}));
  connect(add.u2, const4.y)
    annotation (Line(points={{26,-44},{-25,-44}}, color={0,0,127}));
  connect(add.y, limiter.u)
    annotation (Line(points={{49,-38},{52.8,-38}}, color={0,0,127}));
  connect(limiter.y, integratorDiscomfort.u) annotation (Line(points={{66.6,-38},
          {68.8,-38},{68.8,-22}}, color={0,0,127}));
  connect(integratorDiscomfort.y, KPIBus.IntBelowThreshold) annotation (Line(
        points={{82.6,-22},{90,-22},{90,-24},{102,-24},{102,0}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},
            {100,180}}),                                        graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-62,52},{66,-68}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-100,-180},{100,180}})),
    Documentation(info="<html>
<p>Calculates a list of KPIs. Each KPI may be turned on or off. As integrators and Integer conversions are used, disabling KPIs may improve simulation speed. Nevertheless, most KPIs will be handy to understand and explain the BES behaviour better.</p>
<h4>Options</h4>
<ul>
<li>Calculate how long a device is turned in total (totalOnTime) and how long it&apos;s on for each on-cycle (singleOnTime)</li>
<li>Calculate how many times it is turned on (numSwi)</li>
<li>The integral</li>
<li>The moving average, useful for e.g. temperatures or COPs</li>
<li>The integral below a given threshold. This may be useful to estimate discomfort, seperate cooling and heating loads etc. (intBelowThreshold)</li>
</ul>
</html>"));
end PartialKPICalculator;
