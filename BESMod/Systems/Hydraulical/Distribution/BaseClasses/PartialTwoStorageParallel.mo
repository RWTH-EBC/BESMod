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
  parameter Modelica.Units.SI.PressureDifference dpValBufSto_nominal
    "Nominal pressure drop between valve and buffer storage"
    annotation (Dialog(tab="Pressure Drops"));
  parameter Modelica.Units.SI.PressureDifference dpValDHWSto_nominal
    "Nominal pressure drop between valve and DHW storage"
    annotation (Dialog(tab="Pressure Drops"));
  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    parTemSen(iconName="T-Sensors")
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{84,164},{96,176}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve parThrWayVal(iconName=
        "3WayValve")
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
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));

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
        extent={{-2,-2},{2,2}},
        rotation=270,
        origin={-34,144})));
  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    nPorts=1)       "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,170})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPumGen(iconName="Pump Gen")
    "Parameters for pump feeding supply system (generation)" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{64,164},{76,176}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2)                           annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-49,-111})));
  Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-110})));
  Components.ConditionalPrescibedHeater heaRodBuf(Q_flow_nominal=parStoBuf.QHR_flow_nominal,
      useHeater=parStoBuf.use_hr) "Heating rod in buffer storage"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Components.ConditionalPrescibedHeater heaRodparStoDHW(Q_flow_nominal=
        parStoDHW.QHR_flow_nominal, useHeater=parStoDHW.use_hr)
    "Heating rod in DHW storage"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
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
        origin={70,40})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPumTra(
    iconName="Pump Tra",
    externalCtrlTyp=BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.speed,
    ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar)
    constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    "Parameters for pump feeding transfer system"
                                           annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{84,124},{96,136}})));

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
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,120})));
  IBPSA.Fluid.FixedResistances.PressureDrop resValToBufSto(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=dpValBufSto_nominal,
    final linearized=false,
    final deltaM=0.3)
    "Pressure drop due to resistances between valve+pump and buffer storage"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  IBPSA.Fluid.FixedResistances.PressureDrop resValToDHWSto(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=dpValDHWSto_nominal,
    final linearized=false,
    final deltaM=0.3)
    "Pressure drop due to resistances between valve+pump and DHW storage"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
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
  connect(fixTemDHW.port, stoDHW.heatportOutside) annotation (Line(points={{-10,-50},
          {-10,-48.8},{-18.4,-48.8}},                               color={191,0,0}));
  connect(stoBuf.heatportOutside, fixTemBuf.port) annotation (Line(points={{-18.4,
          21.2},{-18.4,20},{-6,20}},       color={191,0,0}));
  connect(portDHW_in, stoDHW.fluidportBottom2) annotation (Line(points={{100,-82},
          {-29.4,-82},{-29.4,-70.2}}, color={0,127,255}));
  connect(portGen_in[1], threeWayValveWithFlowReturn.portGen_a) annotation (
      Line(points={{-100,80},{-90,80},{-90,154.4},{-60,154.4}},
                                                              color={0,127,255}));
  connect(stoDHW.portHC1Out, threeWayValveWithFlowReturn.portDHW_a) annotation (
      Line(points={{-50.2,-44.8},{-60,-44.8},{-60,134},{-40,134},{-40,142.4}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
     Line(points={{-50,162},{-50,166},{8,166},{8,120},{0,120},{0,101}},
                                               color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTBuiSup.port_b, portBui_out[1]) annotation (Line(points={{86,80},{100,
          80}},                   color={0,127,255}));
  connect(senTBuiSup.T, sigBusDistr.TBuiSupMea) annotation (Line(points={{76,91},
          {76,102},{0,102},{0,101}},                                 color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(stoDHW.fluidportTop2, portDHW_out) annotation (Line(points={{-29,-29.8},
          {-29,-22},{100,-22}},                   color={0,127,255}));
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
        points={{-77.8,-170},{0,-170},{0,-100}}, color={135,135,135}), Text(
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
  connect(threeWayValveWithFlowReturn.portDHW_b, pasThrNoDHW.port_a) annotation (
      Line(points={{-40,146.4},{-37,146.4},{-37,146},{-34,146}},
                           color={0,127,255},
      pattern=LinePattern.Dash));
  connect(pasThrNoDHW.port_b, threeWayValveWithFlowReturn.portDHW_a) annotation (
      Line(points={{-34,142},{-37,142},{-37,142.4},{-40,142.4}},
                                    color={0,127,255},
      pattern=LinePattern.Dash));
  connect(multiSum.y, realToElecCon.PEleLoa)
    annotation (Line(points={{-38.47,-111},{-38.47,-110},{-40,-110},{-40,-106},
          {18,-106}},                                 color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{40.2,-109.8},{56,-109.8},{56,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
  if parStoDHW.use_hr and use_dhw then
  else
  end if;
  if parStoBuf.use_hr then
  else
  end if;
  connect(stoBuf.TTop, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-50,
          37.6},{-126,37.6},{-126,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(stoBuf.TBottom, sigBusDistr.TStoBufBotMea) annotation (Line(points={{-50,
          4},{-126,4},{-126,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(stoDHW.TTop, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-50,
          -32.4},{-126,-32.4},{-126,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(stoDHW.TBottom, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{-50,
          -66},{-126,-66},{-126,102},{0,102},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaRodBuf.uHea, sigBusDistr.uHRStoBuf) annotation (Line(points={{-91.8,
          20},{-126,20},{-126,102},{-84,102},{-84,101},{0,101}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaRodparStoDHW.uHea, sigBusDistr.uHRStoDHW) annotation (Line(points={
          {-91.8,-50},{-126,-50},{-126,102},{2,102},{2,101},{0,101}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaRodparStoDHW.port, stoDHW.heatingRod)
    annotation (Line(points={{-70,-50},{-50,-50}}, color={191,0,0}));
  connect(heaRodBuf.port, stoBuf.heatingRod)
    annotation (Line(points={{-70,20},{-50,20}}, color={191,0,0}));
  connect(heaRodparStoDHW.PEleHea, multiSum.u[1]) annotation (Line(points={{-69,
          -57},{-66,-57},{-66,-112.575},{-58,-112.575}}, color={0,0,127}));
  connect(heaRodBuf.PEleHea, multiSum.u[2]) annotation (Line(points={{-69,13},{-64,
          13},{-64,-108},{-58,-108},{-58,-109.425}}, color={0,0,127}));
  connect(pumTra.y, sigBusDistr.uPumTra) annotation (Line(points={{70,52},{70,101},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumGen.y, sigBusDistr.uPumGen) annotation (Line(points={{-68,120},{0,120},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_out[1], pumGen.port_b) annotation (Line(points={{-100,40},{-80,
          40},{-80,110}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portGen_b, pumGen.port_a) annotation (
      Line(points={{-60,146.4},{-80,146.4},{-80,130}}, color={0,127,255}));
  connect(bouPum.ports[1], pumGen.port_a)
    annotation (Line(points={{-80,160},{-80,130}}, color={0,127,255}));
  connect(resValToBufSto.port_a, threeWayValveWithFlowReturn.portBui_b)
    annotation (Line(points={{-20,160},{-22,160},{-22,158},{-40,158}}, color={0,
          127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, resValToDHWSto.port_a)
    annotation (Line(points={{-40,146.4},{-32,146.4},{-32,140},{-20,140}},
        color={0,127,255}));
  connect(pumTra.port_a, portBui_in[1])
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(stoDHW.portHC1In, resValToDHWSto.port_b) annotation (Line(points={{-50.4,
          -38.6},{-58,-38.6},{-58,132},{4,132},{4,140},{0,140}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,180}})));
end PartialTwoStorageParallel;
