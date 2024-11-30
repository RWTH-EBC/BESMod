within BESMod.Systems.Hydraulical.Distribution;
model DistributionTwoStorageParallel
  "Simple buffer and DHW storage models with three way valve"
  extends BaseClasses.PartialDistribution(
    dp_nominal={0},
    final dpDHW_nominal=0,
    final VStoDHW=parStoDHW.V,
    final QDHWStoLoss_flow=parStoDHW.QLoss_flow,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    final dTTraDHW_nominal=parStoDHW.dTLoadingHC1,
    final dTTra_nominal={parStoBuf.dTLoadingHC1},
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    dTLoss_nominal=fill(0, nParallelDem),
    final m_flow_nominal=mDem_flow_nominal,
    nParallelSup=1,
    final nParallelDem=1);
  parameter Modelica.Units.SI.PressureDifference dpValBufSto_nominal
    "Nominal pressure drop between valve and buffer storage"
    annotation (Dialog(tab="Pressure Drops"));
  parameter Modelica.Units.SI.PressureDifference dpValDHWSto_nominal
    "Nominal pressure drop between valve and DHW storage"
    annotation (Dialog(tab="Pressure Drops"));
  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    parStoBuf(iconName="Buffer")
              constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
    final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
    final rho=rho,
    final c_p=cp,
    final TAmb=TAmb,
    final T_m=TDem_nominal[1],
    final QHC1_flow_nominal=Q_flow_nominal[1],
    final mHC1_flow_nominal=mSup_flow_nominal[1]) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{2,122},{16,136}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    parStoDHW(iconName="DHW")
              constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final QHC1_flow_nominal=QDHW_flow_nominal,
        V=if designType == Types.DHWDesignType.FullStorage then VDHWDay * fFullSto else VDHWDay,
        final Q_flow_nominal=0,
        final VPerQ_flow=0,
        final T_m=TDHW_nominal,
        final mHC1_flow_nominal=mSup_flow_nominal[1])                                          annotation (
      choicesAllMatching=true, Placement(transformation(extent={{82,122},{96,136}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    parThrWayVal(iconName="3WayValve")
                 constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={resValToBufSto.dp_nominal,resValToDHWSto.dp_nominal},
    final m_flow_nominal=mSup_flow_nominal[1],
    final fraK=1,
    use_inputFilter=false) annotation (Placement(transformation(extent={{-78,122},
            {-64,136}})),choicesAllMatching=true);

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.SpeedControlled parPumGen(iconName="PumpGen")
    constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    "Parameters for pump for supply system (generation)"
                                               annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-98,122},{-84,136}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPumTra(iconName="Pump Tra")
    constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    "Parameters for pump for demand system (transfer)"
                                           annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{22,122},{36,136}})));

  AixLib.Fluid.Storage.StorageSimple stoDHW(
    redeclare final package Medium = MediumDHW,
    final n=parStoDHW.nLayer,
    final d=parStoDHW.d,
    final h=parStoDHW.h,
    final lambda_ins=parStoDHW.lambda_ins,
    final s_ins=parStoDHW.sIns,
    final hConIn=parStoDHW.hConIn,
    final hConOut=parStoDHW.hConOut,
    final k_HE=parStoDHW.k_HE,
    final A_HE=parStoDHW.A_HE,
    final V_HE=parStoDHW.V_HE,
    final beta=parStoDHW.beta,
    final kappa=parStoDHW.kappa,
    final m_flow_nominal_layer=mDHW_flow_nominal,
    final m_flow_nominal_HE=mSup_flow_nominal[1],
    final energyDynamics=energyDynamics,
    T_start=fill(TDHW_nominal, parStoDHW.nLayer),
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(stoDHW.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(stoDHW.m_flow_nominal_HE))
    "The DHW storage (TWWS) for domestic hot water demand"
    annotation (Placement(transformation(extent={{64,-68},{38,-28}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        parStoBuf.TAmb) "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,60})));
  AixLib.Fluid.Storage.StorageSimple stoBuf(
    redeclare package Medium = Medium,
    final n=parStoBuf.nLayer,
    final d=parStoBuf.d,
    final h=parStoBuf.h,
    final lambda_ins=parStoBuf.lambda_ins,
    final s_ins=parStoBuf.sIns,
    final hConIn=parStoBuf.hConIn,
    final hConOut=parStoBuf.hConOut,
    final k_HE=parStoBuf.k_HE,
    final A_HE=parStoBuf.A_HE,
    final V_HE=parStoBuf.V_HE,
    final beta=parStoBuf.beta,
    final kappa=parStoBuf.kappa,
    final m_flow_nominal_layer=m_flow_nominal[1],
    final m_flow_nominal_HE=mSup_flow_nominal[1],
    use_TOut=true,
    final energyDynamics=energyDynamics,
    T_start=fill(T_start, parStoBuf.nLayer),
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(stoBuf.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(stoBuf.m_flow_nominal_HE))
    "The buffer storage (PS) for the building"
    annotation (Placement(transformation(extent={{64,30},{38,70}})));
  Components.Valves.ThreeWayValveWithFlowReturn
                                            threeWayValveWithFlowReturn(
    redeclare package Medium = MediumGen,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve parameters=parThrWayVal)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(final T=
        parStoDHW.TAmb) "Constant ambient temperature of storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-50})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHW(use_inpCon=false, y=fixTemDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  IBPSA.Fluid.FixedResistances.PressureDrop resValToBufSto(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=dpValBufSto_nominal,
    final linearized=false,
    final deltaM=0.3)
    "Pressure drop due to resistances between valve and buffer storage"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  IBPSA.Fluid.FixedResistances.PressureDrop resValToDHWSto(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=dpValDHWSto_nominal,
    final linearized=false,
    final deltaM=0.3)
    "Pressure drop due to resistances between valve and DHW storage"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  IBPSA.Fluid.Sources.Boundary_pT bouPumTra(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    nPorts=1)
    "Pressure reference for transfer circuit as generation circuit reference is not connected (indirect loading)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-10})));
  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    nPorts=1)       "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,30})));

  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
    pumTra(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mDem_flow_design[1],
    final dp_nominal=dpDem_nominal[1],
    final externalCtrlTyp=parPumTra.externalCtrlTyp,
    final ctrlType=parPumTra.ctrlType,
    final dpVarBase_nominal=parPumTra.dpVarBase_nominal,
    final addPowerToMedium=parPumTra.addPowerToMedium,
    final use_inputFilter=parPumTra.use_inputFilter,
    final riseTime=parPumTra.riseTimeInpFilter,
    final y_start=1) "Pump for demand system (transfer)" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,10})));
  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
    pumGen(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final dp_nominal=dpSup_nominal[1] + (parThrWayVal.dpValve_nominal + max(
        parThrWayVal.dp_nominal)),
    final externalCtrlTyp=parPumGen.externalCtrlTyp,
    final ctrlType=parPumGen.ctrlType,
    final dpVarBase_nominal=parPumGen.dpVarBase_nominal,
    final addPowerToMedium=parPumGen.addPowerToMedium,
    final use_inputFilter=parPumGen.use_inputFilter,
    final riseTime=parPumGen.riseTimeInpFilter,
    final y_start=1) "Pump for supply system (generation)" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-70,40})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,-128})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=2)
    annotation (Placement(transformation(extent={{-78,-138},{-58,-118}})));

