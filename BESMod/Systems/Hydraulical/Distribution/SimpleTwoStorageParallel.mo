within BESMod.Systems.Hydraulical.Distribution;
model SimpleTwoStorageParallel
  "Simple buffer and DHW storage models with three way valve"
  extends BaseClasses.PartialThreeWayValve(
    final dpBufHCSto_design=0,
    final dpDHW_nominal=0,
    final dpDHWHCSto_design=0,
    final QDHWStoLoss_flow=parStoDHW.QLoss_flow,
    final QDHWStoLoss_flow_estimate=BESMod.Systems.Hydraulical.Distribution.RecordsCollection.GetDailyStorageLossesForLabel(VDHWDay_nominal, parStoDHW.energyLabel)/24*1000,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    final dTTraDHW_nominal=parStoDHW.dTLoadingHC1,
    final dTTra_nominal={parStoBuf.dTLoadingHC1},
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    dTLoss_nominal=fill(0, nParallelDem));

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
      choicesAllMatching=true, Placement(transformation(extent={{82,142},{96,156}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    parStoDHW(iconName="DHW")
              constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final QHC1_flow_nominal=QDHW_flow_nominal,
        V=VStoDHW,
        final Q_flow_nominal=0,
        final VPerQ_flow=0,
        final T_m=TDHW_nominal,
        final mHC1_flow_nominal=mSup_flow_nominal[1])                                          annotation (
      choicesAllMatching=true, Placement(transformation(extent={{62,142},{76,156}})));

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.DPVar parPumTra(iconName="Pump Tra")
    constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    "Parameters for pump for demand system (transfer)"
                                           annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{44,164},{56,176}})));

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
    final m_flow_nominal_HE=mSup_flow_design[1],
    final energyDynamics=energyDynamics,
    T_start=fill(TDHW_nominal, parStoDHW.nLayer),
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(stoDHW.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(stoDHW.m_flow_nominal_HE))
    "The DHW storage (TWWS) for domestic hot water demand"
    annotation (Placement(transformation(extent={{12,-72},{-14,-32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        parStoBuf.TAmb) "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,50})));
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
    final m_flow_nominal_layer=mDem_flow_design[1],
    final m_flow_nominal_HE=mSup_flow_design[1],
    use_TOut=true,
    final energyDynamics=energyDynamics,
    T_start=fill(T_start, parStoBuf.nLayer),
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(stoBuf.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(stoBuf.m_flow_nominal_HE))
    "The buffer storage (PS) for the building"
    annotation (Placement(transformation(extent={{16,32},{-10,72}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(final T=if
        use_dhw then parStoDHW.TAmb else TDHW_nominal)
                        "Constant ambient temperature of storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-52})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHW(use_inpCon=false, y=fixTemDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-160})));

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

  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
    pumTra(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mDem_flow_design[1],
    final dp_nominal=dpDem_design[1],
    final externalCtrlTyp=parPumTra.externalCtrlTyp,
    final ctrlType=parPumTra.ctrlType,
    final dpVarBase_nominal=parPumTra.dpVarBase_nominal,
    final addPowerToMedium=parPumTra.addPowerToMedium,
    final use_riseTime=parPumTra.use_riseTime,
    final riseTime=parPumTra.riseTime,
    final y_start=1) "Pump for demand system (transfer)" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,10})));

  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,-128})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=2)
    annotation (Placement(transformation(extent={{-78,-138},{-58,-118}})));



  IBPSA.Fluid.Sources.Boundary_pT bouNoDHW(
    redeclare package Medium = MediumDHW,
    final p=p_start,
    final T=T_start,
    nPorts=1) if not use_dhw "Boundary to disable DHW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-40})));
  IBPSA.Fluid.Sources.MassFlowSource_T
                                  souNoDHW(
    redeclare package Medium = MediumDHW,
    m_flow=0.01,
    final T=TDHW_nominal,
    nPorts=1) if not use_dhw
    "Constant mass flow source to disable DHW and always ensure the DHW storage is at TDHW_nominal"
                                                       annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-66})));

