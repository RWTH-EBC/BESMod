within BESMod.Systems.Hydraulical.Distribution.Tests.BaseClasses;
partial model PartialTest
  extends BESMod.Systems.BaseClasses.PartialBESExample(systemParameters(final
        nZones=1));

  parameter Modelica.Units.SI.TemperatureDifference dTDem_nominal = 15
    "Temperature difference to design dummy demand system";
  parameter Modelica.Units.SI.TemperatureDifference dTSup_nominal = 10
    "Temperature difference to design dummy supply system";

  replaceable package Medium = IBPSA.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);

  replaceable
    .BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDistribution distribution
    constrainedby
    .BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDistribution(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=fill(sum(systemParameters.QBui_flow_nominal), distribution.nParallelDem),
    TOda_nominal=systemParameters.TOda_nominal,
    TDem_nominal=fill(systemParameters.THydSup_nominal[1], distribution.nParallelDem),
    TAmb=systemParameters.TAmbHyd,
    mDemOld_flow_design=resTra.m_flow_nominal,
    dpDemOld_design=resTra.dp_nominal,
    mSupOld_flow_design=resGen.m_flow_nominal,
    dpSupOld_design=resGen.dp_nominal,
    mDHW_flow_nominal=0.1,
    QDHW_flow_nominal=2000,
    TDHW_nominal=systemParameters.TSetDHW,
    VDHWDayAt60=0.125,
    TDHWCold_nominal=systemParameters.TDHWWaterCold,
    mSup_flow_nominal=resGen.m_flow_nominal,
    mDem_flow_nominal=resTra.m_flow_nominal,
    dpSup_nominal=resGen.dp_nominal,
    dpDem_nominal=resTra.dp_nominal,
    tCrit=3600,
    QCrit=2,
    redeclare package MediumDHW = Medium,
    redeclare package MediumGen = Medium,
    T_start=systemParameters.THydSup_nominal[1]) annotation (choicesAllMatching
      =true, Placement(transformation(extent={{-36,-16},{20,38}})));

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
    annotation (Placement(transformation(extent={{-24,58},{24,100}})));
  Modelica.Blocks.Sources.Sine m_flow[distribution.nParallelDem](
    each amplitude=0.1,
    each f=1/1800,
    each offset=0.1) annotation (Placement(transformation(
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
    final use_riseTime=false,
    final init=Modelica.Blocks.Types.Init.InitialOutput) "Emulate DHW system"
                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-10})));

  IBPSA.Fluid.FixedResistances.PressureDrop resTra[distribution.nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=2000,
    final m_flow_nominal=fill(sum(distribution.Q_flow_design)/dTDem_nominal/4184,
        distribution.nParallelSup))
    "Hydraulic resistance of transfer" annotation (
     Placement(transformation(
        extent={{-9.5,-10},{9.5,10}},
        rotation=0,
        origin={50.5,40})));
  IBPSA.Fluid.FixedResistances.PressureDrop resGen[distribution.nParallelSup](
    redeclare package Medium = Medium,
    each final dp_nominal=2000,
    final m_flow_nominal=fill(sum(distribution.Q_flow_design)/dTSup_nominal/4184,
        distribution.nParallelSup))
                                   "Hydraulic resistance of generation"
    annotation (Placement(transformation(
        extent={{-9.5,-10},{9.5,10}},
        rotation=180,
        origin={-69.5,-30})));
  Modelica.Blocks.Sources.Pulse        pulse(period=600)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTSup[distribution.nParallelSup]
    (                                                                                       T=
        distribution.TSup_nominal)
    "Fixed supply temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  IBPSA.Fluid.MixingVolumes.MixingVolume volSup[distribution.nParallelSup](
    redeclare final package Medium = IBPSA.Media.Water,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    each final massDynamics=distribution.massDynamics,
    each final p_start=distribution.p_start,
    each T_start=distribution.T_start,
    each final X_start=distribution.X_start,
    each final C_start=distribution.C_start,
    each final C_nominal=distribution.C_nominal,
    each final mSenFac=distribution.mSenFac,
    final m_flow_nominal=resGen.m_flow_nominal,
    final m_flow_small=1E-4*abs(resGen.m_flow_nominal),
    each final allowFlowReversal=distribution.allowFlowReversal,
    each V=1e-6*sum(systemParameters.QBui_flow_nominal),
    each final use_C_flow=false,
    each final nPorts=2) "Fix the temperature of the supply system" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,10})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTDemRet[
    distribution.nParallelDem](T=distribution.TDem_nominal .- dTDem_nominal)
    "Fixed supply temperature"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  IBPSA.Fluid.MixingVolumes.MixingVolume volDem[distribution.nParallelDem](
    redeclare final package Medium = IBPSA.Media.Water,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    each final massDynamics=distribution.massDynamics,
    each final p_start=distribution.p_start,
    each T_start=distribution.T_start,
    each final X_start=distribution.X_start,
    each final C_start=distribution.C_start,
    each final C_nominal=distribution.C_nominal,
    each final mSenFac=distribution.mSenFac,
    final m_flow_nominal=resTra.m_flow_nominal,
    final m_flow_small=1E-4*abs(resTra.m_flow_nominal),
    each final allowFlowReversal=distribution.allowFlowReversal,
    each V=15e-6*sum(systemParameters.QBui_flow_nominal),
    each final use_C_flow=false,
    each final nPorts=2) "Fix the temperature of the demand system" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,60})));
  Modelica.Blocks.Sources.BooleanConstant
                                       booleanConstant
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,50})));
equation
  connect(sigBusDistr, distribution.sigBusDistr) annotation (Line(
      points={{0,79},{0,46},{-8,46},{-8,38.27}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(distribution.portDHW_out,pumDHW. port_a) annotation (Line(points={{20,5.6},
          {50,5.6},{50,0}},                   color={0,127,255}));
  connect(pumDHW.port_b, distribution.portDHW_in) annotation (Line(points={{50,-20},
          {50,-22},{28,-22},{28,-5.2},{20,-5.2}},   color={0,127,255}));
  connect(m_flow[1].y,pumDHW. m_flow_in) annotation (Line(points={{69,-30},{66,
          -30},{66,-10},{62,-10}},  color={0,0,127}));
  connect(distribution.portBui_out, resTra.port_a) annotation (Line(points={{20,32.6},
          {36,32.6},{36,40},{41,40}},             color={0,127,255}));
  connect(bouDHW.ports[1], pumDHW.port_a)
    annotation (Line(points={{70,10},{50,10},{50,0}}, color={0,127,255}));

  connect(fixTSup.port, volSup.heatPort)
    annotation (Line(points={{-80,10},{-70,10}}, color={191,0,0}));
  connect(volDem.heatPort, fixTDemRet.port)
    annotation (Line(points={{70,60},{60,60}}, color={191,0,0}));
  connect(resGen.port_a, distribution.portGen_out) annotation (Line(points={{-60,-30},
          {-42,-30},{-42,14},{-44,14},{-44,21.8},{-36,21.8}},      color={0,127,
          255}));
  connect(resTra.port_b, volDem.ports[1])
    annotation (Line(points={{60,40},{79,40},{79,50}}, color={0,127,255}));
  connect(volDem.ports[2], distribution.portBui_in)
    annotation (Line(points={{81,50},{81,21.8},{20,21.8}}, color={0,127,255}));
  connect(volSup.ports[1], distribution.portGen_in) annotation (Line(points={{-61,0},
          {-61,-4},{-44,-4},{-44,32.6},{-36,32.6}},          color={0,127,255}));
  connect(volSup.ports[2], resGen.port_b) annotation (Line(points={{-59,0},{-59,
          -18},{-82,-18},{-82,-30},{-79,-30}},                 color={0,127,255}));
  annotation (experiment(
      StopTime=3600,
      Interval=600,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>This partial tests defines boundary conditions to test different distribution systems at design condition.</p>
</html>"));
end PartialTest;
