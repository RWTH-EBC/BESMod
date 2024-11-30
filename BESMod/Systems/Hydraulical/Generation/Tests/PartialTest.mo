within BESMod.Systems.Hydraulical.Generation.Tests;
partial model PartialTest
  "Model for a partial test of hydraulic generation systems"
  extends BESMod.Systems.BaseClasses.PartialBESExample(systemParameters(final
        nZones=1));

  BESMod.Systems.Hydraulical.Interfaces.GenerationControlBus
    genControlBus
    annotation (Placement(transformation(extent={{-10,54},{30,94}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[
    generation.nParallelDem](each final T(displayUnit="K") = systemParameters.THydSup_nominal[
      1])                                                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,50})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        systemParameters.filNamWea)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-102,66},{-66,100}})));
  IBPSA.Fluid.Sources.Boundary_pT bouTra[generation.nParallelDem](
    redeclare package Medium = IBPSA.Media.Water,
    each final p=generation.p_start,
    each final T=generation.T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,4})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pumDis[generation.nParallelDem](
    redeclare final package Medium = IBPSA.Media.Water,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final p_start=generation.p_start,
    each final T_start=generation.T_start,
    each final X_start=generation.X_start,
    each final C_start=generation.C_start,
    each final C_nominal=generation.C_nominal,
    each final allowFlowReversal=generation.allowFlowReversal,
    final m_flow_nominal=generation.m_flow_nominal,
    each final show_T=generation.show_T,
    redeclare final IBPSA.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    each final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    each final addPowerToMedium=false,
    each final nominalValuesDefineDefaultPressureCurve=true,
    each final tau=1,
    each final use_inputFilter=false,
    each final init=Modelica.Blocks.Types.Init.InitialOutput,
    final dp_nominal=generation.dp_nominal)                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-10})));

  Modelica.Blocks.Sources.Constant constOn[generation.nParallelSup](final
            k=generation.m_flow_nominal)
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
    final T_start=fixedTemperature.T,
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
    connect(generation.portGen_out[i], vol[i].ports[1]) annotation (Line(points={{16,12.2},
            {70,12.2},{70,24},{73,24},{73,36}},   color={0,127,255}));
    connect(vol[i].ports[2], pumDis[i].port_a) annotation (Line(points={{75,36},
            {75,24},{70,24},{70,4},{66,4},{66,-10},{60,-10}},
                                                  color={0,127,255}));
  end for;

  connect(vol.heatPort, fixedTemperature.port) annotation (Line(points={{64,46},
          {56,46},{56,50},{40,50}},       color={191,0,0}));
  connect(weaDat.weaBus, generation.weaBus) annotation (Line(
      points={{-66,83},{-46,83},{-46,6.4},{-35.48,6.4}},
      color={255,204,51},
      thickness=0.5));

  connect(bouTra.ports[1],pumDis.port_a) annotation (Line(points={{82,4},{66,4},
          {66,-10},{60,-10}},                                                                color={0,127,255}));
  connect(pumDis.port_b, generation.portGen_in) annotation (Line(points={{40,-10},
          {26,-10},{26,0.6},{16,0.6}},                      color={0,127,255}));
  connect(constOn.y, pumDis.m_flow_in)
    annotation (Line(points={{41,-72},{50,-72},{50,-22}}, color={0,0,127}));
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,50})),
              experiment(
      StopTime=864000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialTest;
