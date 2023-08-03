within BESMod.Systems.Hydraulical.Transfer;
model IdealValveRadiator
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
    each final p_start=p_start,
    each final nEle=radParameters.nEle,
    each final fraRad=radParameters.fraRad,
    final Q_flow_nominal=Q_flow_nominal .* f_design,
    final T_a_nominal=TTra_nominal,
    final T_b_nominal=TTra_nominal - dTTra_nominal,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=radParameters.n,
    each final deltaM=0.3,
    each final dp_nominal=0,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-10,-30})));

  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=1,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-48,38})));
  Modelica.Blocks.Math.Gain gain[nParallelDem](final k=rad.m_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,30})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
    radParameters annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-100,-98},{-80,-78}})));
  Utilities.KPIs.EnergyKPICalculator intKPICalHeaFlo(final use_inpCon=false,
      final y=sum(-heatPortRad.Q_flow) + sum(-heatPortCon.Q_flow))
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pumFixMFlo[nParallelDem](
    redeclare final package Medium = Medium,
    each final energyDynamics=energyDynamics,
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
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      each final speed_rpm_nominal=parPum.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal,
      each final rho=rho,
      each final V_flowCurve=parPum.V_flowCurve,
      each final dpCurve=parPum.dpCurve),
    each final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    each final addPowerToMedium=parPum.addPowerToMedium,
    each final nominalValuesDefineDefaultPressureCurve=true,
    each final tau=parPum.tau,
    each final use_inputFilter=false,
    final m_flow_start=m_flow_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,10})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    parPum annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,78},{-78,98}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-106},{50,-86}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpe[nParallelDem] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,70})));
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{-2.8,-32},{40,
          -32},{40,-40},{100,-40}},       color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{-2.8,-28},{
          -2.8,-26},{40,-26},{40,40},{100,40}},    color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(rad[i].port_b, portTra_out[1]) annotation (Line(points={{-10,-40},{
            -10,-42},{-100,-42}},
                       color={0,127,255}));
    connect(portTra_in[1], res[i].port_a)
      annotation (Line(points={{-100,38},{-58,38}}, color={0,127,255}));
  end for;

  connect(res.port_b, pumFixMFlo.port_a)
    annotation (Line(points={{-38,38},{-10,38},{-10,20}}, color={0,127,255}));
  connect(pumFixMFlo.port_b, rad.port_a) annotation (Line(points={{-10,
          -3.55271e-15},{-10,-20}}, color={0,127,255}));
  connect(gain.y, pumFixMFlo.m_flow_in)
    annotation (Line(points={{10,19},{10,10},{2,10}}, color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-96},{72,-96},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(intKPICalHeaFlo.KPI, outBusTra.QRad_flow) annotation (Line(points={{
          -17.8,-70},{0,-70},{0,-104}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrOpe.y, outBusTra.opening) annotation (Line(points={{
          -1.9984e-15,59},{-1.9984e-15,50},{24,50},{24,-90},{0,-90},{0,-104}},
                                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrOpe.u, traControlBus.opening) annotation (Line(points={{
          2.22045e-15,82},{2.22045e-15,91},{0,91},{0,100}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrOpe.y, gain.u)
    annotation (Line(points={{-1.9984e-15,59},{-1.9984e-15,50},{10,50},{10,42}},
                                                             color={0,0,127}));
end IdealValveRadiator;
