within BESMod.Systems.Hydraulical.Generation.Tests;
partial model PartialTest
  "Model for a partial test of hydraulic generation systems"
  extends BESMod.Systems.BaseClasses.PartialBESExample(systemParameters(final
        nZones=1));

  BESMod.Systems.Hydraulical.Interfaces.GenerationControlBus
    genControlBus
    annotation (Placement(transformation(extent={{-10,54},{30,94}})));

  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        systemParameters.filNamWea)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  IBPSA.Fluid.Sources.Boundary_pT bouTra[generation.nParallelDem](
    redeclare package Medium = IBPSA.Media.Water,
    each final p=generation.p_start,
    each final T=generation.T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,4})));

  Modelica.Blocks.Sources.Constant constOn[generation.nParallelSup](each final
      k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-72})));
  replaceable BaseClasses.PartialGeneration generation
  constrainedby
    BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    redeclare package Medium = IBPSA.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dTTra_nominal=fill(10, generation.nParallelDem),
    m_flow_nominal=fill(0.317, generation.nParallelDem),
    Q_flow_nominal=fill(sum(systemParameters.QBui_flow_nominal), generation.nParallelDem),
    TOda_nominal=systemParameters.TOda_nominal,
    TDem_nominal=fill(systemParameters.THydSup_nominal[1], generation.nParallelDem),
    TAmb=systemParameters.TAmbHyd)
    annotation (Placement(transformation(extent={{-36,-40},{16,18}})));
  IBPSA.Fluid.MixingVolumes.MixingVolume vol[generation.nParallelDem](
    redeclare final package Medium = IBPSA.Media.Water,
    each final energyDynamics=generation.energyDynamics,
    each final massDynamics=generation.massDynamics,
    each final p_start=generation.p_start,
    each final T_start=systemParameters.THydSup_nominal[1],
    each final X_start=generation.X_start,
    each final C_start=generation.C_start,
    each final C_nominal=generation.C_nominal,
    each final mSenFac=generation.mSenFac,
    final m_flow_nominal=generation.m_flow_nominal,
    final m_flow_small=1E-4*abs(generation.m_flow_nominal),
    each final allowFlowReversal=generation.allowFlowReversal,
    each V=23.5e-6*sum(systemParameters.QBui_flow_nominal),
    each final use_C_flow=false,
    each nPorts=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={74,46})));
  Components.PreconfiguredControlledMovers.PreconfiguredDPControlled pumDis[
    generation.nParallelDem](
    redeclare final package Medium = IBPSA.Media.Water,
    each final energyDynamics=generation.energyDynamics,
    final m_flow_nominal=generation.m_flow_nominal,
    final dp_nominal=generation.dp_nominal,
    each final externalCtrlTyp=BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.speed,
    each final ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar,
    each final addPowerToMedium=false,
    each final use_inputFilter=false,
    each final y_start=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-10})));

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow[generation.nParallelDem](each
      Q_flow=-systemParameters.QBui_flow_nominal[1])
    annotation (Placement(transformation(extent={{32,36},{52,56}})));
equation
  connect(generation.sigBusGen, genControlBus) annotation (Line(
      points={{-9.48,17.42},{-9.48,50},{10,50},{10,74}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  for i in 1:generation.nParallelDem loop

    connect(pumDis[i].port_a, vol[i].ports[2]) annotation (Line(points={{60,-10},
            {70,-10},{70,4},{75,4},{75,36}},      color={0,127,255}));
    connect(generation.portGen_out[i], vol[i].ports[1]) annotation (Line(points={{16,12.2},
            {73,12.2},{73,36}},                   color={0,127,255}));
  end for;

  connect(weaDat.weaBus, generation.weaBus) annotation (Line(
      points={{-60,70},{-46,70},{-46,6.4},{-35.48,6.4}},
      color={255,204,51},
      thickness=0.5));

  connect(constOn.y, pumDis.y)
    annotation (Line(points={{41,-72},{50,-72},{50,-22}}, color={0,0,127}));
  connect(pumDis.port_a, bouTra.ports[1]) annotation (Line(points={{60,-10},{70,-10},
          {70,4},{82,4}}, color={0,127,255}));
  connect(generation.portGen_in, pumDis.port_b) annotation (Line(points={{16,0.6},
          {28,0.6},{28,-10},{40,-10}}, color={0,127,255}));
  connect(fixedHeatFlow.port, vol.heatPort)
    annotation (Line(points={{52,46},{64,46}}, color={191,0,0}));
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,50})),
              experiment(
      StopTime=864000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialTest;
