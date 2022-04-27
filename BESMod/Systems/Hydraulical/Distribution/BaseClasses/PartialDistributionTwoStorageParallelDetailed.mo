within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialDistributionTwoStorageParallelDetailed
  "Partial model to later extent"
  extends BaseClasses.PartialDistribution(
    final dpDem_nominal={0},
    final dpSup_nominal={2*(threeWayValveParameters.dpValve_nominal + max(
        threeWayValveParameters.dp_nominal))},
    final dTTraDHW_nominal=dhwParameters.dTLoadingHC1,
    final dTTra_nominal={bufParameters.dTLoadingHC1},
    final m_flow_nominal=mDem_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    final nParallelSup=1,
    final nParallelDem=1);

  parameter Modelica.SIunits.PressureDifference dpBufHCSto_nominal
    "Nominal pressure difference in buffer storage heating coil";
  final parameter Modelica.SIunits.PressureDifference dpDHWHCSto_nominal=sum(storageDHW.heatingCoil1.pipe.cor.res.dp_nominal)
    "Nominal pressure difference in DHW storage heating coil";
  parameter Modelica.SIunits.HeatFlowRate QHRAftDHW_flow_nominal
    "Nominal heat flow rate of heating rod after Buffer storage"
    annotation (Dialog(enable=use_heatingRodAfterDHW));
  parameter Modelica.SIunits.HeatFlowRate QHRAftBuf_flow_nominal
    "Nominal heat flow rate of heating rod after DHW storage"
    annotation (Dialog(enable=use_heatingRodAfterBuffer));
  parameter Boolean use_heatingRodAfterDHW "=false to disable the heating rod after the DHW storage";
  parameter Boolean use_heatingRodAfterBuffer "=false to disable the heating rod after the buffer storage";
  parameter Integer discretizationStepsDWHStoHR=0
    "Number of steps to dicretize. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1";
  parameter Integer discretizationStepsBufStoHR=0
    "Number of steps to dicretize. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1";
  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    temperatureSensorData
    annotation (choicesAllMatching=true, Placement(transformation(extent={{62,28},{68,34}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    threeWayValveParameters constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={dpBufHCSto_nominal, dpDHWHCSto_nominal},
    final m_flow_nominal=mSup_flow_nominal[1],
    final fraK=1,
    use_inputFilter=false) annotation (choicesAllMatching=
       true, Placement(transformation(extent={{-84,84},{-64,104}})));

 replaceable
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition bufParameters
    constrainedby
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
        final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        T_m=TSup_nominal[1],
        final QHC1_flow_nominal=Q_flow_nominal[1]*f_design[1],
        final mHC1_flow_nominal=mSup_flow_nominal[1],
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1,
        final use_HC2=storageBuf.useHeatingCoil2,
        final use_HC1=storageBuf.useHeatingCoil1,
        final dTLoadingHC2=9999999,
        final fHeiHC2=1,
        final fDiaHC2=1,
        final QHC2_flow_nominal=9999999,
        final mHC2_flow_nominal=9999999,
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_10x0_6 pipeHC2)
          annotation (
      choicesAllMatching=true, Placement(transformation(extent={{18,26},{32,40}})));

  replaceable
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition dhwParameters
    constrainedby
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final use_HC1=storageDHW.useHeatingCoil1,
        final QHC1_flow_nominal=Q_flow_nominal[1]*f_design[1],
        final V=VDHWDay,
        final Q_flow_nominal=QDHW_flow_nominal,
        final VPerQ_flow=0,
        T_m=TDHW_nominal,
        final mHC1_flow_nominal=mSup_flow_nominal[1],
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1,
        final use_HC2=storageDHW.useHeatingCoil2,
        final dTLoadingHC2=9999999,
        final fHeiHC2=1,
        final fDiaHC2=1,
        final QHC2_flow_nominal=9999999,
        final mHC2_flow_nominal=9999999,
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_10x0_6 pipeHC2) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{20,-62},{34,-48}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureBuf(final T=bufParameters.TAmb)           annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={-82,2})));
  Modelica.Blocks.Sources.RealExpression T_stoDHWTop(final y=storageDHW.layer[
        dhwParameters.nLayer].T) annotation (Placement(transformation(
        extent={{-17,-6},{17,6}},
        rotation=0,
        origin={-33,70})));
  Modelica.Blocks.Sources.RealExpression T_stoBufTop(final y=storageBuf.layer[
        bufParameters.nLayer].T) annotation (Placement(transformation(
        extent={{-16,-5},{16,5}},
        rotation=0,
        origin={-34,87})));
  Modelica.Blocks.Sources.RealExpression T_stoBufBot(final y=storageBuf.layer[1].T)
    annotation (Placement(transformation(
        extent={{-16,-5},{16,5}},
        rotation=0,
        origin={-34,79})));
  Modelica.Blocks.Sources.RealExpression T_stoDHWBot(final y=storageDHW.layer[1].T)
    annotation (Placement(transformation(
        extent={{-16,-5},{16,5}},
        rotation=0,
        origin={-34,95})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureDHW(final T=dhwParameters.TAmb)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-72,-88})));

  AixLib.Fluid.Storage.BufferStorage storageBuf(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final mSenFac=1,
    redeclare package MediumHC1 = MediumGen,
    redeclare package MediumHC2 = MediumGen,
    final m1_flow_nominal=mSup_flow_nominal[1],
    final m2_flow_nominal=m_flow_nominal[1],
    final mHC1_flow_nominal=bufParameters.mHC1_flow_nominal,
    final mHC2_flow_nominal=bufParameters.mHC2_flow_nominal,
    final useHeatingCoil2=false,
    final useHeatingRod=bufParameters.use_hr,
    final TStart=T_start,
    redeclare final RecordsCollection.BufferStorage.bufferData data(
      final hTank=bufParameters.h,
      hHC1Low=0,
      hHR=bufParameters.nLayerHR/bufParameters.nLayer*bufParameters.h,
      final dTank=bufParameters.d,
      final sWall=bufParameters.sIns/2,
      final sIns=bufParameters.sIns/2,
      final lambdaWall=bufParameters.lambda_ins,
      final lambdaIns=bufParameters.lambda_ins,
      final rhoIns=373000,
      final cIns=1000,
      pipeHC1=bufParameters.pipeHC1,
      pipeHC2=bufParameters.pipeHC2,
      lengthHC1=bufParameters.lengthHC1,
      lengthHC2=bufParameters.lengthHC2),
    final n=bufParameters.nLayer,
    final hConIn=bufParameters.hConIn,
    final hConOut=bufParameters.hConOut,
    final hConHC1=bufParameters.hConHC1,
    final hConHC2=bufParameters.hConHC2,
    upToDownHC1=true,
    upToDownHC2=true,
    final TStartWall=T_start,
    final TStartIns=T_start,
    redeclare model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferBuoyancyWetter,
    final allowFlowReversal_layers=allowFlowReversal,
    final allowFlowReversal_HC1=allowFlowReversal,
    final allowFlowReversal_HC2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-36,14},{0,58}})));

  AixLib.Fluid.Storage.BufferStorage storageDHW(
    redeclare final package Medium = MediumDHW,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final mSenFac=1,
    redeclare final package MediumHC1 = MediumGen,
    redeclare final package MediumHC2 = MediumGen,
    final m1_flow_nominal=mSup_flow_nominal[1],
    final m2_flow_nominal=mDHW_flow_nominal,
    final mHC1_flow_nominal=dhwParameters.mHC1_flow_nominal,
    final mHC2_flow_nominal=dhwParameters.mHC2_flow_nominal,
    final useHeatingCoil1=true,
    final useHeatingCoil2=false,
    final useHeatingRod=dhwParameters.use_hr,
    final TStart=T_start,
    redeclare final RecordsCollection.BufferStorage.bufferData data(
      final hTank=dhwParameters.h,
      hHC1Low=0,
      hHR=dhwParameters.nLayerHR/dhwParameters.nLayer*dhwParameters.h,
      final dTank=dhwParameters.d,
      final sWall=dhwParameters.sIns/2,
      final sIns=dhwParameters.sIns/2,
      final lambdaWall=dhwParameters.lambda_ins,
      final lambdaIns=dhwParameters.lambda_ins,
      final rhoIns=373000,
      final cIns=1000,
      pipeHC1=dhwParameters.pipeHC1,
      pipeHC2=dhwParameters.pipeHC2,
      lengthHC1=dhwParameters.lengthHC1,
      lengthHC2=dhwParameters.lengthHC2),
    final n=dhwParameters.nLayer,
    final hConIn=dhwParameters.hConIn,
    final hConOut=dhwParameters.hConOut,
    final hConHC1=dhwParameters.hConHC1,
    final hConHC2=dhwParameters.hConHC2,
    final upToDownHC1=true,
    final upToDownHC2=true,
    final TStartWall=T_start,
    final TStartIns=T_start,
    redeclare model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferBuoyancyWetter,
    final allowFlowReversal_layers=allowFlowReversal,
    final allowFlowReversal_HC1=allowFlowReversal,
    final allowFlowReversal_HC2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-36,-74},{0,-28}})));

  BESMod.Components.HeatingRodWithSecurityControl
                                         hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final dp_nominal=heatingRodAftBufParameters.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=QHRAftBuf_flow_nominal,
    final V=heatingRodAftBufParameters.V_hr,
    final eta=heatingRodAftBufParameters.eta_hr) if use_heatingRodAfterBuffer
    annotation (Placement(transformation(
        extent={{-12,-11},{12,11}},
        rotation=0,
        origin={62,87})));
  replaceable Generation.RecordsCollection.HeatingRodBaseDataDefinition heatingRodAftBufParameters
 if use_heatingRodAfterBuffer "Parameters for heating rod after buffer storage"
    annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={68,50})));
  AixLib.Fluid.Interfaces.PassThroughMedium passThroughMediumHRBuf(redeclare
      package Medium = Medium, allowFlowReversal=allowFlowReversal)
    if not use_heatingRodAfterBuffer
    annotation (Placement(transformation(extent={{62,62},{74,74}})));
  replaceable Generation.RecordsCollection.HeatingRodBaseDataDefinition heatingRodAftDHWParameters
 if use_heatingRodAfterDHW "Parameters for heating rod after buffer storage"
    annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={64,-40})));
  AixLib.Fluid.Interfaces.PassThroughMedium passThroughMediumHRDHW(redeclare
      package Medium = MediumDHW, allowFlowReversal=allowFlowReversal) if not
    use_heatingRodAfterDHW
    annotation (Placement(transformation(extent={{58,-28},{70,-16}})));
  BESMod.Components.HeatingRodWithSecurityControl
                                         heaAftDHW(
    redeclare package Medium = MediumDHW,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mDHW_flow_nominal,
    final m_flow_small=1E-4*abs(mDHW_flow_nominal),
    final show_T=show_T,
    final dp_nominal=heatingRodAftDHWParameters.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=QHRAftDHW_flow_nominal,
    final V=heatingRodAftDHWParameters.V_hr,
    final eta=heatingRodAftDHWParameters.eta_hr) if use_heatingRodAfterDHW
    annotation (Placement(transformation(
        extent={{-12,-11},{12,11}},
        rotation=0,
        origin={64,-5})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHRStoDHWPre_flow(final
      T_ref=293.15, final alpha=0) if dhwParameters.use_hr annotation (
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-69,-51})));
  Modelica.Blocks.Math.Gain gain(k=dhwParameters.QHR_flow_nominal)
 if dhwParameters.use_hr
    annotation (Placement(transformation(extent={{-102,-60},{-86,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHRStoBufPre_flow1(final
      T_ref=293.15, final alpha=0) if bufParameters.use_hr annotation (
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-47,35})));
  Modelica.Blocks.Math.Gain gainHRBuf(k=bufParameters.QHR_flow_nominal)
 if bufParameters.use_hr
    annotation (Placement(transformation(extent={{-80,18},{-64,36}})));
  BESMod.Components.DiscretizeContSignal  discretizeHRAftBufSto(final
      discretizationSteps=heatingRodAftDHWParameters.discretizationSteps)
 if use_heatingRodAfterBuffer
    annotation (Placement(transformation(extent={{36,88},{44,96}})));
  BESMod.Components.DiscretizeContSignal  discretizeHRAftDHWSto(final
      discretizationSteps=heatingRodAftDHWParameters.discretizationSteps)
 if use_heatingRodAfterDHW
    annotation (Placement(transformation(extent={{34,-2},{42,6}})));
  BESMod.Components.DiscretizeContSignal  discretizeHRInDHWSto(final
      discretizationSteps=dhwParameters.discretizationStepsHR)
    if dhwParameters.use_hr
    annotation (Placement(transformation(extent={{-120,-54},{-112,-46}})));
  BESMod.Components.DiscretizeContSignal  discretizeHRInBufSto(final
      discretizationSteps=bufParameters.discretizationStepsHR)
    if bufParameters.use_hr
    annotation (Placement(transformation(extent={{-100,24},{-92,32}})));

  Components.Valves.ThreeWayValveWithFlowReturn threeWayValveWithFlowReturn(
    redeclare package Medium = MediumGen,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve parameters=threeWayValveParameters)
    annotation (Placement(transformation(extent={{-84,54},{-64,74}})));

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
    annotation (Placement(transformation(extent={{-52,-134},{-32,-96}})));
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
    annotation (Placement(transformation(extent={{-52,-154},{-32,-116}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal[1],
    tau=temperatureSensorData.tau,
    initType=temperatureSensorData.initType,
    T_start=T_start,
    final transferHeat=temperatureSensorData.transferHeat,
    TAmb=temperatureSensorData.TAmb,
    tauHeaTra=temperatureSensorData.tauHeaTra)
    "Temperature at supply for building" annotation (Placement(transformation(
        extent={{5,6},{-5,-6}},
        rotation=180,
        origin={87,80})));

  IBPSA.Fluid.Sensors.TemperatureTwoPort senTBuiSup1(
    redeclare final package Medium = MediumDHW,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mDHW_flow_nominal,
    tau=temperatureSensorData.tau,
    initType=temperatureSensorData.initType,
    T_start=T_start,
    final transferHeat=temperatureSensorData.transferHeat,
    TAmb=temperatureSensorData.TAmb,
    tauHeaTra=temperatureSensorData.tauHeaTra)
    "Temperature at supply for building" annotation (Placement(transformation(
        extent={{5,6},{-5,-6}},
        rotation=180,
        origin={81,-22})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
equation
  connect(T_stoDHWBot.y, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{-16.4,
          95},{2.5,95},{2.5,101},{0,101}},              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoDHWTop.y, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-14.3,
          70},{-2,70},{-2,101},{0,101}},              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoBufBot.y, sigBusDistr.TStoBufBotMea) annotation (Line(points={{-16.4,
          79},{0,79},{0,101}},                      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoBufTop.y, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-16.4,
          87},{0,87},{0,101}},                                  color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(fixedTemperatureDHW.port, storageDHW.heatportOutside) annotation (
      Line(points={{-62,-88},{14,-88},{14,-49.62},{-0.45,-49.62}},color={191,0,0}));
  connect(storageBuf.heatportOutside, fixedTemperatureBuf.port) annotation (
      Line(points={{-0.45,37.32},{12,37.32},{12,2},{-70,2}},color={191,0,0}));
  connect(portDHW_in, storageDHW.fluidportBottom2) annotation (Line(points={{100,
          -82},{-12,-82},{-12,-74.23},{-12.825,-74.23}}, color={0,127,255}));
  connect(hea.port_a, storageBuf.fluidportTop2) annotation (Line(points={{50,87},
          {48,87},{48,68},{-12.375,68},{-12.375,58.22}}, color={0,127,255},
      pattern=LinePattern.Dash));
  connect(passThroughMediumHRBuf.port_a, storageBuf.fluidportTop2) annotation (
      Line(points={{62,68},{-12.375,68},{-12.375,58.22}}, color={0,127,255},
      pattern=LinePattern.Dash));
  connect(heaAftDHW.port_a, storageDHW.fluidportTop2) annotation (Line(points={{
          52,-5},{34,-5},{34,-24},{-12.375,-24},{-12.375,-27.77}}, color={0,127,
          255},
      pattern=LinePattern.Dash));
  connect(passThroughMediumHRDHW.port_a, storageDHW.fluidportTop2) annotation (
      Line(points={{58,-22},{46,-22},{46,-24},{-12.375,-24},{-12.375,-27.77}},
        color={0,127,255},
      pattern=LinePattern.Dash));
  connect(portBui_in[1], storageBuf.fluidportBottom2) annotation (Line(points={{100,
          40},{102,40},{102,22},{26,22},{26,4},{-12.825,4},{-12.825,13.78}},
        color={0,127,255}));
  connect(storageDHW.heatingRod, QHRStoDHWPre_flow.port) annotation (Line(
      points={{-36,-51},{-62,-51}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(QHRStoDHWPre_flow.Q_flow, gain.y) annotation (Line(
      points={{-76,-51},{-85.2,-51}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(QHRStoBufPre_flow1.Q_flow, gainHRBuf.y) annotation (Line(
      points={{-54,35},{-58,35},{-58,27},{-63.2,27}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(QHRStoBufPre_flow1.port, storageBuf.heatingRod) annotation (Line(
      points={{-40,35},{-40,36},{-36,36}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(discretizeHRAftBufSto.u, sigBusDistr.uHRAftBuf) annotation (Line(
        points={{35.2,92},{0,92},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(discretizeHRAftBufSto.y, hea.u) annotation (Line(points={{44.4,92},{
          47.6,92},{47.6,93.6}},
                            color={0,0,127}));
  connect(heaAftDHW.u, discretizeHRAftDHWSto.y) annotation (Line(points={{49.6,1.6},
          {46,1.6},{46,2},{42.4,2}}, color={0,0,127}));
  connect(discretizeHRAftDHWSto.u, sigBusDistr.uHRAftDHW) annotation (Line(
        points={{33.2,2},{34,2},{34,84},{0,84},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(discretizeHRInBufSto.u, sigBusDistr.uHRStoBuf) annotation (Line(
        points={{-100.8,28},{-116,28},{-116,101},{0,101}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(discretizeHRInBufSto.y, gainHRBuf.u) annotation (Line(points={{-91.6,
          28},{-88,28},{-88,27},{-81.6,27}},
                                         color={0,0,127}));
  connect(discretizeHRInDHWSto.u, sigBusDistr.uHRStoDHW) annotation (Line(
        points={{-120.8,-50},{-126,-50},{-126,101},{0,101}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(gain.u, discretizeHRInDHWSto.y) annotation (Line(points={{-103.6,-51},
          {-108,-51},{-108,-50},{-111.6,-50}}, color={0,0,127}));
  connect(portGen_in[1], threeWayValveWithFlowReturn.portGen_a) annotation (
      Line(points={{-100,80},{-92,80},{-92,68.4},{-84,68.4}}, color={0,127,255}));
  connect(portGen_out[1], threeWayValveWithFlowReturn.portGen_b) annotation (
      Line(points={{-100,40},{-96,40},{-96,38},{-92,38},{-92,60},{-84,60},{-84,60.4}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, storageDHW.portHC1In)
    annotation (Line(points={{-64,60.4},{-60,60.4},{-60,60},{-46,60},{-46,-37.89},
          {-36.45,-37.89}}, color={0,127,255}));
  connect(storageDHW.portHC1Out, threeWayValveWithFlowReturn.portDHW_a)
    annotation (Line(points={{-36.225,-45.02},{-52,-45.02},{-52,56.4},{-64,56.4}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
     Line(points={{-74,76},{-74,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(internalKPICalculatorBufLoss.KPIBus, outBusDist.QBufLoss) annotation (
     Line(
      points={{-31.8,-115},{0,-115},{0,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(internalKPICalculatorDHWLoss.KPIBus, outBusDist.QDHWLoss) annotation (
     Line(
      points={{-31.8,-135},{-16,-135},{-16,-136},{0,-136},{0,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTBuiSup.port_a, hea.port_b)
    annotation (Line(points={{82,80},{74,80},{74,87}}, color={0,127,255}));
  connect(senTBuiSup.port_b, portBui_out[1]) annotation (Line(points={{92,80},{
          100,80}},               color={0,127,255}));
  connect(heaAftDHW.port_b, senTBuiSup1.port_a) annotation (Line(points={{76,-5},
          {76,-22}},                color={0,127,255}));
  connect(portDHW_out, senTBuiSup1.port_b) annotation (Line(points={{100,-22},{
          86,-22}},              color={0,127,255}));
  connect(senTBuiSup.T, sigBusDistr.TBuiSupMea) annotation (Line(points={{87,
          86.6},{86,86.6},{86,102},{28,102},{28,76},{0,76},{0,101}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(passThroughMediumHRBuf.port_b, senTBuiSup.port_a)
    annotation (Line(points={{74,68},{82,68},{82,80}}, color={0,127,255}));
  connect(passThroughMediumHRDHW.port_b, senTBuiSup1.port_a)
    annotation (Line(points={{70,-22},{76,-22}}, color={0,127,255}));
  connect(senTBuiSup1.T, sigBusDistr.TDHWSupMea) annotation (Line(points={{81,
          -15.4},{81,12},{100,12},{100,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
end PartialDistributionTwoStorageParallelDetailed;
