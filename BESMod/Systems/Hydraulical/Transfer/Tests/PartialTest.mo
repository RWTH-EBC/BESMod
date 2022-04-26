within BESMod.Systems.Hydraulical.Transfer.Tests;
partial model PartialTest
  extends BESMod.Systems.BaseClasses.PartialBESExample;
  replaceable
    BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialTransfer
    transfer constrainedby BaseClasses.PartialTransfer(
    redeclare package Medium = IBPSA.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nParallelDem=1,
    TSup_nominal=systemParameters.THydSup_nominal,
    dTTra_nominal={10},
    m_flow_nominal={0.317},
    Q_flow_nominal=systemParameters.QBui_flow_nominal,
    TOda_nominal=systemParameters.TOda_nominal,
    TDem_nominal=systemParameters.TSetZone_nominal,
    TAmb=systemParameters.TAmbHyd,
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
        origin={64,0})));

  Modelica.Blocks.Sources.Sine TRoom(
    amplitude=1,
    freqHz=1/3600,
    offset=293.15 - 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={94,0})));
  IBPSA.Fluid.MixingVolumes.MixingVolume vol[transfer.nParallelSup](
    redeclare package Medium = IBPSA.Media.Water,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final m_flow_nominal=sum(transfer.m_flow_nominal),
    each final V=1,
    each final nPorts=3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-76,8})));

  IBPSA.Fluid.Sources.Boundary_pT bou1[transfer.nParallelSup](
    redeclare package Medium = IBPSA.Media.Water,
    each final p=200000,
    each final nPorts=1)            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-24})));
  Interfaces.TransferControlBus traControlBus
    annotation (Placement(transformation(extent={{-14,56},{6,76}})));
  Modelica.Blocks.Sources.Constant constOpening[systemParameters.nZones](each final
            k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-86,70})));
equation
  connect(prescribedTemperature.port, transfer.heatPortCon[1]) annotation (Line(
        points={{54,1.33227e-15},{50,1.33227e-15},{50,23},{36,23}}, color={191,0,
          0}));
  connect(prescribedTemperature.port, transfer.heatPortRad[1])
    annotation (Line(points={{54,0},{50,0},{50,-5},{36,-5}}, color={191,0,0}));
  connect(transfer.portTra_out, vol.ports[1]) annotation (Line(points={{-32,
          -5.7},{-32,-4},{-58,-4},{-58,6.66667},{-66,6.66667}},
                                         color={0,127,255}));
  connect(transfer.portTra_in, vol.ports[2]) annotation (Line(points={{-32,23},
          {-32,22},{-56,22},{-56,8},{-66,8}},
                                      color={0,127,255}));
  connect(TRoom.y, prescribedTemperature.T) annotation (Line(points={{83,8.88178e-16},
          {79.5,8.88178e-16},{79.5,-1.55431e-15},{76,-1.55431e-15}}, color={0,0,
          127}));
  connect(traControlBus, transfer.traControlBus) annotation (Line(
      points={{-4,66},{-4,55},{2,55},{2,44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(constOpening.y, traControlBus.opening) annotation (Line(points={{-75,70},
          {-42,70},{-42,66},{-4,66}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(bou1.ports[1], vol.ports[3]) annotation (Line(points={{-60,-24},{-54,
          -24},{-54,-4},{-58,-4},{-58,9.33333},{-66,9.33333}}, color={0,127,255}));
end PartialTest;
