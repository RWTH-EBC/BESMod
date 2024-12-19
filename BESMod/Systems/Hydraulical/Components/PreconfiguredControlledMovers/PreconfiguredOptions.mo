within BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers;
model PreconfiguredOptions
  "Examples for options using preconfigured models"
  extends Modelica.Icons.Example;
  package Medium = AixLib.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1.0
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_max=2*m_flow_nominal
    "To describe max point of mover's characteristic curve.";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000 "Nominal pressure raise, used to normalized the filter if use_riseTime=true,
        to set default values of constantHead and heads, and
        and for default pressure curve if not specified in record per";

  AixLib.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-96,-90},{-76,-70}})));

  AixLib.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.5*dp_nominal,
    y_start=rampValve.offset)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  PreconfiguredDPControlled pumDPConst(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpConst)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  AixLib.Fluid.FixedResistances.PressureDrop dp(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    dp_nominal=0.5*dp_nominal,
    from_dp=true) "Pressure drop" annotation (Placement(transformation(extent={{-52,-90},
            {-32,-70}})));

  Modelica.Blocks.Sources.Ramp rampValve(
    height=1,
    duration=1800,
    offset=0,
    startTime=900)  annotation (Placement(transformation(extent={{100,80},{80,100}})));

  Modelica.Blocks.Sources.BooleanPulse booStep(period=600) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,30})));
  PreconfiguredDPControlled pumDPVar(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  PreconfiguredDPControlled pumDPTotal(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpTotal)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  PreconfiguredDPControlled pumDPVarOnOff(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    externalCtrlTyp=PreconfiguredControlledMovers.Types.ExternalControlType.onOff,
    ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  PreconfiguredDPControlled pumSpeed(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    externalCtrlTyp=PreconfiguredControlledMovers.Types.ExternalControlType.speed)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Sources.Ramp rampSpeed(
    height=1,
    duration=1800,
    offset=0.5,
    startTime=900)
    annotation (Placement(transformation(extent={{32,80},{12,100}})));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.5*dp_nominal,
    y_start=rampValve.offset)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  AixLib.Fluid.FixedResistances.PressureDrop dp1(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    dp_nominal=0.5*dp_nominal,
    from_dp=true) "Pressure drop" annotation (Placement(transformation(extent={{-52,-60},
            {-32,-40}})));
  AixLib.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-96,-60},{-76,-40}})));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.5*dp_nominal,
    y_start=rampValve.offset)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  AixLib.Fluid.FixedResistances.PressureDrop dp2(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    dp_nominal=0.5*dp_nominal,
    from_dp=true) "Pressure drop" annotation (Placement(transformation(extent={{-52,-30},
            {-32,-10}})));
  AixLib.Fluid.Sources.Boundary_pT sou2(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-96,-30},{-76,-10}})));
  AixLib.Fluid.Sources.Boundary_pT sou3(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-96,0},{-76,20}})));
  AixLib.Fluid.FixedResistances.PressureDrop dp3(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    dp_nominal=0.5*dp_nominal,
    from_dp=true) "Pressure drop" annotation (Placement(transformation(extent={{-52,0},
            {-32,20}})));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.5*dp_nominal,
    y_start=rampValve.offset)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  AixLib.Fluid.Sources.Boundary_pT sou4(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-96,50},{-76,70}})));
  AixLib.Fluid.FixedResistances.PressureDrop dp4(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    dp_nominal=0.5*dp_nominal,
    from_dp=true) "Pressure drop" annotation (Placement(transformation(extent={{-52,50},
            {-32,70}})));
  AixLib.Fluid.Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.5*dp_nominal,
    y_start=rampValve.offset)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  AixLib.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-80})));
  AixLib.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-50})));
  AixLib.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-20})));
  AixLib.Fluid.Sources.Boundary_pT sin3(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,10})));
  AixLib.Fluid.Sources.Boundary_pT sin4(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,62})));
