within BESMod.Systems.Hydraulical.Transfer.Tests;
partial model PartialTest
  extends BESMod.Systems.BaseClasses.PartialBESExample;
  replaceable BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialTransfer
    transfer(nParallelDem=systemParameters.nZones)
             constrainedby BaseClasses.PartialTransfer(
    redeclare package Medium = IBPSA.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nParallelDem=1,
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
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTZone[transfer.nParallelDem](
     T=systemParameters.TSetZone_nominal) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,8})));

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
  Modelica.Blocks.Sources.Ramp ramp [systemParameters.nZones](each duration=100,
      each startTime=250)
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
    final m_flow_nominal=transfer.mSup_flow_design,
    each externalCtrlTyp=BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.internal,
    each ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpTotal,
    each final addPowerToMedium=false,
    final dp_nominal=transfer.dpSup_design)  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,6})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTSup[transfer.nParallelSup](T=
        systemParameters.THydSup_nominal) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,30})));
  IBPSA.Fluid.MixingVolumes.MixingVolume vol[transfer.nParallelSup](redeclare
      package                                                                         Medium =
        IBPSA.Media.Water,
    m_flow_nominal=transfer.mSup_flow_design,
    each V=0.1,            each final nPorts=2) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-58,42})));
  Modelica.Blocks.Sources.RealExpression Q_flow[transfer.nParallelDem](y=
        fixTZone.port.Q_flow)
    "Difference between trajectory and nominal heat flow rate"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
equation
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

  connect(pumDis.port_a, transfer.portTra_out) annotation (Line(points={{-70,-4},
          {-70,-5.7},{-32,-5.7}},                     color={0,127,255}));
  connect(bou1.ports[1], pumDis.port_a) annotation (Line(points={{-60,-50},{-52,
          -50},{-52,-28},{-70,-28},{-70,-4}},
                                          color={0,127,255}));
  connect(fixTZone.port, transfer.heatPortCon)
    annotation (Line(points={{60,8},{46,8},{46,23},{36,23}}, color={191,0,0}));
  connect(fixTZone.port, transfer.heatPortRad)
    annotation (Line(points={{60,8},{46,8},{46,-5},{36,-5}}, color={191,0,0}));
  connect(fixTSup.port, vol.heatPort) annotation (Line(points={{-80,30},{-74,30},
          {-74,42},{-68,42}}, color={191,0,0}));
  connect(vol.ports[1], pumDis.port_b)
    annotation (Line(points={{-59,32},{-59,16},{-70,16}}, color={0,127,255}));
  connect(vol.ports[2], transfer.portTra_in) annotation (Line(points={{-57,32},
          {-42,32},{-42,23},{-32,23}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>This test sets the nominal zone and supply temperature to check if heat and mass flow rates as well as pressure drops are match the design conditions.</p>
</html>"));
end PartialTest;