initial algorithm
  assert(parStoDHW.qHC1_flow_nominal * 1000 > 0.25, "In " + getInstanceName() +
      ": Storage heat exchanger is probably to small and the calculated heat 
      transfer coefficient to high. VDI 4645 suggests at least 0.25 m2/kW, 
      you have " + String(parStoDHW.qHC1_flow_nominal * 1000) + "m2/W", AssertionLevel.warning);
equation
  connect(fixTemBuf.port, stoBuf.heatPort) annotation (Line(points={{40,50},{22,
          50},{22,52},{13.4,52}},     color={191,0,0}));
  connect(stoBuf.port_b_consumer, portBui_out[1]) annotation (Line(points={{3,72},{
          74,72},{74,80},{100,80}},      color={0,127,255}));
  if use_dhw then
    connect(stoDHW.port_b_consumer, portDHW_out) annotation (Line(points={{-1,-32},
          {-1,-22},{100,-22}},               color={0,127,255}));
    connect(portDHW_in, stoDHW.port_a_consumer) annotation (Line(points={{100,-82},
          {-1,-82},{-1,-72}},               color={0,127,255}));
  end if;
  connect(fixTemDHW.port, stoDHW.heatPort) annotation (Line(points={{40,-52},{9.4,
          -52}},                         color={191,0,0}));
  connect(stoDHW.port_a_heatGenerator, resValToDHWSto.port_b) annotation (Line(
        points={{-11.92,-34.4},{-11.92,-34},{-26,-34},{-26,128},{6,128},{6,140},
          {0,140}},                                                color={0,127,
          255}));
  connect(eneKPICalDHW.KPI, outBusDist.QDHWLos_flow) annotation (Line(points={{17.8,
          -160},{0,-160},{0,-100}},     color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(eneKPICalBuf.KPI, outBusDist.QBufLos_flow) annotation (Line(points={{-17.8,
          -160},{0,-160},{0,-100}},     color={135,135,135}), Text(
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
          {3,10},{3,32}},           color={0,127,255}));
  connect(bouPumTra.ports[1], pumTra.port_a) annotation (Line(points={{60,-10},{
          86,-10},{86,10},{80,10}},
                               color={0,127,255}));
  connect(pumTra.y, sigBusDistr.uPumTra) annotation (Line(points={{70,22},{70,101},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumGen.y, sigBusDistr.uPumGen) annotation (Line(points={{-68,120},{-68,
          101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumGen.port_b, portGen_out[1])
    annotation (Line(points={{-80,110},{-90,110},{-90,40},{-100,40}},
                                                  color={0,127,255}));
  connect(multiSum.y, realToElecCon.PEleLoa) annotation (Line(points={{-56.3,-128},
          {-48,-128},{-48,-124},{-40,-124}},
                                          color={0,0,127}));
  connect(pumGen.P, multiSum.u[1]) annotation (Line(points={{-74,109},{-74,16},
          {-88,16},{-88,-129.75},{-78,-129.75}},       color={0,0,127}));
  connect(pumTra.P, multiSum.u[2]) annotation (Line(points={{59,16},{-88,16},{-88,
          -126.25},{-78,-126.25}},                                       color={
          0,0,127}));
  connect(stoBuf.TLayer[parStoBuf.nLayer], sigBusDistr.TBuiSupMea)
    annotation (Line(points={{14.245,57.9},{24,57.9},{24,101},{0,101}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoBuf.TLayer[parStoBuf.nLayer], sigBusDistr.TStoBufTopMea)
    annotation (Line(points={{14.245,57.9},{24,57.9},{24,101},{0,101}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoBuf.TLayer[1], sigBusDistr.TStoBufBotMea) annotation (Line(points={{14.245,
          57.9},{24,57.9},{24,101},{0,101}},         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoDHW.TLayer[1], sigBusDistr.TStoDHWBotMea) annotation (Line(points={{10.245,
          -46.1},{10.245,-28},{24,-28},{24,102},{0,102},{0,101}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoDHW.TLayer[parStoDHW.nLayer], sigBusDistr.TStoDHWTopMea)
    annotation (Line(points={{10.245,-46.1},{10.245,-28},{24,-28},{24,102},{0,102},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));


  connect(stoBuf.port_a_heatGenerator, resValToBufSto.port_b) annotation (Line(
        points={{-7.92,69.6},{-18,69.6},{-18,86},{16,86},{16,160},{0,160}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.port_b_heatGenerator)
    annotation (Line(points={{-40,154},{-32,154},{-32,36},{-7.92,36}}, color={0,
          127,255}));
  connect(stoDHW.port_b_heatGenerator, threeWayValveWithFlowReturn.portDHW_a)
    annotation (Line(points={{-11.92,-68},{-36,-68},{-36,142.4},{-40,142.4}},
        color={0,127,255}));
  connect(bouNoDHW.ports[1], stoDHW.port_b_consumer) annotation (Line(points={{70,-40},
          {66,-40},{66,-22},{-1,-22},{-1,-32}},      color={0,127,255}));
  connect(souNoDHW.ports[1], stoDHW.port_a_consumer) annotation (Line(points={{
          70,-66},{60,-66},{60,-82},{-1,-82},{-1,-72}}, color={0,127,255}));
end SimpleTwoStorageParallel;
