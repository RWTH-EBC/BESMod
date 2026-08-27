within BESMod.Utilities.TimeConstantEstimation.BaseClasses;
model TestRadiatorEN442_2 "Test model for radiator"
  extends Modelica.Icons.Example;
 package Medium = IBPSA.Media.Water "Medium model";
  parameter Modelica.Units.SI.Temperature TRoo=20 + 273.15 "Room temperature"
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.Power Q_flow_nominal=500 "Nominal power";
  parameter Modelica.Units.SI.Temperature T_a_nominal=313.15
    "Radiator inlet temperature at nominal condition";
  parameter Modelica.Units.SI.Temperature T_b_nominal=303.15
    "Radiator outlet temperature at nominal condition";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=Q_flow_nominal/(
      T_a_nominal - T_b_nominal)/Medium.cp_const "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=3000
    "Pressure drop at m_flow_nominal";

  IBPSA.Fluid.Sources.Boundary_pT sou(
    use_T_in=true,
    nPorts=2,
    redeclare package Medium = Medium,
    use_p_in=true,
    T=T_a_nominal)
    annotation (Placement(transformation(extent={{-64,-68},{-44,-48}})));
  IBPSA.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  IBPSA.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{20,-2},{40,18}})));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 300000,
    T=T_b_nominal) "Sink"
    annotation (Placement(transformation(extent={{90,-68},{70,-48}})));

  RadiatorEN442_2 radDyn(
    redeclare package Medium = Medium,
    T_start=T_a_nominal,
    T_a_nominal=T_a_nominal,
    T_b_nominal=T_b_nominal,
    Q_flow_nominal=Q_flow_nominal,
    TAir_nominal=TRoo,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Radiator"
    annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  RadiatorEN442_2 radCon(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_a_nominal,
    use_dynamicFraRad=false,
    T_a_nominal=T_a_nominal,
    T_b_nominal=T_b_nominal,
    Q_flow_nominal=Q_flow_nominal,
    TAir_nominal=TRoo) "Radiator"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBCCon1(T=TRoo)
    annotation (Placement(transformation(extent={{-32,28},{-20,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBCCon2(T=TRoo)
    annotation (Placement(transformation(extent={{-32,-40},{-20,-28}})));
  Modelica.Blocks.Sources.Step step(
    startTime=3600,
    offset=300000 + dp_nominal,
    height=-dp_nominal)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBCRad2(T=TRoo)
    annotation (Placement(transformation(extent={{-32,-20},{-20,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBCRad1(T=TRoo)
    annotation (Placement(transformation(extent={{-32,48},{-20,60}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=3600,
    startTime=3600,
    offset=T_a_nominal,
    height=-(T_a_nominal - TRoo - 1))
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(sou.ports[1], radDyn.port_a) annotation (Line(points={{-44,-59},{-40,
          -59},{-40,8},{-10,8}}, color={0,127,255}));
  connect(sou.ports[2], radCon.port_a) annotation (Line(points={{-44,-57},{-28,
          -57},{-28,-60},{-10,-60}}, color={0,127,255}));
  connect(radDyn.port_b, res1.port_a)
    annotation (Line(points={{10,8},{20,8}}, color={0,127,255}));
  connect(radCon.port_b, res2.port_a)
    annotation (Line(points={{10,-60},{20,-60}}, color={0,127,255}));
  connect(res1.port_b, sin.ports[1]) annotation (Line(
      points={{40,8},{56,8},{56,-59},{70,-59}},
      color={0,127,255}));
  connect(res2.port_b, sin.ports[2]) annotation (Line(
      points={{40,-60},{56,-60},{56,-57},{70,-57}},
      color={0,127,255}));
  connect(step.y, sou.p_in) annotation (Line(
      points={{-79,-50},{-66,-50}},
      color={0,0,127}));
  connect(TBCRad2.port, radCon.heatPortRad)
    annotation (Line(points={{-20,-14},{2,-14},{2,-52.8}}, color={191,0,0}));
  connect(TBCRad1.port, radDyn.heatPortRad)
    annotation (Line(points={{-20,54},{2,54},{2,15.2}}, color={191,0,0}));
  connect(TBCCon2.port, radCon.heatPortCon)
    annotation (Line(points={{-20,-34},{-2,-34},{-2,-52.8}}, color={191,0,0}));
  connect(TBCCon1.port, radDyn.heatPortCon)
    annotation (Line(points={{-20,34},{-2,34},{-2,15.2}}, color={191,0,0}));
  connect(ramp.y, sou.T_in) annotation (Line(points={{-79,-90},{-76,-90},{-76,
          -54},{-66,-54}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/Radiators/Examples/RadiatorEN442_2.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=10800),
    Documentation(info="<html>
This test model compares the radiator model when
used as a steady-state and a dynamic model.
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
June 5, 2015 by Michael Wetter:<br/>
Removed <code>annotation(Evaluate=true)</code> from instances
<code>T_a_nominal</code> and <code>T_b_nominal</code>
to avoid the warning about non-literal nominal values.
This fixes
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/128\">#128</a>.
</li>
<li>
January 30, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TestRadiatorEN442_2;
