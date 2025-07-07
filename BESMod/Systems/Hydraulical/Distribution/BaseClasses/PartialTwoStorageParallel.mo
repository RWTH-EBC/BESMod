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
    parTemSen
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{84,102},{100,118}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve parThrWayVal
    constrainedby BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={dpBufHCSto_nominal,dpDHWHCSto_nominal},
    final m_flow_nominal=mSup_flow_design[1],
    final fraK=1,
    use_strokeTime=false) "Parameters for three way valve" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-78,102},{-62,118}})));

  replaceable parameter
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition parStoBuf
    constrainedby RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
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
    Placement(transformation(extent={{2,-4},{16,10}})));

  replaceable parameter
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition parStoDHW
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
    Placement(transformation(extent={{-8,-68},{6,-54}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        parStoBuf.TAmb) "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,30})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoDHWTop(final y(
      unit="K",
      displayUnit="degC") = stoDHW.layer[parStoDHW.nLayer].T) if use_dhw
    "Directly access temperature layer" annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-30,70})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoBufTop(final y(
      unit="K",
      displayUnit="degC") = stoBuf.layer[parStoBuf.nLayer].T)
    "Directly access temperature layer " annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-30,87})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoBufBot(final y(
      unit="K",
      displayUnit="degC") = stoBuf.layer[1].T)
    "Directly access temperature layer" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-30,79})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoDHWBot(final y(
      unit="K",
      displayUnit="degC") = stoDHW.layer[1].T) if use_dhw
    "Directly access temperature layer " annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-30,95})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(final T=
        parStoDHW.TAmb) if use_dhw
                        "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-30})));

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
    redeclare replaceable model HeatTransfer =
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
    redeclare replaceable model HeatTransfer =
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
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
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

  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHWHeaRod(use_inpCon=false, y=
        QHRStoDHWPre_flow.Q_flow) if parStoDHW.use_hr     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-170})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalBufHeaRod(use_inpCon=false, y=
        QHRStoBufPre_flow.Q_flow) if parStoBuf.use_hr
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  AixLib.Fluid.Interfaces.PassThroughMedium pasThrNoDHW(redeclare package Medium =
        Medium, allowFlowReversal=allowFlowReversal) if not use_dhw
    "Pass through if DHW is disabled" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-70})));
protected
  parameter Boolean use_secHeaCoiDHWSto
    "=false to disable second heating coil in DHW storage";
  parameter Modelica.Units.SI.TemperatureDifference dTLoadingHC2=9999999
    "Temperature difference for loading of first heating coil";
  parameter Modelica.Units.SI.HeatFlowRate QHC2_flow_nominal=9999999
    "Nominal heat flow rate in second heating coil";
  parameter Modelica.Units.SI.MassFlowRate mHC2_flow_nominal=9999999
    "Nominal mass flow rate of HC fluid";
equation
  connect(reaExpTStoDHWBot.y, sigBusDistr.TStoDHWBotMea) annotation (Line(
        points={{-19,95},{2.5,95},{2.5,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpTStoDHWTop.y, sigBusDistr.TStoDHWTopMea) annotation (Line(
        points={{-19,70},{0,70},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpTStoBufBot.y, sigBusDistr.TStoBufBotMea) annotation (Line(
        points={{-19,79},{0,79},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpTStoBufTop.y, sigBusDistr.TStoBufTopMea) annotation (Line(
        points={{-19,87},{0,87},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(fixTemDHW.port, stoDHW.heatportOutside) annotation (Line(points={{-10,-30},
          {-14,-30},{-14,-44},{-12,-44},{-12,-48.8},{-18.4,-48.8}}, color={191,0,0}));
  connect(stoBuf.heatportOutside, fixTemBuf.port) annotation (Line(points={{-18.4,
          21.2},{-6,21.2},{-6,30},{0,30}}, color={191,0,0}));
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
      Line(points={{-100,80},{-92,80},{-92,74.4},{-80,74.4}}, color={0,127,255}));
  connect(portGen_out[1], threeWayValveWithFlowReturn.portGen_b) annotation (
      Line(points={{-100,40},{-96,40},{-96,38},{-92,38},{-92,60},{-80,60},{-80,66.4}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, stoDHW.portHC1In) annotation (
      Line(points={{-60,66.4},{-54,66.4},{-54,44},{-64,44},{-64,-38.6},{-50.4,-38.6}},
        color={0,127,255}));
  connect(stoDHW.portHC1Out, threeWayValveWithFlowReturn.portDHW_a) annotation (
      Line(points={{-50.2,-44.8},{-66,-44.8},{-66,42},{-56,42},{-56,62.4},{-60,62.4}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
     Line(points={{-70,82},{-70,101},{0,101}}, color={0,0,127}), Text(
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
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(stoDHW.fluidportTop2, portDHW_out) annotation (Line(points={{-29,-29.8},
          {-29,-14},{84,-14},{84,-22},{100,-22}}, color={0,127,255}));
  connect(eneKPICalBuf.KPI, outBusDist.QBufLos_flow) annotation (Line(points={{-37.8,
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
        points={{17.8,-170},{0,-170},{0,-100}}, color={135,135,135}), Text(
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
  connect(gainHRBuf.u, sigBusDistr.uHRStoBuf) annotation (Line(points={{-102,20},{
          -116,20},{-116,101},{0,101}},          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(threeWayValveWithFlowReturn.portDHW_b, pasThrNoDHW.port_a) annotation (
      Line(points={{-60,66.4},{-54,66.4},{-54,44},{-64,44},{-64,-34},{-88,-34},{-88,
          -70},{-80,-70}}, color={0,127,255}));
  connect(pasThrNoDHW.port_b, threeWayValveWithFlowReturn.portDHW_a) annotation (
      Line(points={{-60,-70},{-56,-70},{-56,-44},{-66,-44},{-66,42},{-56,42},{-56,
          62},{-60,62},{-60,62.4}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,140}})));
end PartialTwoStorageParallel;