equation

  connect(pumDPConst.port_b, val.port_a)
    annotation (Line(points={{10,-80},{40,-80}}, color={0,127,255}));
  connect(sou.ports[1], dp.port_a) annotation (Line(points={{-76,-80},{-52,-80}},
                                                                                color={0,127,255}));
  connect(rampValve.y,val. y) annotation (Line(points={{79,90},{70,90},{70,-68},
          {50,-68}},                                                             color={0,0,127}));
  connect(dp.port_b, pumDPConst.port_a)
    annotation (Line(points={{-32,-80},{-10,-80}}, color={0,127,255}));
  connect(booStep.y, pumDPVarOnOff.on)
    annotation (Line(points={{-19,30},{-5,30},{-5,22}}, color={255,0,255}));
  connect(rampSpeed.y, pumSpeed.y)
    annotation (Line(points={{11,90},{0,90},{0,72}}, color={0,0,127}));
  connect(sou1.ports[1], dp1.port_a)
    annotation (Line(points={{-76,-50},{-52,-50}}, color={0,127,255}));
  connect(sou2.ports[1], dp2.port_a)
    annotation (Line(points={{-76,-20},{-52,-20}}, color={0,127,255}));
  connect(sou4.ports[1], dp4.port_a)
    annotation (Line(points={{-76,60},{-52,60}}, color={0,127,255}));
  connect(dp4.port_b, pumSpeed.port_a)
    annotation (Line(points={{-32,60},{-10,60}}, color={0,127,255}));
  connect(pumSpeed.port_b, val4.port_a)
    annotation (Line(points={{10,60},{40,60}}, color={0,127,255}));
  connect(sin.ports[1], val.port_b)
    annotation (Line(points={{80,-80},{60,-80}}, color={0,127,255}));
  connect(dp1.port_b, pumDPVar.port_a)
    annotation (Line(points={{-32,-50},{-10,-50}}, color={0,127,255}));
  connect(dp2.port_b, pumDPTotal.port_a)
    annotation (Line(points={{-32,-20},{-10,-20}}, color={0,127,255}));
  connect(dp3.port_b, pumDPVarOnOff.port_a)
    annotation (Line(points={{-32,10},{-10,10}}, color={0,127,255}));
  connect(sou3.ports[1], dp3.port_a)
    annotation (Line(points={{-76,10},{-52,10}}, color={0,127,255}));
  connect(pumDPVarOnOff.port_b, val3.port_a)
    annotation (Line(points={{10,10},{40,10}}, color={0,127,255}));
  connect(pumDPTotal.port_b, val2.port_a)
    annotation (Line(points={{10,-20},{40,-20}}, color={0,127,255}));
  connect(pumDPVar.port_b, val1.port_a)
    annotation (Line(points={{10,-50},{40,-50}}, color={0,127,255}));
  connect(val1.port_b, sin1.ports[1])
    annotation (Line(points={{60,-50},{80,-50}}, color={0,127,255}));
  connect(sin2.ports[1], val2.port_b)
    annotation (Line(points={{80,-20},{60,-20}}, color={0,127,255}));
  connect(val3.port_b, sin3.ports[1]) annotation (Line(points={{60,10},{70,10},{
          70,10},{80,10}}, color={0,127,255}));
  connect(val4.port_b, sin4.ports[1]) annotation (Line(points={{60,60},{62,60},{
          62,62},{80,62}}, color={0,127,255}));
  connect(rampValve.y, val1.y) annotation (Line(points={{79,90},{70,90},{70,-38},
          {50,-38}}, color={0,0,127}));
  connect(rampValve.y, val2.y) annotation (Line(points={{79,90},{70,90},{70,-8},
          {50,-8}}, color={0,0,127}));
  connect(rampValve.y, val3.y) annotation (Line(points={{79,90},{70,90},{70,32},
          {50,32},{50,22}}, color={0,0,127}));
  connect(rampValve.y, val4.y) annotation (Line(points={{79,90},{70,90},{70,82},
          {50,82},{50,72}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Components/PreconfiguredControlledMovers/PreconfiguredOptions.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06));
end PreconfiguredOptions;
