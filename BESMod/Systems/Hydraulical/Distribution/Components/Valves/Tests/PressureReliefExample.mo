within BESMod.Systems.Hydraulical.Distribution.Components.Valves.Tests;
model PressureReliefExample
  extends IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations(redeclare package
      Medium = IBPSA.Media.Water);
  extends Modelica.Icons.Example;
  parameter Boolean use_relVal=true;
  PressureReliefValve pressureReliefValve(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpFullOpen_nominal=dp_nominal*1.4,
    dpThreshold_nominal=dp_nominal*1.1,
    use_strokeTime=false,
    dpValve_nominal=dp_nominal)              if use_relVal
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,0})));
  IBPSA.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal/2,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,30})));
  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    each final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=dp_nominal/2,
    each final use_strokeTime=false,
    final dpFixed_nominal=0)                                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pump(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final use_riseTime=false,
    final y_start=1)                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,30})));
  replaceable parameter BESMod.Systems.RecordsCollection.Movers.DPVar parPum
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,
            82},{-80,98}})));
  Modelica.Blocks.Sources.Constant const(final k=1)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,                      duration=1,
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
    46536.58537
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.286666667
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpFullOpen_nominal=dp_nominal*
      10
    "Pressure difference at which valve is fully open";
  Modelica.Blocks.Sources.RealExpression dpPumpAbs(y=-pump.dp)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(res.port_b, val.port_a)
    annotation (Line(points={{20,30},{40,30}}, color={0,127,255}));
  connect(ramp.y, val.y)
    annotation (Line(points={{21,72},{50,72},{50,42}}, color={0,0,127}));
  connect(const.y, pump.y)
    annotation (Line(points={{-79,50},{-50,50},{-50,42}}, color={0,0,127}));
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3, __Dymola_Algorithm="Dassl"));
end PressureReliefExample;
