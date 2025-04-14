within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialTwoStorageParallel
  "Partial model to later extent"
  extends BaseClasses.PartialThreeWayValve(
    final dpDHWHCSto_design=stoDHW.dpHC1Fixed_nominal,
    final dTTraDHW_nominal=parStoDHW.dTLoadingHC1,
    final QDHWStoLoss_flow_estimate=BESMod.Systems.Hydraulical.Distribution.RecordsCollection.GetDailyStorageLossesForLabel(VDHWDay_nominal, parStoDHW.energyLabel)/24*1000,
    final dTTra_nominal={parStoBuf.dTLoadingHC1},
    final QDHWStoLoss_flow=parStoDHW.QLoss_flow);
  parameter Modelica.Units.SI.PressureDifference dpBufToDem_design
    "Design pressure difference of components on demand side for pump sizing"
     annotation(Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.TemperatureDifference dTLoaHCBuf
    "Temperature difference for loading of heating coil in buffer storage";

  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    parTemSen
    constrainedby
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition(iconName="T-Sensors")
    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{44,164},{56,176}})));

  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition parStoBuf
    constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    iconName="Buffer",
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
    choicesAllMatching=true,
    Placement(transformation(extent={{44,144},{56,156}})));

  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition parStoDHW
               constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    iconName="DHW",
    final Q_flow_nominal=0,
    final VPerQ_flow=0,
    final rho=rho,
    final c_p=cp,
    V=VStoDHW,
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
    choicesAllMatching=true,
    Placement(transformation(extent={{64,144},{76,156}})));

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.DPVar parPumTra
    constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition(iconName="Pump Tra")
    "Parameters for pump feeding transfer system"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{84,144},{96,156}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        parStoBuf.TAmb) "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={4,20})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(
      final T=if use_dhw then parStoDHW.TAmb else TDHW_nominal)
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
    m2_flow_nominal=mDem_flow_design[1],
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
    final allowFlowReversal_HC2=allowFlowReversal,
    final computePressureLossInternally=false,
    final fac=1)                                   "Buffer storage"
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
    final allowFlowReversal_HC2=allowFlowReversal,
    final computePressureLossInternally=false,
    final fac=1)                                              "DHW storage"
    annotation (Placement(transformation(extent={{-50,-70},{-18,-30}})));

  BESMod.Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  BESMod.Utilities.KPIs.EnergyKPICalculator eneKPICalDHW(final use_inpCon=false, y=
        fixTemDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mDem_flow_nominal[1],
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

  BESMod.Utilities.KPIs.EnergyKPICalculator eneKPICalDHWHeaRod(use_inpCon=false, y=
        QHRStoDHWPre_flow.Q_flow) if parStoDHW.use_hr     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-170})));
  BESMod.Utilities.KPIs.EnergyKPICalculator eneKPICalBufHeaRod(use_inpCon=false, y=
        QHRStoBufPre_flow.Q_flow) if parStoBuf.use_hr
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=4)                           annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-49,-111})));
  BESMod.Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-110})));
  BESMod.Systems.Hydraulical.Distribution.Components.ConditionalPrescibedHeater heaRodBuf(Q_flow_nominal=parStoBuf.QHR_flow_nominal,
      useHeater=parStoBuf.use_hr) "Heating rod in buffer storage"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  BESMod.Systems.Hydraulical.Distribution.Components.ConditionalPrescibedHeater heaRodparStoDHW(Q_flow_nominal=
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
    final dp_nominal=dpDem_design[1] + dpBufToDem_design,
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
        origin={70,40})));

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
        origin={0,-70})));
  IBPSA.Fluid.Sources.Boundary_pT bouNoDHW(
    redeclare package Medium = MediumDHW,
    final p=p_start,
    final T=T_start,
    nPorts=1) if not use_dhw "Boundary to disable DHW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-30})));
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
initial algorithm
  assert(parStoDHW.qHC1_flow_nominal * 1000 > 0.25, "In " + getInstanceName() +
      ": Storage heat exchanger is probably to small and the calculated heat 
      transfer coefficient to high. VDI 4645 suggests at least 0.25 m2/kW, 
      you have " + String(parStoDHW.qHC1_flow_nominal * 1000) + "m2/W", AssertionLevel.warning);
equation
  connect(fixTemDHW.port, stoDHW.heatportOutside) annotation (Line(points={{-10,-50},
          {-10,-48.8},{-18.4,-48.8}},                               color={191,0,0}));
  connect(stoBuf.heatportOutside, fixTemBuf.port) annotation (Line(points={{-18.4,
          21.2},{-18.4,20},{-6,20}},       color={191,0,0}));
  if use_dhw then
  connect(portDHW_in, stoDHW.fluidportBottom2) annotation (Line(points={{100,-82},
          {-29.4,-82},{-29.4,-70.2}}, color={0,127,255}));
  connect(stoDHW.fluidportTop2, portDHW_out) annotation (Line(points={{-29,-29.8},
          {-29,-22},{100,-22}},                   color={0,127,255}));
  end if;
  connect(senTBuiSup.port_b, portBui_out[1]) annotation (Line(points={{86,80},{100,
          80}},                   color={0,127,255}));
  connect(senTBuiSup.T, sigBusDistr.TBuiSupMea) annotation (Line(points={{76,91},
          {76,102},{0,102},{0,101}},                                 color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
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
  connect(multiSum.y, realToElecCon.PEleLoa)
    annotation (Line(points={{-38.47,-111},{-38.47,-110},{-40,-110},{-40,-106},
          {18,-106}},                                 color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{40.2,-109.8},{56,-109.8},{56,-98},{70,-98}},
      color={0,0,0},
      thickness=1));

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
  connect(heaRodparStoDHW.PEleHea, multiSum.u[1]) annotation (Line(points={{-69,-57},
          {-66,-57},{-66,-113.363},{-58,-113.363}},      color={0,0,127}));
  connect(heaRodBuf.PEleHea, multiSum.u[2]) annotation (Line(points={{-69,13},{
          -64,13},{-64,-108},{-58,-108},{-58,-111.787}},
                                                     color={0,0,127}));
  connect(pumTra.y, sigBusDistr.uPumTra) annotation (Line(points={{70,52},{70,101},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumTra.port_a, portBui_in[1])
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(resValToDHWSto.port_b, stoDHW.portHC1In) annotation (Line(points={{0,140},
          {12,140},{12,108},{-58,108},{-58,-38.6},{-50.4,-38.6}}, color={0,127,255}));
  connect(stoDHW.portHC1Out, threeWayValveWithFlowReturn.portDHW_a) annotation (
     Line(points={{-50.2,-44.8},{-62,-44.8},{-62,110},{-36,110},{-36,142.4},{-40,
          142.4}}, color={0,127,255}));
  connect(pumTra.on, sigBusDistr.pumTraOn) annotation (Line(points={{75,52},{75,
          60},{70,60},{70,101},{0,101}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

  connect(multiSum.u[3], pumGen.P) annotation (Line(points={{-58,-110.213},{-70,
          -110.213},{-70,-110},{-126,-110},{-126,102},{-74,102},{-74,109}},
        color={0,0,127}));
  connect(pumTra.P, multiSum.u[4]) annotation (Line(points={{59,46},{72,46},{72,
          102},{-126,102},{-126,-108.637},{-58,-108.637}}, color={0,0,127}));
  connect(bouNoDHW.ports[1], stoDHW.fluidportTop2) annotation (Line(points={{-10,
          -30},{-10,-22},{-29,-22},{-29,-29.8}}, color={0,127,255}));
  connect(souNoDHW.ports[1], stoDHW.fluidportBottom2) annotation (Line(points={{
          -10,-70},{-12,-70.2},{-29.4,-70.2}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,180}})));
end PartialTwoStorageParallel;
