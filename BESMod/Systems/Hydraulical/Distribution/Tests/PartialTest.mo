within BESMod.Systems.Hydraulical.Distribution.Tests;
partial model PartialTest
  extends BESMod.Systems.BaseClasses.PartialBESExample;

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
    redeclare package MediumDHW = Medium,
    redeclare package MediumGen = Medium,
    mSup_flow_nominal=fill(0.317, distribution.nParallelSup),
    T_start=systemParameters.THydSup_nominal[1],
    mDem_flow_nominal=fill(0.317, distribution.nParallelDem))
                                   annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-50,-44},{24,28}})));

  Interfaces.DistributionControlBus
    sigBusDistr
    annotation (Placement(transformation(extent={{-38,60},{10,102}})));
  replaceable package Medium = IBPSA.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
  IBPSA.Fluid.Movers.FlowControlled_m_flow fanTra[distribution.nParallelDem](
    redeclare final package Medium = Medium,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final p_start=distribution.p_start,
    each final T_start=distribution.T_start,
    each final X_start=distribution.X_start,
    each final C_start=distribution.C_start,
    each final C_nominal=distribution.C_nominal,
    each final allowFlowReversal=distribution.allowFlowReversal,
    final m_flow_nominal=distribution.m_flow_nominal,
    each final show_T=distribution.show_T,
    redeclare final IBPSA.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    each final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    each final addPowerToMedium=false,
    each final nominalValuesDefineDefaultPressureCurve=true,
    each final tau=1,
    each final use_inputFilter=false,
    each final init=Modelica.Blocks.Types.Init.InitialOutput) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={62,8})));

  Modelica.Blocks.Sources.Sine m_flow[distribution.nParallelDem](
    each amplitude=0.1,
    each f=1/1800,
    each offset=0.2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={144,-10})));
  IBPSA.Fluid.Sources.Boundary_pT bouDHW(
    redeclare package Medium = IBPSA.Media.Water,
    final p=distribution.p_start,
    final T=distribution.T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={84,-22})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow fanDHW(
    redeclare final package Medium = Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
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
    final init=Modelica.Blocks.Types.Init.InitialOutput) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-42})));

  IBPSA.Fluid.Sources.Boundary_pT bouTra[distribution.nParallelDem](
    redeclare package Medium = IBPSA.Media.Water,
    each final p=distribution.p_start,
    each final T=distribution.T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={64,42})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow fanGen[distribution.nParallelSup](
    redeclare final package Medium = Medium,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final p_start=distribution.p_start,
    each final T_start=distribution.T_start,
    each final X_start=distribution.X_start,
    each final C_start=distribution.C_start,
    each final C_nominal=distribution.C_nominal,
    each final allowFlowReversal=distribution.allowFlowReversal,
    m_flow_nominal=fill(0.317, distribution.nParallelSup),
    each final show_T=distribution.show_T,
    redeclare final IBPSA.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    each final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    each final addPowerToMedium=false,
    each final nominalValuesDefineDefaultPressureCurve=true,
    each final tau=1,
    each final use_inputFilter=false,
    each final init=Modelica.Blocks.Types.Init.InitialOutput) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-82,14})));

  Modelica.Blocks.Sources.Constant constOn[distribution.nParallelSup](each final k=0.317)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-126,14})));
  IBPSA.Fluid.Sources.Boundary_pT bouTra1[distribution.nParallelSup](
    redeclare package Medium = IBPSA.Media.Water,
    each final p=distribution.p_start,
    each final T=distribution.T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-28})));
  IBPSA.Fluid.FixedResistances.PressureDrop res1[distribution.nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=1,
    final m_flow_nominal=distribution.m_flow_nominal)
    "Hydraulic resistance of supply" annotation (Placement(transformation(
        extent={{-6.5,-8},{6.5,8}},
        rotation=0,
        origin={45.5,24})));
equation
  connect(sigBusDistr, distribution.sigBusDistr) annotation (Line(
      points={{-14,81},{-14,38},{-13,38},{-13,28.36}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bouDHW.ports[1], fanDHW.port_a) annotation (Line(points={{74,-22},{74,
          -28},{66,-28},{66,-26},{60,-26},{60,-32}}, color={0,127,255}));
  connect(distribution.portDHW_out, fanDHW.port_a) annotation (Line(points={{24,
          -15.2},{24,-14},{60,-14},{60,-32}}, color={0,127,255}));
  connect(fanDHW.port_b, distribution.portDHW_in) annotation (Line(points={{60,-52},
          {60,-54},{32,-54},{32,-29.6},{24,-29.6}}, color={0,127,255}));
  connect(fanGen.port_b, distribution.portGen_in) annotation (Line(points={{-82,
          24},{-66,24},{-66,14},{-50,14},{-50,20.8}}, color={0,127,255}));
  connect(constOn.y, fanGen.m_flow_in)
    annotation (Line(points={{-115,14},{-94,14}}, color={0,0,127}));
  connect(fanTra.port_b, distribution.portBui_in) annotation (Line(points={{62,-2},
          {62,-4},{30,-4},{30,6.4},{24,6.4}}, color={0,127,255}));
  connect(fanGen.port_a, bouTra1.ports[1])
    annotation (Line(points={{-82,4},{-80,4},{-80,-18}}, color={0,127,255}));
  connect(distribution.portGen_out, fanGen.port_a) annotation (Line(points={{-50,
          6.4},{-68,6.4},{-68,-2},{-82,-2},{-82,4}}, color={0,127,255}));
  connect(m_flow[1].y, fanDHW.m_flow_in) annotation (Line(points={{133,-10},{114,
          -10},{114,-42},{72,-42}}, color={0,0,127}));
  connect(m_flow.y, fanTra.m_flow_in) annotation (Line(points={{133,-10},{116,-10},
          {116,-12},{78,-12},{78,8},{74,8}}, color={0,0,127}));
  connect(bouTra.ports[1], fanTra.port_a) annotation (Line(points={{64,32},{62,32},{62,18}}, color={0,127,255}));
  connect(distribution.portBui_out, res1.port_a) annotation (Line(points={{24,20.8},
          {32,20.8},{32,26},{39,26},{39,24}}, color={0,127,255}));
  connect(res1.port_b, fanTra.port_a) annotation (Line(points={{52,24},{56,24},{
          56,18},{62,18}}, color={0,127,255}));
  annotation (experiment(
      StopTime=864000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialTest;
