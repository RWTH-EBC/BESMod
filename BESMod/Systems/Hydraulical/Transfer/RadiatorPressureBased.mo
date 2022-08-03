within BESMod.Systems.Hydraulical.Transfer;
model RadiatorPressureBased "Pressure Based transfer system"
  extends BaseClasses.PartialTransfer(final dp_nominal=rad.dp_nominal .+ val.dpValve_nominal .+ res.dp_nominal .+ val.dpFixed_nominal,
                                      final nParallelSup=1);

  replaceable parameter RecordsCollection.TransferDataBaseDefinition
    transferDataBaseDefinition constrainedby
    RecordsCollection.TransferDataBaseDefinition(
    final Q_flow_nominal=Q_flow_nominal.*f_design,
    final nZones=nParallelDem,
    final AFloor=ABui,
    final heiBui=hBui)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-62,-98},{-42,-78}})));

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,78},
            {-72,100}})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData radParameters
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-100,-98},{-80,-78}})));
  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final nEle=radParameters.nEle,
    each final fraRad=radParameters.fraRad,
    final Q_flow_nominal=Q_flow_nominal.*f_design,
    final T_a_nominal=TTra_nominal,
    final T_b_nominal=TTra_nominal .- dTTra_nominal,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=radParameters.n,
    each final deltaM=0.3,
    final dp_nominal=transferDataBaseDefinition.dpRad_nominal,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator"
    annotation (Placement(transformation(
        extent={{11,11},{-11,-11}},
        rotation=90,
        origin={-13,-25})));

  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=transferDataBaseDefinition.dpHeaDistr_nominal,
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
    final dpValve_nominal=transferDataBaseDefinition.dpHeaSysValve_nominal,
    each final use_inputFilter=false,
    final dpFixed_nominal=transferDataBaseDefinition.dpHeaSysPreValve_nominal,
    each final l=transferDataBaseDefinition.leakageOpening)
                                            annotation (Placement(transformation(
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
    final V(displayUnit="l") = transferDataBaseDefinition.vol,
    final use_C_flow=false,
    nPorts=1 + nParallelDem) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-58,18})));
  IBPSA.Fluid.Movers.SpeedControlled_y     pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    redeclare BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=sum(m_flow_nominal),
      final dp_nominal=1/sum({1/dp_nominal[i] for i in 1:nParallelDem}),
      final rho=rho,
      final V_flowCurve=pumpData.V_flowCurve,
      final dpCurve=pumpData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=pumpData.addPowerToMedium,
    final tau=pumpData.tau,
    final use_inputFilter=pumpData.use_inputFilter,
    final riseTime=pumpData.riseTimeInpFilter,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1)                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,38})));

  Modelica.Blocks.Sources.Constant m_flow1(k=1)   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-48,68})));

  Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{34,-94},{54,-74}})));
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{-5.08,-27.2},
          {40,-27.2},{40,-40},{100,-40}}, color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{-5.08,-22.8},
          {-5.08,-26},{40,-26},{40,40},{100,40}},  color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(rad[i].port_b, portTra_out[1]) annotation (Line(points={{-13,-36},{-13,
            -42},{-100,-42}},
                       color={0,127,255}));
    connect(res[i].port_a, vol.ports[i + 1]) annotation (Line(points={{-47,37.5},
            {-56,37.5},{-56,28},{-58,28}}, color={0,127,255}));
  end for;

  connect(val.port_b, rad.port_a) annotation (Line(points={{-12,-9},{-12,-13.5},
          {-13,-13.5},{-13,-14}}, color={0,127,255}));
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
end RadiatorPressureBased;