equation
  connect(fixTemBuf.port, stoBuf.heatPort) annotation (Line(points={{80,60},{68,
          60},{68,50},{61.4,50}},     color={191,0,0}));
  connect(stoBuf.port_b_consumer, portBui_out[1]) annotation (Line(points={{51,70},
          {50,70},{50,80},{100,80}},     color={0,127,255}));
  connect(stoDHW.port_b_consumer, portDHW_out) annotation (Line(points={{51,-28},
          {51,-20},{100,-20},{100,-22}},     color={0,127,255}));
  connect(portDHW_in, stoDHW.port_a_consumer) annotation (Line(points={{100,-82},
          {51,-82},{51,-68}},               color={0,127,255}));
  connect(fixTemDHW.port, stoDHW.heatPort) annotation (Line(points={{80,-50},{80,
          -48},{61.4,-48}},              color={191,0,0}));
  connect(stoBuf.port_b_heatGenerator, threeWayValveWithFlowReturn.portBui_a)
    annotation (Line(points={{40.08,34},{-8,34},{-8,74},{-20,74}},
        color={0,127,255}));
  connect(stoDHW.port_b_heatGenerator, threeWayValveWithFlowReturn.portDHW_a)
    annotation (Line(points={{40.08,-64},{-12,-64},{-12,62},{-20,62},{-20,62.4}},
                                                                    color={0,127,
          255}));
  connect(portGen_in[1], threeWayValveWithFlowReturn.portGen_a) annotation (
      Line(points={{-100,80},{-48,80},{-48,74.4},{-40,74.4}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
     Line(points={{-30,82},{-30,100},{0,100},{0,101}},               color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(threeWayValveWithFlowReturn.portBui_b, resValToBufSto.port_a)
    annotation (Line(points={{-20,78},{-4,78},{-4,70},{0,70}}, color={0,127,255}));
  connect(stoBuf.port_a_heatGenerator, resValToBufSto.port_b) annotation (Line(
        points={{40.08,67.6},{40.08,70},{20,70}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, resValToDHWSto.port_a)
    annotation (Line(points={{-20,66.4},{-20,66},{-10,66},{-10,-30},{0,-30}},
        color={0,127,255}));
  connect(stoDHW.port_a_heatGenerator, resValToDHWSto.port_b) annotation (Line(
        points={{40.08,-30.4},{30.04,-30.4},{30.04,-30},{20,-30}}, color={0,127,
          255}));
  connect(eneKPICalDHW.KPI, outBusDist.QDHWLos_flow) annotation (Line(points={{-57.8,
          -100},{0,-100}},              color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(eneKPICalBuf.KPI, outBusDist.QBufLos_flow) annotation (Line(points={{-57.8,
          -70},{0,-70},{0,-100}},       color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{-17.8,-127.8},{-6,-127.8},{-6,-114},{70,-114},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(pumTra.port_a, portBui_in[1]) annotation (Line(points={{80,10},{90,10},
          {90,40},{100,40}}, color={0,127,255}));
  connect(pumTra.port_b, stoBuf.port_a_consumer) annotation (Line(points={{60,10},
          {50,10},{50,30},{51,30}}, color={0,127,255}));
  connect(bouPumTra.ports[1], pumTra.port_a) annotation (Line(points={{60,-10},{
          86,-10},{86,10},{80,10}},
                               color={0,127,255}));
  connect(pumTra.y, sigBusDistr.uPumTra) annotation (Line(points={{70,22},{70,101},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumGen.y, sigBusDistr.uPumGen) annotation (Line(points={{-70,52},{-70,
          101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumGen.port_b, portGen_out[1])
    annotation (Line(points={{-80,40},{-100,40}}, color={0,127,255}));
  connect(bouPum.ports[1], pumGen.port_a) annotation (Line(points={{-40,30},{-50,
          30},{-50,40},{-60,40}}, color={0,127,255}));
  connect(pumGen.port_a, threeWayValveWithFlowReturn.portGen_b) annotation (
      Line(points={{-60,40},{-50,40},{-50,66.4},{-40,66.4}}, color={0,127,255}));
  connect(multiSum.y, realToElecCon.PEleLoa) annotation (Line(points={{-56.3,-128},
          {-48,-128},{-48,-124},{-40,-124}},
                                          color={0,0,127}));
  connect(pumGen.P, multiSum.u[1]) annotation (Line(points={{-81,46},{-86,46},{-86,
          22},{-102,22},{-102,-129.75},{-78,-129.75}}, color={0,0,127}));
  connect(pumTra.P, multiSum.u[2]) annotation (Line(points={{59,16},{40,16},{40,
          20},{-16,20},{-16,-16},{-88,-16},{-88,-126.25},{-78,-126.25}}, color={
          0,0,127}));
  connect(stoBuf.TLayer[parStoBuf.nLayer], sigBusDistr.TStoBufTopMea)
    annotation (Line(points={{62.245,55.9},{66,55.9},{66,101},{0,101}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoBuf.TLayer[1], sigBusDistr.TStoBufBotMea) annotation (Line(points={
          {62.245,55.9},{66,55.9},{66,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoDHW.TLayer[1], sigBusDistr.TStoDHWBotMea) annotation (Line(points={
          {62.245,-42.1},{74,-42.1},{74,-30},{116,-30},{116,101},{0,101}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoDHW.TLayer[parStoDHW.nLayer], sigBusDistr.TStoDHWTopMea)
    annotation (Line(points={{62.245,-42.1},{74,-42.1},{74,-30},{116,-30},{116,101},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Diagram(coordinateSystem(extent={{-100,-140},{100,140}})));
end DistributionTwoStorageParallel;
