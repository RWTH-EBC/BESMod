within BESMod.Systems.Hydraulical.Distribution;
model BuildingOnly "Only loads building"
  extends BaseClasses.PartialDistribution(
    final nParallelDem=1,
    dTTra_design=dTTra_nominal,
    use_dhw=false,
    final dpDHW_nominal=0,
    final fFullSto=0,
    final QDHWBefSto_flow_nominal=Modelica.Constants.eps,
    final VStoDHW=0,
    QCrit=0,
    tCrit=0,
    final QDHWStoLoss_flow=0,
    final designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage,
    QDHW_flow_nominal=Modelica.Constants.eps,
    final nParallelSup=1,
    final dTTraDHW_nominal=0,
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final f_design=fill(1, nParallelDem),
    final dTLoss_nominal=fill(0, nParallelDem),
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    redeclare package MediumGen = Medium,
    redeclare package MediumDHW = Medium,
    final dTTra_nominal=fill(0, nParallelDem));

  Modelica.Blocks.Sources.RealExpression reaExpTStoBufTopMea(y(
      final unit="K",
      displayUnit="degC")=
        Medium.temperature(Medium.setState_phX(
        portGen_in[1].p,
        inStream(portGen_in[1].h_outflow),
        inStream(portGen_in[1].Xi_outflow))))
    "Use storage name as all controls use this variable"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,10})));
  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_design[1],
    final dp_nominal=dpDemSca_nominal + dpSup_nominal[1],
    final externalCtrlTyp=parPum.externalCtrlTyp,
    final ctrlType=parPum.ctrlType,
    final dpVarBase_nominal=parPum.dpVarBase_nominal,
    final addPowerToMedium=parPum.addPowerToMedium,
    final use_riseTime=parPum.use_riseTime,
    final riseTime=parPum.riseTime,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-30,40})));
  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1) "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,10})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPum
    "Parameters for pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-58,6},{-44,18}})));
  Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-50})));
protected
  parameter Modelica.Units.SI.PressureDifference dpDemSca_nominal = dpDem_nominal[1] * (mSup_flow_design[1] / mDem_flow_design[1])^2
    "Scaled nominal pressure difference";
initial algorithm
  assert(mSup_flow_design[1] == mDem_flow_design[1],
   "Design mass flow rates do not match. Will try to size the movers accordingly, but check results on whether mass flow rates match.",
   AssertionLevel.warning);

equation
  connect(reaExpTStoBufTopMea.y, sigBusDistr.TStoBufTopMea) annotation (Line(
        points={{39,10},{0,10},{0,101}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_in[1], portBui_out[1])
    annotation (Line(points={{-100,80},{100,80}}, color={0,127,255}));
  connect(bouPum.ports[1],pump.port_a)
    annotation (Line(points={{-10,20},{-10,40},{-20,40}}, color={0,127,255}));
  connect(pump.port_b, portGen_out[1])
    annotation (Line(points={{-40,40},{-100,40}}, color={0,127,255}));
  connect(pump.port_a, portBui_in[1])
    annotation (Line(points={{-20,40},{100,40}}, color={0,127,255}));
  connect(pump.y, sigBusDistr.uPumGen) annotation (Line(points={{-30,52},{-30,101},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{60.2,-49.8},{70,-49.8},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(pump.P, realToElecCon.PEleLoa) annotation (Line(points={{-41,46},{-70,
          46},{-70,-46},{38,-46}}, color={0,0,127}));
end BuildingOnly;
