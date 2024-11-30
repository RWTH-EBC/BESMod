within BESMod.Systems.Hydraulical.Distribution.Tests;
partial model PartialTest
  extends BESMod.Systems.BaseClasses.PartialBESExample;
  replaceable package Medium = IBPSA.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
  replaceable BaseClasses.PartialDistribution distribution constrainedby
    BaseClasses.PartialDistribution(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=fill(sum(systemParameters.QBui_flow_nominal), distribution.nParallelDem),
    TOda_nominal=systemParameters.TOda_nominal,
    TDem_nominal=fill(systemParameters.THydSup_nominal[1], distribution.nParallelDem),
    TAmb=systemParameters.TAmbHyd,
    mDHW_flow_nominal=0.1,
    QDHW_flow_nominal=2000,
    TDHW_nominal=systemParameters.TSetDHW,
    VDHWDay=0.125,
    TDHWCold_nominal=systemParameters.TDHWWaterCold,
    mSup_flow_nominal=resGen.m_flow_nominal,
    mDem_flow_nominal=resTra.m_flow_nominal,
    dpSup_nominal=resGen.dp_nominal,
    dpDem_nominal=resTra.dp_nominal,
    tCrit=3600,
    QCrit=2,
    redeclare package MediumDHW = Medium,
    redeclare package MediumGen = Medium,
    T_start=systemParameters.THydSup_nominal[1])
                                   annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-38,-16},{18,38}})));
  IBPSA.Fluid.Sources.Boundary_pT bouDHW(
    redeclare package Medium = IBPSA.Media.Water,
    final p=distribution.p_start,
    final T=distribution.T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,10})));
  Interfaces.DistributionControlBus
    sigBusDistr
    annotation (Placement(transformation(extent={{-38,60},{10,102}})));
  Modelica.Blocks.Sources.Sine m_flow[distribution.nParallelDem](
    each amplitude=0.1,
    each f=1/1800,
    each offset=0.2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-30})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pumDHW(
    redeclare final package Medium = Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final p_start=distribution.p_start,
    final T_start=distribution.T_start,
    final X_start=distribution.X_start,
    final C_start=distribution.C_start,
    final C_nominal=distribution.C_nominal,
    final allowFlowReversal=distribution.allowFlowReversal,
    final m_flow_nominal=distribution.mDHW_flow_nominal,
    final show_T=distribution.show_T,
    redeclare final IBPSA.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final nominalValuesDefineDefaultPressureCurve=true,
    final tau=1,
    final use_inputFilter=false,
    final init=Modelica.Blocks.Types.Init.InitialOutput) "Emulate DHW system"
                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-10})));

  IBPSA.Fluid.FixedResistances.PressureDrop resTra[distribution.nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=2000,
    each final m_flow_nominal=1)
    "Hydraulic resistance of transfer" annotation (
     Placement(transformation(
        extent={{-9.5,-10},{9.5,10}},
        rotation=270,
        origin={50.5,30})));
  IBPSA.Fluid.FixedResistances.PressureDrop resGen[distribution.nParallelSup](
    redeclare package Medium = Medium,
    each final dp_nominal=10000,
    each final m_flow_nominal=1.5) "Hydraulic resistance of generation"
    annotation (Placement(transformation(
        extent={{-9.5,-10},{9.5,10}},
        rotation=90,
        origin={-69.5,30})));
  Modelica.Blocks.Sources.RealExpression deltaMTra_flow_nominal[distribution.nParallelDem](
     y=resTra.m_flow - resTra.m_flow_nominal)
    "Difference between trajectory and nominal mass flow rate in transfer"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.RealExpression deltaDPTra_nominal[distribution.nParallelDem](
     y=resTra.dp - resTra.dp_nominal)
    "Difference between trajectory and nominal pressure drop in transfer"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Sources.RealExpression deltaDPGen_nominal[distribution.nParallelSup](
     y=resGen.dp - resGen.dp_nominal)
    "Difference between trajectory and nominal pressure drop in generation"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Modelica.Blocks.Sources.RealExpression deltaMGen_flow_nominal[distribution.nParallelSup](
     y=resGen.m_flow - resGen.m_flow_nominal)
    "Difference between trajectory and nominal mass flow rate in generation"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
equation
  connect(sigBusDistr, distribution.sigBusDistr) annotation (Line(
      points={{-14,81},{-14,44},{-10,44},{-10,38.27}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(distribution.portDHW_out,pumDHW. port_a) annotation (Line(points={{18,5.6},
          {50,5.6},{50,0}},                   color={0,127,255}));
  connect(pumDHW.port_b, distribution.portDHW_in) annotation (Line(points={{50,-20},
          {50,-22},{28,-22},{28,-5.2},{18,-5.2}},   color={0,127,255}));
  connect(m_flow[1].y,pumDHW. m_flow_in) annotation (Line(points={{69,-30},{62,-30},
          {62,-10}},                color={0,0,127}));
  connect(distribution.portBui_out, resTra.port_a) annotation (Line(points={{18,
          32.6},{34,32.6},{34,39.5},{50.5,39.5}}, color={0,127,255}));
  connect(resTra.port_b, distribution.portBui_in) annotation (Line(points={{50.5,
          20.5},{50.5,18},{26,18},{26,21.8},{18,21.8}}, color={0,127,255}));
  connect(distribution.portGen_in, resGen.port_b) annotation (Line(points={{-38,
          32.6},{-50,32.6},{-50,52},{-69.5,52},{-69.5,39.5}}, color={0,127,255}));
  connect(distribution.portGen_out, resGen.port_a) annotation (Line(points={{-38,
          21.8},{-50,21.8},{-50,12},{-69.5,12},{-69.5,20.5}}, color={0,127,255}));
  connect(bouDHW.ports[1], pumDHW.port_a)
    annotation (Line(points={{70,10},{50,10},{50,0}}, color={0,127,255}));

  annotation (experiment(
      StopTime=3600,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialTest;
