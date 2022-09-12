within BESMod.Systems.Hydraulical.Distribution.Components.Valves.Tests;
model m_flow
  extends IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations(redeclare package
      Medium = IBPSA.Media.Water);
  extends Modelica.Icons.Example;
  parameter Boolean use_relVal=false;
  PressureReliefValve pressureReliefValve(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
      dpFullOpen_nominal=dpFullOpen_nominal) if use_relVal
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,0})));
  IBPSA.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,30})));
  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    each final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=0.5*dp_nominal/(1 - 0.5),
    each final use_inputFilter=false,
    final dpFixed_nominal=0)                                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=res.dp_nominal + val.dpValve_nominal + val.dpFixed_nominal,

      final rho(displayUnit="kg/m3") = 1,
      final V_flowCurve=pumpData.V_flowCurve,
      final dpCurve=pumpData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final use_inputFilter=false)                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,30})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.DefaultMover
    pumpData(V_flowCurve={0.000422526,0.28816252,0.580972823,0.868712818,
        0.94983775,1.086736074,1.190677393,1.396024878,1.499966198}, dpCurve={
        1.587002096,1.526205451,1.375262055,1.161425577,1.07966457,0.857442348,
        0.645702306,0.224318658,0})
             annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,76},
            {-72,98}})));
  Modelica.Blocks.Sources.Constant const(final k=m_flow_nominal)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-0.001,                  duration=1,
    offset=1,
    startTime=1)
    annotation (Placement(transformation(extent={{0,62},{20,82}})));
  IBPSA.Fluid.Sources.Boundary_pT bouPump(
    redeclare package Medium = Medium,
    each final p=p_start,
    each final T=T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,0})));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")=
    46536.58537/2
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.286666667
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpFullOpen_nominal=10000000
    "Pressure difference at which valve is fully open";
equation
  connect(res.port_b, val.port_a)
    annotation (Line(points={{20,30},{40,30}}, color={0,127,255}));
  connect(ramp.y, val.y)
    annotation (Line(points={{21,72},{50,72},{50,42}}, color={0,0,127}));
  connect(pump.port_b, pressureReliefValve.port_a)
    annotation (Line(points={{-40,30},{-20,30},{-20,10}}, color={0,127,255}));
  connect(pump.port_b, res.port_a)
    annotation (Line(points={{-40,30},{0,30}}, color={0,127,255}));
  connect(val.port_b, pump.port_a) annotation (Line(points={{60,30},{70,30},{70,
          -34},{-70,-34},{-70,30},{-60,30}}, color={0,127,255}));
  connect(pressureReliefValve.port_b, pump.port_a) annotation (Line(points={{-20,
          -10},{-20,-34},{-70,-34},{-70,30},{-60,30}}, color={0,127,255}));
  connect(bouPump.ports[1], pump.port_a) annotation (Line(points={{-80,0},{-70,0},
          {-70,30},{-60,30}}, color={0,127,255}));
  connect(const.y, pump.m_flow_in)
    annotation (Line(points={{-79,50},{-50,50},{-50,42}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3, __Dymola_Algorithm="Dassl"));
end m_flow;
