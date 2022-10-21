within BESMod.Systems.Hydraulical.Transfer.Tests;
partial model PartialTest
  extends BESMod.Systems.BaseClasses.PartialBESExample;
  replaceable
    BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialTransfer
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
    dpSup_nominal=fill(0, transfer.nParallelDem),
    AZone={100},
    hZone={2.6},
    ABui=100,
    hBui=2.6) annotation (choicesAllMatching=true, Placement(transformation(extent={{-32,-26},{36,44}})));
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
  IBPSA.Fluid.MixingVolumes.MixingVolume vol[transfer.nParallelSup](
    redeclare package Medium = IBPSA.Media.Water,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final m_flow_nominal=sum(transfer.m_flow_nominal),
    each final V=1,
    each final nPorts=3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,10})));

  IBPSA.Fluid.Sources.Boundary_pT bou1[transfer.nParallelSup](
    redeclare package Medium = IBPSA.Media.Water,
    each final p=200000,
    each final nPorts=1)            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-30})));
  Interfaces.TransferControlBus traControlBus
    annotation (Placement(transformation(extent={{0,60},{20,80}}),
        iconTransformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.Constant constOpening[systemParameters.nZones](each final
            k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,70})));
equation
  connect(prescribedTemperature.port, transfer.heatPortCon[1]) annotation (Line(
        points={{60,10},{42,10},{42,23},{36,23}},                   color={191,0,
          0}));
  connect(prescribedTemperature.port, transfer.heatPortRad[1])
    annotation (Line(points={{60,10},{42,10},{42,-5},{36,-5}},
                                                             color={191,0,0}));
  connect(transfer.portTra_out, vol.ports[1]) annotation (Line(points={{-32,
          -5.7},{-32,-4},{-58,-4},{-58,8.66667},{-60,8.66667}},
                                         color={0,127,255}));
  connect(transfer.portTra_in, vol.ports[2]) annotation (Line(points={{-32,23},
          {-32,22},{-56,22},{-56,10},{-60,10}},
                                      color={0,127,255}));
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
  connect(constOpening.y, traControlBus.opening) annotation (Line(points={{-79,70},
          {10,70}},                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(bou1.ports[1], vol.ports[3]) annotation (Line(points={{-60,-30},{-54,
          -30},{-54,-4},{-58,-4},{-58,11.3333},{-60,11.3333}}, color={0,127,255}));
end PartialTest;
