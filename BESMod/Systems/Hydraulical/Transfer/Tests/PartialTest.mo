within BESMod.Systems.Hydraulical.Transfer.Tests;
partial model PartialTest
  extends BESMod.Systems.BaseClasses.PartialBESExample;
  replaceable BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialTransfer
    transfer constrainedby BaseClasses.PartialTransfer(
    redeclare package Medium = IBPSA.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nParallelDem=1,
    dTTra_nominal={10},
    m_flow_nominal={0.317},
    Q_flow_nominal=systemParameters.QBui_flow_nominal,
    TOda_nominal=systemParameters.TOda_nominal,
    TDem_nominal=systemParameters.TSetZone_nominal,
    TAmb=systemParameters.TAmbHyd,
    TTra_nominal=systemParameters.THydSup_nominal,
    TTraOld_design=systemParameters.THydSup_nominal,
    AZone={100},
    hZone={2.6},
    ABui=100,
    hBui=2.6) annotation (choicesAllMatching=true, Placement(transformation(
          extent={{-32,-26},{36,44}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         prescribedTemperature(T(
        displayUnit="K"))
               annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,10})));

  Modelica.Blocks.Sources.Sine TRoom(
    amplitude=1,
    f=1/3600,
    offset=293.15 - 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-30})));

  IBPSA.Fluid.Sources.Boundary_pT bou1[transfer.nParallelSup](
    redeclare package Medium = IBPSA.Media.Water,
    each final p=200000,
    each nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-50})));
  Interfaces.TransferControlBus traControlBus
    annotation (Placement(transformation(extent={{0,60},{20,80}}),
        iconTransformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.Ramp ramp [systemParameters.nZones](
    each duration=1800, each startTime=600)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,70})));
  Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
                                           pumDis[transfer.nParallelSup](
    redeclare final package Medium = IBPSA.Media.Water,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final p_start=transfer.p_start,
    each final T_start=transfer.T_start,
    each final X_start=transfer.X_start,
    each final C_start=transfer.C_start,
    each final C_nominal=transfer.C_nominal,
    each final allowFlowReversal=transfer.allowFlowReversal,
    final m_flow_nominal=transfer.mSup_flow_nominal,
    each externalCtrlTyp=BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.internal,
    each ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpTotal,
    each final addPowerToMedium=false,
    each final use_inputFilter=false,
    each final init=Modelica.Blocks.Types.Init.InitialOutput,
    final dp_nominal=transfer.dpSup_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,8})));

equation
  connect(prescribedTemperature.port, transfer.heatPortCon[1]) annotation (Line(
        points={{60,10},{42,10},{42,23},{36,23}},                   color={191,0,
          0}));
  connect(prescribedTemperature.port, transfer.heatPortRad[1])
    annotation (Line(points={{60,10},{42,10},{42,-5},{36,-5}},
                                                             color={191,0,0}));
  connect(TRoom.y, prescribedTemperature.T) annotation (Line(points={{90,-19},{
          92,-19},{92,10},{82,10}},                                  color={0,0,
          127}));
  connect(traControlBus, transfer.traControlBus) annotation (Line(
      points={{10,70},{10,50},{2,50},{2,44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ramp.y, traControlBus.opening) annotation (Line(points={{-79,70},{10,70}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(pumDis.port_a, transfer.portTra_out) annotation (Line(points={{-70,-2},
          {-70,-5.7},{-32,-5.7}},                     color={0,127,255}));
  connect(pumDis.port_b, transfer.portTra_in) annotation (Line(points={{-70,18},
          {-70,23},{-32,23}},                   color={0,127,255}));
  connect(bou1.ports[1], pumDis.port_a) annotation (Line(points={{-60,-50},{-52,
          -50},{-52,-28},{-70,-28},{-70,-2}},
                                          color={0,127,255}));
end PartialTest;
