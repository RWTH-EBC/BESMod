within BESMod.Systems.Hydraulical.Transfer;
model RadiatorPressureBased "Pressure Based transfer system"
  // Abui =1 and hBui =1 to avaoid warnings, will be overwritten anyway
  extends BaseClasses.PartialTransfer(
    dpSup_nominal={parTra.dpPumpHeaCir_nominal},
    nHeaTra=parRad.n,
    ABui=1,
    hBui=1,
    final dp_nominal=parTra.dp_nominal,
    final nParallelSup=1,
    Q_flow_design={if use_oldRad_design[i] then QOld_flow_design[i] else Q_flow_nominal[i] for i in 1:nParallelDem},
    TTra_design={if use_oldRad_design[i] then TTraOld_design[i] else TTra_nominal[i] for i in 1:nParallelDem});

  parameter Boolean use_oldRad_design[nParallelDem]=fill(false, nParallelDem)
    "If true, radiator design of the building with no retrofit (old state) is used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Boolean use_preRelVal=false "=false to disable pressure relief valve"
    annotation(Dialog(group="Component choices"));
  parameter Real perPreRelValOpens=0.99
    "Percentage of nominal pressure difference at which the pressure relief valve starts to open"
      annotation(Dialog(group="Component choices", enable=use_preRelVal));
  replaceable parameter RecordsCollection.TransferDataBaseDefinition parTra
    constrainedby RecordsCollection.TransferDataBaseDefinition(
    final Q_flow_nominal=Q_flow_design .* f_design,
    final nZones=nParallelDem,
    final AFloor=ABui,
    final heiBui=hBui,
    mRad_flow_nominal=m_flow_nominal) "Transfer parameters" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-62,-98},{-42,-78}})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
    parRad
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{-100,-98},{-80,-78}})));
  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final nEle=parRad.nEle,
    each final fraRad=parRad.fraRad,
    final Q_flow_nominal=Q_flow_design .* f_design,
    final T_a_nominal=TTra_design,
    final T_b_nominal=TTra_design .- dTTra_design,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=parRad.n,
    each final deltaM=0.3,
    each final dp_nominal=0,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-10,-30})));

  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=parTra.dpHeaDistr_nominal+parTra.dpRad_nominal[1],
    final m_flow_nominal=m_flow_nominal)
    "Hydraulic resistance of supply and radiator to set dp allways to m_flow_nominal"
    annotation (Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=0,
        origin={-30,40.5})));
  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val[nParallelDem](
    redeclare package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=parTra.dpHeaSysValve_nominal,
    each final use_inputFilter=false,
    final dpFixed_nominal=parTra.dpHeaSysPreValve_nominal,
    each final l=parTra.leakageOpening) annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=270,
        origin={-10,9})));

  IBPSA.Fluid.MixingVolumes.MixingVolume volSup(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=sum(rad.m_flow_nominal),
    final m_flow_small=1E-4*abs(sum(rad.m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    final V(displayUnit="l") = parTra.vol/2,
    final use_C_flow=false,
    nPorts=nParallelDem + 1)     "Volume of supply pipes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-60,20})));

  Utilities.Electrical.ZeroLoad             zeroLoad
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Distribution.Components.Valves.PressureReliefValve pressureReliefValve(
    redeclare final package Medium = Medium,
    m_flow_nominal=mSup_flow_nominal[1],
    final dpFullOpen_nominal=dp_nominal[1],
    final dpThreshold_nominal=perPreRelValOpens*dp_nominal[1],
    final facDpValve_nominal=parTra.valveAutho[1],
    final l=parTra.leakageOpening) if use_preRelVal annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-90,-10})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpe[nParallelDem] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,70})));
  IBPSA.Fluid.MixingVolumes.MixingVolume volRet(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=sum(rad.m_flow_nominal),
    final m_flow_small=1E-4*abs(sum(rad.m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    final V(displayUnit="l") = parTra.vol/2,
    final use_C_flow=false,
    nPorts=nParallelDem + 1) "Volume of return pipes" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-22})));
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{-2.8,-32},{40,
          -32},{40,-40},{100,-40}},       color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{-2.8,-28},{-2.8,
          -26},{40,-26},{40,40},{100,40}},         color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(rad[i].port_b, volRet.ports[i + 1]) annotation (Line(points={{-10,-40},
            {-60,-40},{-60,-32}},
                       color={0,127,255}));
    connect(res[i].port_a, volSup.ports[i + 1]) annotation (Line(points={{-40,40.5},
            {-56,40.5},{-56,30},{-60,30}}, color={0,127,255}));
  end for;

  connect(val.port_b, rad.port_a) annotation (Line(points={{-10,-1},{-10,-20}},
                                  color={0,127,255}));
  connect(res.port_b, val.port_a) annotation (Line(points={{-20,40.5},{-10,40.5},
          {-10,19}}, color={0,127,255}));

  connect(val.y, traControlBus.opening) annotation (Line(points={{3.2,9},{8,9},{
          8,74},{0,74},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{60,-70},{72,-70},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(pressureReliefValve.port_b, portTra_out[1]) annotation (Line(points={{-90,-20},
          {-90,-42},{-100,-42}},           color={0,127,255}));
  connect(reaPasThrOpe.u, traControlBus.opening) annotation (Line(points={{30,
          82},{30,94},{0,94},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrOpe.y, outBusTra.opening) annotation (Line(points={{30,59},{
          30,-32},{4,-32},{4,-90},{0,-90},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(volRet.ports[1], portTra_out[1]) annotation (Line(points={{-60,-32},{-60,
          -42},{-100,-42}}, color={0,127,255}));
  connect(pressureReliefValve.port_a, portTra_in[1])
    annotation (Line(points={{-90,0},{-90,38},{-100,38}}, color={0,127,255}));
  connect(volSup.ports[1], portTra_in[1]) annotation (Line(points={{-60,30},{-56,
          30},{-56,40},{-102,40},{-102,38},{-100,38}},
                              color={0,127,255}));
end RadiatorPressureBased;
