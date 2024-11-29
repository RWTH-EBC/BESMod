within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialTwoStorageParallel "Partial model to later extent"
  extends BaseClasses.PartialDistribution(
    Q_flow_design={if use_old_design[i] then QOld_flow_design[i] else
        Q_flow_nominal[i] for i in 1:nParallelDem},
    m_flow_design={if use_old_design[i] then mOld_flow_design[i] else
        m_flow_nominal[i] for i in 1:nParallelDem},
    mSup_flow_design={if use_old_design[i] then mSupOld_flow_design[i] else
        mSup_flow_nominal[i] for i in 1:nParallelSup},
    mDem_flow_design={if use_old_design[i] then mDemOld_flow_design[i] else
        mDem_flow_nominal[i] for i in 1:nParallelDem},
    final mOld_flow_design=mDemOld_flow_design,
    final dpDem_nominal={0},
    final dpSup_nominal={parThrWayVal.dpValve_nominal + max(parThrWayVal.dp_nominal)},
    final dTTraDHW_nominal=parStoDHW.dTLoadingHC1,
    final dTTra_nominal={parStoBuf.dTLoadingHC1},
    final m_flow_nominal=mDem_flow_nominal,
    final VStoDHW=parStoDHW.V,
    final QDHWStoLoss_flow=parStoDHW.QLoss_flow,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    final nParallelSup=1,
    final nParallelDem=1);

  parameter Boolean use_old_design[nParallelDem]=fill(false, nParallelDem)
    "If true, design parameters of the building with no retrofit (old state) are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.TemperatureDifference dTLoaHCBuf
    "Temperature difference for loading of heating coil in buffer storage"
      annotation(Dialog(group="Component data"));
  parameter Modelica.Units.SI.PressureDifference dpBufHCSto_nominal
    "Nominal pressure difference in buffer storage heating coil";
  final parameter Modelica.Units.SI.PressureDifference dpDHWHCSto_nominal=sum(
      stoDHW.heatingCoil1.pipe.res.dp_nominal)
    "Nominal pressure difference in DHW storage heating coil";

  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    parTemSen(iconName="T-Sensors")
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{84,164},{96,176}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve parThrWayVal(iconName=
        "ThreeWayValve")
    constrainedby BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={dpBufHCSto_nominal,dpDHWHCSto_nominal},
    final m_flow_nominal=mSup_flow_design[1],
    final fraK=1,
    use_inputFilter=false) "Parameters for three way valve" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{84,144},{96,156}})));

  replaceable parameter
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition parStoBuf(iconName=
        "Buffer")
    constrainedby
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    final Q_flow_nominal=Q_flow_design[1]*f_design[1],
    final rho=rho,
    final c_p=cp,
    final dTLoadingHC1=dTLoaHCBuf,
    final TAmb=TAmb,
    T_m=TSup_nominal[1],
    final QHC1_flow_nominal=Q_flow_design[1]*f_design[1],
    final mHC1_flow_nominal=mSup_flow_design[1],
    final use_HC2=stoBuf.useHeatingCoil2,
    final use_HC1=stoBuf.useHeatingCoil1,
    final dTLoadingHC2=9999999,
    final fHeiHC2=1,
    final fDiaHC2=1,
    final QHC2_flow_nominal=9999999,
    final mHC2_flow_nominal=9999999)
    "Parameters for buffer storage" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{44,164},{56,176}})));

  replaceable parameter
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition parStoDHW(iconName=
        "DHW")
    if use_dhw constrainedby
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    final Q_flow_nominal=0,
    final VPerQ_flow=0,
    final rho=rho,
    final c_p=cp,
    V=if designType == Types.DHWDesignType.FullStorage then VDHWDay*
        fFullSto else VDHWDay,
    final TAmb=TAmb,
    T_m=TDHW_nominal,
    final QHC1_flow_nominal=QDHW_flow_nominal,
    final mHC1_flow_nominal=mSup_flow_design[1],
    final use_HC2=stoDHW.useHeatingCoil2,
    final use_HC1=stoDHW.useHeatingCoil1,
    final dTLoadingHC2=dTLoadingHC2,
    fHeiHC2=1,
    fDiaHC2=1,
    final QHC2_flow_nominal=QHC2_flow_nominal,
    final mHC2_flow_nominal=mHC2_flow_nominal)
    "Parameters for DHW storage" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{64,144},{76,156}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        parStoBuf.TAmb) "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={4,20})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoDHWTop(final y(
      unit="K",
      displayUnit="degC") = stoDHW.layer[parStoDHW.nLayer].T) if use_dhw
    "Directly access temperature layer" annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-70,150})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoBufTop(final y(
      unit="K",
      displayUnit="degC") = stoBuf.layer[parStoBuf.nLayer].T)
    "Directly access temperature layer " annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-70,167})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoBufBot(final y(
      unit="K",
      displayUnit="degC") = stoBuf.layer[1].T)
    "Directly access temperature layer" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-70,159})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoDHWBot(final y(
      unit="K",
      displayUnit="degC") = stoDHW.layer[1].T) if use_dhw
    "Directly access temperature layer " annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-70,175})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(final T=
        parStoDHW.TAmb) if use_dhw
                        "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-50})));

  AixLib.Fluid.Storage.StorageDetailed stoBuf(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final mSenFac=1,
    redeclare package MediumHC1 = MediumGen,
    redeclare package MediumHC2 = MediumGen,
    final m1_flow_nominal=mSup_flow_design[1],
    final m2_flow_nominal=m_flow_design[1],
    final mHC1_flow_nominal=parStoBuf.mHC1_flow_nominal,
    final mHC2_flow_nominal=parStoBuf.mHC2_flow_nominal,
    final useHeatingCoil2=false,
    final useHeatingRod=parStoBuf.use_hr,
    TStart=fill(T_start, parStoBuf.nLayer),
    redeclare final RecordsCollection.BufferStorage.bufferData data(
      final hTank=parStoBuf.h,
      hHC1Low=0,
      hHR=parStoBuf.nLayerHR/parStoBuf.nLayer*parStoBuf.h,
      final dTank=parStoBuf.d,
      final sWall=parStoBuf.sIns/2,
      final sIns=parStoBuf.sIns/2,
      final lambdaWall=parStoBuf.lambda_ins,
      final lambdaIns=parStoBuf.lambda_ins,
      final rhoIns=373,
      final cIns=1000,
      pipeHC1=parStoBuf.pipeHC1,
      pipeHC2=parStoBuf.pipeHC2,
      lengthHC1=parStoBuf.lengthHC1,
      lengthHC2=parStoBuf.lengthHC2),
    final n=parStoBuf.nLayer,
    final hConIn=parStoBuf.hConIn,
    final hConOut=parStoBuf.hConOut,
    final hConHC1=parStoBuf.hConHC1,
    final hConHC2=parStoBuf.hConHC2,
    upToDownHC1=true,
    upToDownHC2=true,
    final TStartWall=T_start,
    final TStartIns=T_start,
    nLowerPortSupply=1,
    nUpperPortSupply=parStoBuf.nLayer,
    nLowerPortDemand=1,
    nUpperPortDemand=parStoBuf.nLayer,
    nTS1=1,
    nTS2=parStoBuf.nLayer,
    nHC1Up=parStoBuf.nLayer,
    nHC1Low=1,
    nHR=parStoBuf.nLayerHR,
    redeclare model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferBuoyancyWetter,
    final allowFlowReversal_layers=allowFlowReversal,
    final allowFlowReversal_HC1=allowFlowReversal,
    final allowFlowReversal_HC2=allowFlowReversal) "Buffer storage"
    annotation (Placement(transformation(extent={{-50,0},{-18,40}})));

  AixLib.Fluid.Storage.StorageDetailed stoDHW(
    redeclare final package Medium = MediumDHW,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final mSenFac=1,
    redeclare final package MediumHC1 = MediumGen,
    redeclare final package MediumHC2 = MediumGen,
    final m1_flow_nominal=mSup_flow_design[1],
    final m2_flow_nominal=mDHW_flow_nominal,
    final mHC1_flow_nominal=parStoDHW.mHC1_flow_nominal,
    final mHC2_flow_nominal=parStoDHW.mHC2_flow_nominal,
    final useHeatingCoil1=true,
    final useHeatingCoil2=use_secHeaCoiDHWSto,
    final useHeatingRod=parStoDHW.use_hr,
    TStart=fill(TDHW_nominal, parStoDHW.nLayer),
    redeclare final RecordsCollection.BufferStorage.bufferData data(
      final hTank=parStoDHW.h,
      hHC1Low=0,
      hHR=parStoDHW.nLayerHR/parStoDHW.nLayer*parStoDHW.h,
      final dTank=parStoDHW.d,
      final sWall=parStoDHW.sIns/2,
      final sIns=parStoDHW.sIns/2,
      final lambdaWall=parStoDHW.lambda_ins,
      final lambdaIns=parStoDHW.lambda_ins,
      final rhoIns=373,
      final cIns=1000,
      pipeHC1=parStoDHW.pipeHC1,
      pipeHC2=parStoDHW.pipeHC2,
      lengthHC1=parStoDHW.lengthHC1,
      lengthHC2=parStoDHW.lengthHC2),
    final n=parStoDHW.nLayer,
    final hConIn=parStoDHW.hConIn,
    final hConOut=parStoDHW.hConOut,
    final hConHC1=parStoDHW.hConHC1,
    final hConHC2=parStoDHW.hConHC2,
    final upToDownHC1=true,
    final upToDownHC2=true,
    final TStartWall=T_start,
    final TStartIns=T_start,
    nLowerPortSupply=1,
    nUpperPortSupply=parStoDHW.nLayer,
    nLowerPortDemand=1,
    nUpperPortDemand=parStoDHW.nLayer,
    nTS1=1,
    nTS2=parStoDHW.nLayer,
    nHC1Up=parStoDHW.nLayer,
    nHC1Low=1,
    nHR=parStoDHW.nLayerHR,
    redeclare model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferBuoyancyWetter,
    final allowFlowReversal_layers=allowFlowReversal,
    final allowFlowReversal_HC1=allowFlowReversal,
    final allowFlowReversal_HC2=allowFlowReversal) if use_dhw "DHW storage"
    annotation (Placement(transformation(extent={{-50,-70},{-18,-30}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHRStoDHWPre_flow(final
      T_ref=293.15, final alpha=0) if parStoDHW.use_hr and use_dhw
                                                           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-50})));
  Modelica.Blocks.Math.Gain gain(k=parStoDHW.QHR_flow_nominal)
    if parStoDHW.use_hr and use_dhw
    annotation (Placement(transformation(extent={{-112,-60},{-92,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHRStoBufPre_flow(final
      T_ref=293.15, final alpha=0) if parStoBuf.use_hr     annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,20})));
  Modelica.Blocks.Math.Gain gainHRBuf(k=parStoBuf.QHR_flow_nominal)
    if parStoBuf.use_hr
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Components.Valves.ThreeWayValveWithFlowReturn threeWayValveWithFlowReturn(
    redeclare package Medium = MediumGen,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters=parThrWayVal)
    annotation (Placement(transformation(extent={{-40,54},{-20,74}})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHW(final use_inpCon=false, y=
        fixTemDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal[1],
    tau=parTemSen.tau,
    initType=parTemSen.initType,
    T_start=T_start,
    final transferHeat=parTemSen.transferHeat,
    TAmb=parTemSen.TAmb,
    tauHeaTra=parTemSen.tauHeaTra)
    "Temperature at supply for building" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={76,80})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalDHWHeaRod(use_inpCon=false, y=
        QHRStoDHWPre_flow.Q_flow) if parStoDHW.use_hr     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-170})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalBufHeaRod(use_inpCon=false, y=
        QHRStoBufPre_flow.Q_flow) if parStoBuf.use_hr
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  AixLib.Fluid.Interfaces.PassThroughMedium pasThrNoDHW(redeclare package
      Medium =
        Medium, allowFlowReversal=allowFlowReversal) if not use_dhw
    "Pass through if DHW is disabled" annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=270,
        origin={-6,54})));
  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_nominal=m_flow_design[1],
    final dp_nominal=dpDem_nominal[1] + dp_nominal[1],
    final addPowerToMedium=parPum.addPowerToMedium,
    final tau=parPum.tau,
    final use_inputFilter=parPum.use_inputFilter,
    final riseTime=parPum.riseTimeInpFilter,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-70,60})));
  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1) "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,120})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPum(iconName=
        "Pumps")
    "Parameters for pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{64,164},{76,176}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=3)                           annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-49,-111})));
  Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-110})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThr[2]
    "For conditional heaters" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-90})));
  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pumpTra(
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
    final use_inputFilter=parPum.use_inputFilter,
    final riseTime=parPum.riseTimeInpFilter,
    final y_start=1) "Pump to transfer system" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,40})));
