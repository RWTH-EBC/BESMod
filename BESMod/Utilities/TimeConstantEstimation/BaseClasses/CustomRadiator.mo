within BESMod.Utilities.TimeConstantEstimation.BaseClasses;
model CustomRadiator "Custom radiator with radiative fractions"
  // Abui =1 and hBui =1 to avaoid warnings, will be overwritten anyway
  extends Systems.Hydraulical.Transfer.BaseClasses.PartialTransfer(
    nHeaTra=parRad.n,
    ABui=1,
    hBui=1,
    final dp_nominal=parTra.dp_nominal,
    final nParallelSup=1);
  parameter Boolean use_preRelVal=false "=false to disable pressure relief valve"
    annotation(Dialog(group="Component choices"));
  parameter Real perPreRelValOpens=0.99
    "Percentage of nominal pressure difference at which the pressure relief valve starts to open"
      annotation(Dialog(group="Component choices", enable=use_preRelVal));
  replaceable parameter
    Systems.Hydraulical.Transfer.RecordsCollection.TransferDataBaseDefinition parTra
    constrainedby
    Systems.Hydraulical.Transfer.RecordsCollection.TransferDataBaseDefinition(
    final Q_flow_nominal=Q_flow_nominal .* f_design,
    final nZones=nParallelDem,
    final AFloor=ABui,
    final heiBui=hBui,
    mRad_flow_nominal=m_flow_nominal,
    mHeaCir_flow_nominal=mSup_flow_nominal[1]) "Transfer parameters"
    annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-62,-98},{-42,-78}})));

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    parPum annotation (Dialog(group="Component data"),
      choicesAllMatching=true, Placement(transformation(extent={{-98,78},
            {-72,100}})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
    parRad
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{-100,-98},{-80,-78}})));
  RadiatorEN442_2                                      rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final nEle=parRad.nEle,
    each fraRad_nominal=parRad.fraRad,
    each use_dynamicFraRad=use_dynamicFraRad,
    final Q_flow_nominal=Q_flow_nominal .* f_design,
    final T_a_nominal=TTra_nominal,
    final T_b_nominal=TTra_nominal .- dTTra_nominal,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=parRad.n,
    each final deltaM=0.3,
    final dp_nominal=parTra.dpRad_nominal,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator" annotation (Placement(transformation(
        extent={{11,11},{-11,-11}},
        rotation=90,
        origin={-13,-27})));

  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=parTra.dpHeaDistr_nominal,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-12.5,-13.5},{12.5,13.5}},
        rotation=0,
        origin={-34.5,37.5})));
  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val[nParallelDem](
    redeclare package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=parTra.dpHeaSysValve_nominal,
    each final use_strokeTime=false,
    final dpFixed_nominal=parTra.dpHeaSysPreValve_nominal,
    each final l=parTra.leakageOpening) annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=270,
        origin={-12,1})));

  IBPSA.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=sum(rad.m_flow_nominal),
    final m_flow_small=1E-4*abs(sum(rad.m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    final V(displayUnit="l") = parTra.vol,
    final use_C_flow=false,
    nPorts=1 + nParallelDem) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-58,18})));
  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_nominal=sum(m_flow_nominal),
    final dp_nominal=parTra.dpPumpHeaCir_nominal + dpSup_nominal[1],
    final addPowerToMedium=parPum.addPowerToMedium,
    final tau=parPum.tau,
    final use_riseTime=parPum.use_riseTime,
    final riseTime=parPum.riseTimeInpFilter,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,38})));

  Modelica.Blocks.Sources.Constant m_flow1(k=1)   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-48,68})));

  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{34,-94},{54,-74}})));
  Systems.Hydraulical.Distribution.Components.Valves.PressureReliefValve pressureReliefValve(
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
  parameter Boolean use_dynamicFraRad=true;
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{-5.08,-29.2},
          {40,-29.2},{40,-40},{100,-40}}, color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{-5.08,-24.8},
          {-5.08,-26},{40,-26},{40,40},{100,40}},  color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(rad[i].port_b, portTra_out[1]) annotation (Line(points={{-13,-38},{
            -13,-42},{-100,-42}},
                       color={0,127,255}));
    connect(res[i].port_a, vol.ports[i + 1]) annotation (Line(points={{-47,37.5},
            {-56,37.5},{-56,28},{-58,28}}, color={0,127,255}));
  end for;

  connect(val.port_b, rad.port_a) annotation (Line(points={{-12,-9},{-12,-13.5},
          {-13,-13.5},{-13,-16}}, color={0,127,255}));
  connect(res.port_b, val.port_a) annotation (Line(points={{-22,37.5},{-12,37.5},
          {-12,11}}, color={0,127,255}));
  connect(portTra_in[1],pump.port_a)
    annotation (Line(points={{-100,38},{-84,38}}, color={0,127,255}));
  connect(pump.port_b, vol.ports[1]) annotation (Line(points={{-64,38},{-62,38},
          {-62,28},{-58,28}}, color={0,127,255}));

  connect(m_flow1.y,pump. y)
    annotation (Line(points={{-59,68},{-74,68},{-74,50}}, color={0,0,127}));
  connect(val.y, traControlBus.opening) annotation (Line(points={{1.2,1},{8,1},{
          8,74},{0,74},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{54.2,-83.8},{54.2,-84},{72,-84},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(realToElecCon.PEleLoa, pump.P) annotation (Line(points={{32,-80},{
          22,-80},{22,47},{-63,47}}, color={0,0,127}));
  connect(pressureReliefValve.port_b, portTra_out[1]) annotation (Line(points={{-90,-20},
          {-90,-42},{-100,-42}},           color={0,127,255}));
  connect(pump.port_b, pressureReliefValve.port_a) annotation (Line(points={{-64,38},
          {-60,38},{-60,30},{-90,30},{-90,0}},         color={0,127,255}));
end CustomRadiator;
