within BESMod.Utilities.KPIs;
model DeviceKPICalculator "KPI useful for the analysis of a device"
  extends BaseClasses.KPIIcon;
  parameter Boolean use_reaInp=false "=true to use a real input";
  parameter Real thrOn=Modelica.Constants.eps*100
    "If uRea is greater or equal to this treshhold the device is on"
    annotation(Dialog(enable=use_reaInp));
  parameter Real thrOff=Modelica.Constants.eps
    "If uRea is lower or equal to this treshhold, the device is off"
    annotation(Dialog(enable=use_reaInp));
  parameter Boolean calc_singleOnTime=true
    "True to calc singleOnTime";
  parameter Boolean calc_totalOnTime=true
    "True to calc totalOnTime";
  parameter Boolean calc_numSwi=true
    "True to calc number of device on-switches";
  Modelica.Blocks.Logical.Hysteresis isOn(
    final uLow=thrOff,
    final uHigh=thrOn,
    final pre_y_start=false) if use_reaInp
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

  Modelica.Blocks.Logical.Switch switch1 if calc_singleOnTime
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant const(k=1) if calc_singleOnTime
    annotation (Placement(transformation(extent={{-42,10},{-22,30}})));
  Modelica.Blocks.Sources.Constant const1(k=0) if calc_singleOnTime
    annotation (Placement(transformation(extent={{-42,-30},{-22,-10}})));
  Modelica.Blocks.Continuous.Integrator integrator3(use_reset=true, y(unit="s")) if
    calc_singleOnTime
    annotation (Placement(transformation(extent={{26,-40},{46,-20}})));
  Modelica.Blocks.Logical.Not not1 if calc_singleOnTime
    annotation (Placement(transformation(extent={{-34,-60},{-14,-40}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(final k=1) if
    calc_numSwi
    annotation (Placement(transformation(extent={{-34,60},{-14,80}})));
  Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd(final use_reset=false,
      final y_start=0) if calc_numSwi
    "To count on-off cycles"
    annotation (Placement(transformation(extent={{6,60},{26,80}})));
  Modelica.Blocks.Continuous.Integrator integrator1(y(unit="s")) if
                                                       calc_totalOnTime
    annotation (Placement(transformation(extent={{26,20},{46,40}})));
  BaseClasses.KPIDevice KPI
    annotation (Placement(transformation(extent={{102,-20},{142,20}}),
        iconTransformation(extent={{102,-20},{142,20}})));
  Modelica.Blocks.Interfaces.BooleanInput u if not use_reaInp
    "=true if device is on"
    annotation (Placement(transformation(extent={{-142,-20},{-102,20}}),
        iconTransformation(extent={{-142,-20},{-102,20}})));
  Modelica.Blocks.Interfaces.RealInput uRea if use_reaInp "Real input"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-142,-20},{-102,20}})));
equation
  connect(switch1.u1,const. y) annotation (Line(points={{-12,8},{-14,8},{-14,20},
          {-21,20}}, color={0,0,127}));
  connect(const1.y,switch1. u3) annotation (Line(points={{-21,-20},{-10,-20},{-10,
          -8},{-12,-8}},
                     color={0,0,127}));
  connect(switch1.y,integrator3. u)
    annotation (Line(points={{11,0},{18,0},{18,-30},{24,-30}},
                                                   color={0,0,127}));
  connect(not1.y,integrator3. reset) annotation (Line(points={{-13,-50},{42,-50},
          {42,-42}},              color={255,0,255}));
  connect(integerConstant.y,triggeredAdd. u) annotation (Line(points={{-13,70},{
          2,70}},                            color={255,127,0}));
  connect(triggeredAdd.y, KPI.numSwi) annotation (Line(points={{28,70},{70,70},{
          70,0.1},{122.1,0.1}},
                          color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(integrator1.y, KPI.totOnTim) annotation (Line(points={{47,30},{70,30},
          {70,0.1},{122.1,0.1}},
                           color={0,0,127}));
  connect(integrator3.y, KPI.sinOnTim) annotation (Line(points={{47,-30},{70,-30},
          {70,0.1},{122.1,0.1}},
                           color={0,0,127}));
  connect(switch1.y,integrator1. u)
    annotation (Line(points={{11,0},{16,0},{16,30},{24,30}}, color={0,0,127}));
  connect(not1.u, u) annotation (Line(points={{-36,-50},{-48,-50},{-48,0},{-122,
          0}}, color={255,0,255}));
  connect(u, switch1.u2)
    annotation (Line(points={{-122,0},{-12,0}}, color={255,0,255}));
  connect(triggeredAdd.trigger, u) annotation (Line(points={{10,58},{10,52},{-48,
          52},{-48,0},{-122,0}}, color={255,0,255}));
  connect(isOn.y, switch1.u2) annotation (Line(points={{-69,20},{-62,20},{-62,0},
          {-12,0}}, color={255,0,255}));
  connect(isOn.y, not1.u) annotation (Line(points={{-69,20},{-62,20},{-62,-50},{
          -36,-50}}, color={255,0,255}));
  connect(isOn.y, triggeredAdd.trigger) annotation (Line(points={{-69,20},{-60,20},
          {-60,54},{10,54},{10,58}}, color={255,0,255}));
  connect(uRea, isOn.u)
    annotation (Line(points={{-120,20},{-92,20}}, color={0,0,127}));
    annotation(Dialog(enable=use_reaInp),
               Dialog(enable=use_reaInp),
              Documentation(info="<html>
<p>Calculates a list of KPIs relevant for the operation of a device. </p>
<p>Each KPI may be turned on or off. </p>
<p>As integrators and Integer conversions are used, disabling KPIs may improve simulation speed. </p>
<p>Nevertheless, most KPIs will be handy to understand and explain the BES behaviour better.</p>
<h4>Options</h4>
<ul>
<li>Calculate how long a device is turned in total (totalOnTime) </li>
<li>and how long it&apos;s on for each on-cycle (singleOnTime)</li>
<li>Calculate how many times it is turned on (numSwi)</li>
</ul>
</html>"));
end DeviceKPICalculator;