protected
  parameter Boolean use_secHeaCoiDHWSto
    "=false to disable second heating coil in DHW storage";
  parameter Modelica.Units.SI.TemperatureDifference dTLoadingHC2=9999999
    "Temperature difference for loading of first heating coil";
  parameter Modelica.Units.SI.HeatFlowRate QHC2_flow_nominal=9999999
    "Nominal heat flow rate in second heating coil";
  parameter Modelica.Units.SI.MassFlowRate mHC2_flow_nominal=9999999
    "Nominal mass flow rate of HC fluid";
  Modelica.Blocks.Sources.Constant constZero(final k=0);
equation
  connect(reaExpTStoDHWBot.y, sigBusDistr.TStoDHWBotMea) annotation (Line(
        points={{-59,175},{-60,175},{-60,176},{0,176},{0,101}},
                                                      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpTStoDHWTop.y, sigBusDistr.TStoDHWTopMea) annotation (Line(
        points={{-59,150},{0,150},{0,101}},
                                          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpTStoBufBot.y, sigBusDistr.TStoBufBotMea) annotation (Line(
        points={{-59,159},{0,159},{0,101}},
                                          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpTStoBufTop.y, sigBusDistr.TStoBufTopMea) annotation (Line(
        points={{-59,167},{0,167},{0,101}},
                                          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(fixTemDHW.port, stoDHW.heatportOutside) annotation (Line(points={{-10,-50},
          {-10,-48.8},{-18.4,-48.8}},                               color={191,0,0}));
  connect(stoBuf.heatportOutside, fixTemBuf.port) annotation (Line(points={{-18.4,
          21.2},{-18.4,20},{-6,20}},       color={191,0,0}));
  connect(portDHW_in, stoDHW.fluidportBottom2) annotation (Line(points={{100,-82},
          {-29.4,-82},{-29.4,-70.2}}, color={0,127,255}));
  connect(stoDHW.heatingRod, QHRStoDHWPre_flow.port) annotation (Line(
      points={{-50,-50},{-60,-50}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(QHRStoDHWPre_flow.Q_flow, gain.y) annotation (Line(
      points={{-80,-50},{-91,-50}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(QHRStoBufPre_flow.Q_flow, gainHRBuf.y) annotation (Line(
      points={{-72,20},{-79,20}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(QHRStoBufPre_flow.port, stoBuf.heatingRod) annotation (Line(
      points={{-52,20},{-50,20}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(portGen_in[1], threeWayValveWithFlowReturn.portGen_a) annotation (
      Line(points={{-100,80},{-48,80},{-48,68.4},{-40,68.4}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, stoDHW.portHC1In) annotation (
      Line(points={{-20,60.4},{-20,62},{0,62},{0,44},{-14,44},{-14,-8},{-50.4,
          -8},{-50.4,-38.6}},
        color={0,127,255}));
  connect(stoDHW.portHC1Out, threeWayValveWithFlowReturn.portDHW_a) annotation (
      Line(points={{-50.2,-44.8},{-50.2,-46},{-54,-46},{-54,-8},{-14,-8},{-14,
          56.4},{-20,56.4}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
     Line(points={{-30,76},{-30,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTBuiSup.port_b, portBui_out[1]) annotation (Line(points={{86,80},{100,
          80}},                   color={0,127,255}));
  connect(senTBuiSup.T, sigBusDistr.TBuiSupMea) annotation (Line(points={{76,91},{
          76,104},{4,104},{4,102},{0,102},{0,101}},                  color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(stoDHW.fluidportTop2, portDHW_out) annotation (Line(points={{-29,
          -29.8},{-29,-26},{-30,-26},{-30,-22},{100,-22}},
                                                  color={0,127,255}));
  connect(eneKPICalBuf.KPI, outBusDist.QBufLos_flow) annotation (Line(points={{-57.8,
          -150},{0,-150},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(eneKPICalDHW.KPI, outBusDist.QDHWLos_flow) annotation (Line(points={{-77.8,
          -130},{0,-130},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(eneKPICalBufHeaRod.KPI, outBusDist.PEleHRPreBuf) annotation (Line(
        points={{-77.8,-170},{-54,-170},{-54,-136},{0,-136},{0,-100}},
                                                 color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(eneKPICalDHWHeaRod.KPI, outBusDist.PEleHRPreDHW) annotation (Line(
        points={{-37.8,-170},{0,-170},{0,-100}},color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gain.u, sigBusDistr.uHRStoDHW) annotation (Line(points={{-114,-50},{-120,
          -50},{-120,102},{0,102},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(gainHRBuf.u, sigBusDistr.uHRStoBuf) annotation (Line(points={{-102,20},
          {-120,20},{-120,102},{0,102},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(threeWayValveWithFlowReturn.portDHW_b, pasThrNoDHW.port_a) annotation (
      Line(points={{-20,60.4},{-20,60},{-6,60},{-6,58}},
                           color={0,127,255},
      pattern=LinePattern.Dash));
  connect(pasThrNoDHW.port_b, threeWayValveWithFlowReturn.portDHW_a) annotation (
      Line(points={{-6,50},{-6,48},{-14,48},{-14,56.4},{-20,56.4}},
                                    color={0,127,255},
      pattern=LinePattern.Dash));
  connect(bouPum.ports[1],pump. port_a)
    annotation (Line(points={{-60,120},{-58,120},{-58,60},{-60,60}},
                                                          color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portGen_b, pump.port_a) annotation (Line(
        points={{-40,60.4},{-42,60.4},{-42,60},{-60,60}}, color={0,127,255}));
  connect(pump.port_b, portGen_out[1]) annotation (Line(points={{-80,60},{-100,60},
          {-100,40}}, color={0,127,255}));
  connect(pump.y, sigBusDistr.uPump) annotation (Line(points={{-70,72},{-120,72},
          {-120,102},{-2,102},{-2,101},{0,101}},
                               color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiSum.y, realToElecCon.PEleLoa)
    annotation (Line(points={{-38.47,-111},{-38.47,-110},{-40,-110},{-40,-106},
          {18,-106}},                                 color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{40.2,-109.8},{56,-109.8},{56,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(pump.P, multiSum.u[1]) annotation (Line(points={{-81,69},{-82,69},{
          -82,102},{-120,102},{-120,-113.1},{-58,-113.1}},
                                                       color={0,0,127}));
  connect(reaPasThr.y, multiSum.u[2:3]) annotation (Line(points={{-69,-90},{-62,
          -90},{-62,-108.9},{-58,-108.9}},           color={0,0,127}));
  if parStoDHW.use_hr and use_dhw then
    connect(reaPasThr[1].u, gain.y) annotation (Line(points={{-92,-90},{-100,
            -90},{-100,-68},{-91,-68},{-91,-50}},     color={0,0,127}));
  else
    connect(reaPasThr[1].u, constZero.y);
  end if;
  if parStoBuf.use_hr then
    connect(reaPasThr[2].u, gainHRBuf.y) annotation (Line(points={{-92,-90},{
            -120,-90},{-120,4},{-79,4},{-79,20}},
                         color={0,0,127}));
  else
    connect(reaPasThr[2].u, constZero.y);
  end if;
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,180}})));
end PartialTwoStorageParallel;
