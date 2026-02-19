within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestOpenModelicaClean
  extends Modelica.Icons.Example;
  extends Systems.BaseClasses.PartialBESExample;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.16941387735728294;

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTZone(T=293.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,8})));
  IBPSA.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = IBPSA.Media.Water,
    each final p=200000,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-50})));
  Modelica.Blocks.Sources.Ramp ramp(each duration=100, each startTime=250)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,70})));
  IBPSA.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = IBPSA.Media.Water,
    m_flow=m_flow_nominal,
    T=328.15,
    nPorts=1) annotation (Placement(transformation(origin={-74,40}, extent={{-10,
            -10},{10,10}})));
  IBPSA.Fluid.FixedResistances.HydraulicDiameter res(
    redeclare package Medium = IBPSA.Media.Water "Water",
    final m_flow_nominal=m_flow_nominal,
    final dh=0.02,
    final length=100,
    final v_nominal=0.5,
    disableComputeFlowResistance=true)
    "Hydraulic resistance of supply and radiator to set dp allways to m_flow_nominal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-18,38})));
  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = IBPSA.Media.Water "Water",
    final m_flow_nominal=m_flow_nominal,
    final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=res.dp_nominal,
    final use_strokeTime=false,
    final dpFixed_nominal=res.dp_nominal,
    dp(start=val.dpFixed_nominal + val.dpValve_nominal))
                                        annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=270,
        origin={2,7})));
  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    final m_flow_nominal=m_flow_nominal,
    final nEle=5,
    final Q_flow_nominal=10000,
    final T_a_nominal=328.15,
    final T_b_nominal=318.15,
    final TAir_nominal=293.15,
    final TRad_nominal=293.15,
    final deltaM=0.3,
    final dp_nominal=0,
    redeclare package Medium = IBPSA.Media.Water "Water") "Radiator" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={2,-32})));
equation
  connect(res.port_b,val. port_a) annotation (Line(points={{-8,38},{2,38},{2,17}},
                     color={0,127,255}));
  connect(val.port_b,rad. port_a) annotation (Line(points={{2,-3},{2,-22}},
                                  color={0,127,255}));
  connect(ramp.y, val.y) annotation (Line(points={{-79,70},{18,70},{18,7},{15.2,
          7}}, color={0,0,127}));
  connect(fixTZone.port, rad.heatPortRad) annotation (Line(points={{60,8},{44,8},
          {44,-34},{9.2,-34}}, color={191,0,0}));
  connect(fixTZone.port, rad.heatPortCon) annotation (Line(points={{60,8},{24,8},
          {24,-22},{38,-22},{38,-2},{22,-2},{22,-30},{9.2,-30}}, color={191,0,0}));
  connect(boundary.ports[1], res.port_a) annotation (Line(points={{-64,40},{-32,
          40},{-32,38},{-28,38}}, color={0,127,255}));
  connect(bou1.ports[1], rad.port_b) annotation (Line(points={{-60,-50},{-32,-50},
          {-32,-52},{2,-52},{2,-42}}, color={0,127,255}));
  annotation(
    Documentation(info = "<html>
<p>This test sets the nominal zone and supply temperature to check if heat and mass flow rates as well as pressure drops are match the design conditions.</p>
</html>"));
end TestOpenModelicaClean;
