within BESMod.Systems.Hydraulical.Transfer;
model RadiatorTransferSystem
  "Subsystem using a radiator and ideal thermostatic valves"
  extends BaseClasses.PartialTransfer(
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final dTLoss_nominal=fill(0, nParallelDem),
    final nParallelSup=1,
    final dp_nominal= fill(0, nParallelDem));

  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p_start=p_start,
    each final nEle=radParameters.nEle,
    each final fraRad=radParameters.fraRad,
    final Q_flow_nominal=Q_flow_nominal .* f_design,
    final T_a_nominal=TSup_nominal,
    final T_b_nominal=TSup_nominal - dTTra_nominal,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=radParameters.n,
    each final deltaM=0.3,
    each final dp_nominal=0,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator" annotation (
      Placement(transformation(
        extent={{11,11},{-11,-11}},
        rotation=90,
        origin={-13,-29})));

  IBPSA.Fluid.FixedResistances.PressureDrop res1[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=1,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-12.5,-13.5},{12.5,13.5}},
        rotation=0,
        origin={-38.5,39.5})));
  Modelica.Blocks.Math.Gain gain[nParallelDem](final k=rad.m_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,34})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData radParameters
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-100,-98},{-80,-78}})));
  Utilities.KPIs.InternalKPICalculator internalKPICalculator(
    unit="W",
    integralUnit="J",
    calc_singleOnTime=false,
    calc_totalOnTime=false,
    calc_numSwi=false,
    calc_movAve=false,
    y=sum(-heatPortRad.Q_flow) + sum(-heatPortCon.Q_flow))
    annotation (Placement(transformation(extent={{-32,-96},{-12,-60}})));
  Utilities.KPIs.InputKPICalculator inputKPICalculator[nParallelDem](
    unit=fill("", nParallelDem),
    integralUnit=fill("s", nParallelDem),
    each calc_singleOnTime=false,
    each calc_integral=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false)
    annotation (Placement(transformation(extent={{-32,-124},{-12,-88}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pumpFix_m_flow[nParallelDem](
    redeclare final package Medium = Medium,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=1E-4*abs(m_flow_nominal),
    each final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData
      per(
      each final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal,
      each final rho=rho,
      each final V_flowCurve=pumpData.V_flowCurve,
      each final dpCurve=pumpData.dpCurve),
    each final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    each final addPowerToMedium=pumpData.addPowerToMedium,
    each final nominalValuesDefineDefaultPressureCurve=true,
    each final tau=pumpData.tau,
    each final use_inputFilter=false,
    final m_flow_start=m_flow_nominal)             annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-15,9})));
  replaceable
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,78},{-78,98}})));
  IBPSA.Fluid.Sources.Boundary_pT bouPumpHP[nParallelDem](
    redeclare package Medium = Medium,
    each final p=p_start,
    each final T=T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-66,10})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-106},{50,-86}})));
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{-5.08,-31.2},
          {40,-31.2},{40,-40},{100,-40}}, color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{-5.08,-26.8},
          {-5.08,-26},{40,-26},{40,40},{100,40}},  color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(rad[i].port_b, portTra_out[1]) annotation (Line(points={{-13,-40},{-13,-42},
          {-100,-42}}, color={0,127,255}));
   connect(portTra_in[1], res1[i].port_a) annotation (Line(points={{-100,38},{-76,38},
          {-76,39.5},{-51,39.5}}, color={0,127,255}));
  end for;

  connect(internalKPICalculator.KPIBus, outBusTra.Q_flow) annotation (Line(
      points={{-11.8,-78},{0,-78},{0,-104}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculator.KPIBus, outBusTra.openings) annotation (Line(
      points={{-11.8,-106},{-6,-106},{-6,-104},{0,-104}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculator.u, traControlBus.opening) annotation (Line(points=
          {{-34.2,-106},{-36,-106},{-36,-62},{26,-62},{26,90},{0,90},{0,100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(gain.u, traControlBus.opening) annotation (Line(points={{8,46},{8,90},
          {0,90},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(res1.port_b, pumpFix_m_flow.port_a) annotation (Line(points={{-26,39.5},
          {-26,38},{-15,38},{-15,20}}, color={0,127,255}));
  connect(pumpFix_m_flow.port_b, rad.port_a) annotation (Line(points={{-15,-2},{
          -15,-18},{-13,-18}}, color={0,127,255}));
  connect(gain.y, pumpFix_m_flow.m_flow_in) annotation (Line(points={{8,23},{6,23},
          {6,8},{-1.8,8},{-1.8,9}}, color={0,0,127}));
  connect(bouPumpHP.ports[1], pumpFix_m_flow.port_a) annotation (Line(points={{-66,20},
          {-66,30},{-16,30},{-16,26},{-15,26},{-15,20}},
                                           color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-96},{72,-96},{72,-98}},
      color={0,0,0},
      thickness=1));
end RadiatorTransferSystem;
