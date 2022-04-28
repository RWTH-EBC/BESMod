within BESMod.Systems.Hydraulical.Distribution;
model DistributionTwoStorageParallel
  "Buffer storage and DHW storage"
  extends BaseClasses.PartialDistribution(
    final dpDem_nominal={0},
    final dpSup_nominal={0},
    final dTTraDHW_nominal=dhwParameters.dTLoadingHC1,
    final dTTra_nominal={bufParameters.dTLoadingHC1},
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    dTLoss_nominal=fill(0, nParallelDem),
    final m_flow_nominal=mDem_flow_nominal,
    final nParallelSup=1,
    final nParallelDem=1);

  AixLib.Fluid.Storage.Storage storageDHW(
    redeclare final package Medium = MediumDHW,
    final n=dhwParameters.nLayer,
    final d=dhwParameters.d,
    final h=dhwParameters.h,
    final lambda_ins=dhwParameters.lambda_ins,
    final s_ins=dhwParameters.sIns,
    final hConIn=dhwParameters.hConIn,
    final hConOut=dhwParameters.hConOut,
    final k_HE=dhwParameters.k_HE,
    final A_HE=dhwParameters.A_HE,
    final V_HE=dhwParameters.V_HE,
    final beta=dhwParameters.beta,
    final kappa=dhwParameters.kappa,
    final m_flow_nominal_layer=mDHW_flow_nominal,
    final m_flow_nominal_HE=mSup_flow_nominal[1],
    final energyDynamics=energyDynamics,
    final T_start=TDHW_nominal,
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(storageDHW.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(storageDHW.m_flow_nominal_HE))
    "The DHW storage (TWWS) for domestic hot water demand"
    annotation (Placement(transformation(extent={{66,-70},{32,-32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureBuf(final T=bufParameters.TAmb)           annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={44,6})));
  AixLib.Fluid.Storage.Storage storageBuf(
    redeclare package Medium = Medium,
    final n=bufParameters.nLayer,
    final d=bufParameters.d,
    final h=bufParameters.h,
    final lambda_ins=bufParameters.lambda_ins,
    final s_ins=bufParameters.sIns,
    final hConIn=bufParameters.hConIn,
    final hConOut=bufParameters.hConOut,
    final k_HE=bufParameters.k_HE,
    final A_HE=bufParameters.A_HE,
    final V_HE=bufParameters.V_HE,
    final beta=bufParameters.beta,
    final kappa=bufParameters.kappa,
    final m_flow_nominal_layer=m_flow_nominal[1],
    final m_flow_nominal_HE=mSup_flow_nominal[1],
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(storageBuf.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(storageBuf.m_flow_nominal_HE))
    "The buffer storage (PS) for the building"
    annotation (Placement(transformation(extent={{66,40},{32,76}})));
  Components.Valves.ArtificialThreeWayValve artificialThreeWayValve(redeclare
      final package Medium = MediumGen, final p_hydr=p_start)
    annotation (Placement(transformation(extent={{-68,36},{-18,80}})));
  Modelica.Blocks.Sources.RealExpression T_stoDHWTop(final y(unit="K", displayUnit="degC")=storageDHW.layer[
        dhwParameters.nLayer].T) annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={37,87})));
  Modelica.Blocks.Sources.RealExpression T_stoBufTop(final y(unit="K", displayUnit="degC")=storageBuf.layer[
        bufParameters.nLayer].T) annotation (Placement(transformation(
        extent={{-5,-2},{5,2}},
        rotation=180,
        origin={23,92})));
  Modelica.Blocks.Sources.RealExpression T_stoBufBot(final y(unit="K", displayUnit="degC")=storageBuf.layer[1].T)
    annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={23,87})));
  Modelica.Blocks.Sources.RealExpression T_stoDHWBot(final y(unit="K", displayUnit="degC")=storageDHW.layer[1].T)
    annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={37,99})));

  replaceable
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    bufParameters constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
        final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final T_m=TDem_nominal[1],
        final QHC1_flow_nominal=Q_flow_nominal[1],
        final mHC1_flow_nominal=mSup_flow_nominal[1],
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1)                    annotation (
      choicesAllMatching=true, Placement(transformation(extent={{84,56},{98,70}})));
  replaceable
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    dhwParameters constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final QHC1_flow_nominal=QDHW_flow_nominal,
        final V=VDHWDay,
        final Q_flow_nominal=QDHW_flow_nominal,
        final VPerQ_flow=0,
        final T_m=TDHW_nominal,
        final mHC1_flow_nominal=mSup_flow_nominal[1],
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1)                                          annotation (
      choicesAllMatching=true, Placement(transformation(extent={{82,-58},{98,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureDHW(final T=
        dhwParameters.TAmb)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-90})));

  Utilities.KPIs.InternalKPICalculator internalKPICalculatorBufLoss(
    unit="W",
    integralUnit="J",
    thresholdOn=Modelica.Constants.eps,
    calc_singleOnTime=false,
    calc_integral=true,
    calc_totalOnTime=false,
    calc_numSwi=false,
    calc_movAve=false,
    calc_intBelThres=false,
    y=fixedTemperatureBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-52}})));
  Utilities.KPIs.InternalKPICalculator internalKPICalculatorDHWLoss(
    unit="W",
    integralUnit="J",
    thresholdOn=Modelica.Constants.eps,
    calc_singleOnTime=false,
    calc_integral=true,
    calc_totalOnTime=false,
    calc_numSwi=false,
    calc_movAve=false,
    calc_intBelThres=false,
    y=fixedTemperatureDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-110},{-60,-72}})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{34,-110},{54,-90}})));
