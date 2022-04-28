within BESMod.Components;
model HeatingRodWithSecurityControl
  "Heating rod which converts electrical energy into heat with a given efficiency"
  extends IBPSA.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final IBPSA.Fluid.MixingVolumes.MixingVolume vol(
      final m_flow_small=m_flow_small,
      final V=V,
    final prescribedHeatFlowRate=true));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Heat flow rate at u=1, positive for heating";
  parameter Modelica.Units.SI.Volume V=m_flow_nominal*tau/rho_default
    "Volume of heat exchanger";
  parameter Real eta      "Efficiency of the heating rod";

  // Count switches
  parameter Boolean use_countNumSwi=true
    "Turn the counting of the number of heating rod uses on or off."
    annotation (Dialog(tab="Advanced", group="Diagnostics"), choices(checkBox=true));
  Modelica.Blocks.Interfaces.RealInput u(unit="1",
    min=0,
    max=1)                                         "Control input"
    annotation (Placement(transformation(
          extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput Pel(unit="W")
    "Electrical power used to provide current heat flow"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Math.Gain gai_eta(final k=1/eta) "Divide efficiency"
    annotation (Placement(transformation(extent={{40,62},{60,82}})));

  Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd(final use_reset=false,
      final y_start=0) if use_countNumSwi
    "To count on-off cycles"
    annotation (Placement(transformation(extent={{68,-68},{86,-52}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(final k=1)
 if use_countNumSwi
    annotation (Placement(transformation(extent={{38,-68},{54,-52}})));
  Modelica.Blocks.Interfaces.IntegerOutput numSwi if use_countNumSwi
    "Number of on switches "
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{96,-62},{116,-42}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(final threshold=
        Modelica.Constants.eps) if use_countNumSwi
    annotation (Placement(transformation(extent={{38,-94},{54,-78}})));
  parameter Real m_flowTurnOff=m_flow_small
    "if m_flow smaller than this value, HR won't turn on";
  parameter Real m_flowTurnOn=m_flow_nominal*0.1
    "If m_flow is bigger than this value, HR may turn on";
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea(
    final alpha=0)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-36,50},{-16,70}})));
  Modelica.Blocks.Math.Gain gai(k=Q_flow_nominal) "Gain"
    annotation (Placement(transformation(extent={{-60,56},{-52,64}})));
  Modelica.Blocks.Logical.Switch
                            gai1 "Gain"
    annotation (Placement(transformation(extent={{-72,56},{-64,64}})));
  Modelica.Blocks.Logical.Hysteresis mFlowBigEnough(
    final uLow=m_flowTurnOff,
    final uHigh=m_flowTurnOn,
    final pre_y_start=false) "Check if m_flow is big enough"
    annotation (Placement(transformation(extent={{-86,56},{-78,64}})));
  Modelica.Blocks.Sources.Constant constZero(final k=0) "Turn device off"
    annotation (Placement(transformation(extent={{-86,44},{-78,52}})));
  Modelica.Blocks.Sources.RealExpression internal_mFlow(y=abs(port_a.m_flow))
    "Only used as no mass flow sensor is present"
    annotation (Placement(transformation(extent={{-98,50},{-90,58}})));
equation
  connect(gai.y, preHea.Q_flow) annotation (Line(
      points={{-51.6,60},{-36,60}},
      color={0,0,127}));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-16,60},{-9,60},{-9,-10}},
      color={191,0,0}));
  connect(gai.y, gai_eta.u) annotation (Line(points={{-51.6,60},{-42,60},{-42,
          72},{38,72}},
                    color={0,0,127}));
  connect(gai_eta.y, Pel) annotation (Line(points={{61,72},{88,72},{88,60},{110,
          60}}, color={0,0,127}));
  connect(triggeredAdd.y,numSwi)
    annotation (Line(points={{87.8,-60},{110,-60}},  color={255,127,0},
      pattern=LinePattern.Dash));
  connect(integerConstant.y,triggeredAdd. u) annotation (Line(points={{54.8,-60},
          {64.4,-60}},                           color={255,127,0},
      pattern=LinePattern.Dash));
  connect(greaterThreshold.y, triggeredAdd.trigger) annotation (Line(
      points={{54.8,-86},{71.6,-86},{71.6,-69.6}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(gai.u, gai1.y)
    annotation (Line(points={{-60.8,60},{-63.6,60}}, color={0,0,127}));
  connect(gai1.u2, mFlowBigEnough.y)
    annotation (Line(points={{-72.8,60},{-77.6,60}}, color={255,0,255}));
  connect(u, gai1.u1) annotation (Line(points={{-120,60},{-92,60},{-92,76},{-76,
          76},{-76,63.2},{-72.8,63.2}}, color={0,0,127}));
  connect(gai1.u3, constZero.y) annotation (Line(points={{-72.8,56.8},{-72.8,48},
          {-77.6,48}}, color={0,0,127}));
  connect(internal_mFlow.y, mFlowBigEnough.u) annotation (Line(points={{-89.6,
          54},{-89.6,56},{-86.8,56},{-86.8,60}}, color={0,0,127}));
  connect(gai1.y, greaterThreshold.u) annotation (Line(
      points={{-63.6,60},{-62,60},{-62,14},{-68,14},{-68,-86},{36.4,-86}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,8},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,-60},{70,60},{-70,60},{-70,-60}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-70,-60},{70,60},{70,-60},{-70,-60}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{70,60},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-18},{54,-78}},
          lineColor={255,255,255},
          textString="Q=%Q_flow_nominal"),
        Rectangle(
          extent={{-100,60},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          lineColor={0,0,127},
          textString="u"),
        Text(
          extent={{74,102},{118,74}},
          lineColor={0,0,127},
          textString="P_el"),
        Line(
          points={{-18,80},{-60,80},{-60,2},{-42,2}},
          color={0,0,0},
          thickness=1),
        Ellipse(
          extent={{-14,86},{-26,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,86},{14,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{22,80},{60,80},{60,0},{46,0}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-42,2},{-42,52},{-26,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-34,52},{-18,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-26,52},{-10,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-18,52},{-2,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-10,52},{6,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-2,52},{14,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{30,52},{46,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{22,52},{38,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{14,52},{30,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{6,52},{22,-36}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{46,0},{46,-34},{46,-34}},
          color={238,46,47},
          thickness=0.5)}),
defaultComponentName="hea",
Documentation(info="<html><p>
  Model for a heating rod.
</p>
<p>
  This model adds heat in the amount of <span style=
  \"font-family: Courier New;\">Q_flow = u Q_flow_nominal</span> to the
  medium. The input signal <span style=
  \"font-family: Courier New;\">u</span> and the nominal heat flow rate
  <span style=\"font-family: Courier New;\">Q_flow_nominal</span> can be
  positive or negative. A positive value of <span style=
  \"font-family: Courier New;\">Q_flow</span> means heating, and negative
  means cooling.
</p>
<p>
  The outlet conditions at <span style=
  \"font-family: Courier New;\">port_a</span> are not affected by this
  model, other than for a possible pressure difference due to flow
  friction.
</p>
<p>
  Optionally, this model can have a flow resistance. Set <span style=
  \"font-family: Courier New;\">dp_nominal = 0</span> to disable the flow
  friction calculation.
</p>
<p>
  For a model that uses as an input the fluid temperature leaving at
  <span style=\"font-family: Courier New;\">port_b</span>, use <a href=
  \"modelica://IBPSA.Fluid.HeatExchangers.PrescribedOutlet\">IBPSA.Fluid.HeatExchangers.PrescribedOutlet</a>
</p>
<p>
  As output, the electrical energy required to supply <span style=
  \"font-family: Courier New;\">Q_flow</span> is calculated using the
  efficiency which is a parameter of the model.
</p>
<p>
  Lastly, the number of times the heating rod switches on may be used
  as an output.
</p>
<h4>
  Limitations
</h4>
<p>
  This model does not affect the humidity of the air. Therefore, if
  used to cool air below the dew point temperature, the water mass
  fraction will not change.
</p>
<h4>
  Validation
</h4>
<p>
  The model has been validated against the analytical solution in the
  example <a href=
  \"modelica://IBPSA.Fluid.HeatExchangers.Validation.HeaterCooler_u\">IBPSA.Fluid.HeatExchangers.Validation.HeaterCooler_u</a>.
</p>
</html>",
revisions="<html><ul>
  <li>May 5, 2021, by Fabian Wuellhorst:<br/>
    Added model.<br/>
    This is for <a href=
    \"https://github.com/RWTH-EBC/IBPSA/issues/1092\">IBPSA, #1092</a>.
  </li>
</ul>
</html>"));
end HeatingRodWithSecurityControl;