equation
  connect(fixedTemperatureBuf.port, storageBuf.heatPort) annotation (Line(
        points={{56,6},{80,6},{80,58},{62.6,58}}, color={191,0,0}));
  connect(storageBuf.port_b_consumer, portBui_out[1]) annotation (Line(points={{49,76},
          {50,76},{50,80},{100,80}},     color={0,127,255}));
  connect(storageBuf.port_a_consumer, portBui_in[1]) annotation (Line(points={{49,40},
          {100,40}},                 color={0,127,255}));
  connect(storageDHW.port_b_consumer, portDHW_out) annotation (Line(points={{49,-32},
          {48,-32},{48,-22},{100,-22}},      color={0,127,255}));
  connect(portDHW_in, storageDHW.port_a_consumer) annotation (Line(points={{100,-82},
          {48,-82},{48,-70},{49,-70}},      color={0,127,255}));
  connect(artificialThreeWayValve.port_buf_b, storageBuf.port_a_heatGenerator)
    annotation (Line(points={{-18,74.72},{0,74.72},{0,73.84},{34.72,73.84}},
        color={0,127,255}));
  connect(artificialThreeWayValve.port_buf_a, storageBuf.port_b_heatGenerator)
    annotation (Line(points={{-18,65.92},{8,65.92},{8,43.6},{34.72,43.6}},
        color={0,127,255}));
  connect(artificialThreeWayValve.port_dhw_b, storageDHW.port_a_heatGenerator)
    annotation (Line(points={{-18,49.2},{-10,49.2},{-10,46},{8,46},{8,-34.28},{
          34.72,-34.28}}, color={0,127,255}));
  connect(artificialThreeWayValve.port_dhw_a, storageDHW.port_b_heatGenerator)
    annotation (Line(points={{-18,40.4},{-16,40.4},{-16,36},{8,36},{8,-66.2},{
          34.72,-66.2}},  color={0,127,255}));
  connect(fixedTemperatureDHW.port, storageDHW.heatPort) annotation (Line(
        points={{40,-90},{70,-90},{70,-51},{62.6,-51}}, color={191,0,0}));
  connect(sigBusDistr.dhw_on, artificialThreeWayValve.dhw_on) annotation (Line(
      points={{0,101},{-43,101},{-43,84.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_in[1], artificialThreeWayValve.port_a) annotation (Line(
        points={{-100,80},{-83,80},{-83,66.8},{-68,66.8}}, color={0,127,255}));
  connect(portGen_out[1], artificialThreeWayValve.port_b) annotation (Line(
        points={{-100,40},{-78,40},{-78,49.2},{-68,49.2}}, color={0,127,255}));
  connect(internalKPICalculatorDHWLoss.KPIBus, outBusDist.QDHWLoss) annotation (
     Line(
      points={{-59.8,-91},{-14,-91},{-14,-86},{0,-86},{0,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(internalKPICalculatorBufLoss.KPIBus, outBusDist.QBufLoss) annotation (
     Line(
      points={{-59.8,-71},{0,-71},{0,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(T_stoDHWBot.y, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{31.5,
          99},{0,99},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoDHWTop.y, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{31.5,
          87},{28,87},{28,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoBufBot.y, sigBusDistr.TStoBufBotMea) annotation (Line(points={{17.5,
          87},{0,87},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoBufTop.y, sigBusDistr.TStoBufTopMea) annotation (Line(points={{17.5,
          92},{0,92},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{54,-100},{54,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
end DistributionTwoStorageParallel;
