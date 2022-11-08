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
    final VStoDHW=dhwParameters.V,
    final QDHWStoLoss_flow=dhwParameters.QLoss_flow,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    final nParallelSup=1,
    final nParallelDem=1);

  parameter Modelica.Units.SI.PressureDifference dpBufHCSto_nominal
    "Nominal pressure difference in buffer storage heating coil";
  final parameter Modelica.Units.SI.PressureDifference dpDHWHCSto_nominal=sum(
      storageDHW.heatingCoil1.pipe.res.dp_nominal)
    "Nominal pressure difference in DHW storage heating coil";
  parameter Modelica.Units.SI.HeatFlowRate QHRAftBuf_flow_nominal
    "Nominal heat flow rate of heating rod after DHW storage"
    annotation (Dialog(enable=use_heatingRodAfterBuffer));
  parameter Boolean use_heatingRodAfterBuffer "=false to disable the heating rod after the buffer storage";

  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    temperatureSensorData
    annotation (choicesAllMatching=true, Placement(transformation(extent={{42,-12},
            {58,4}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    threeWayValveParameters constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={dpBufHCSto_nominal, dpDHWHCSto_nominal},
    final m_flow_nominal=mSup_flow_nominal[1],
    final fraK=1,
    use_inputFilter=false) annotation (choicesAllMatching=
       true, Placement(transformation(extent={{-84,84},{-64,104}})));

 replaceable parameter
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

  replaceable parameter
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition dhwParameters
    constrainedby
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
        final Q_flow_nominal=0,
        final VPerQ_flow=0,
        final rho=rho,
        final c_p=cp,
        final V=if designType == Types.DHWDesignType.FullStorage then VDHWDay * fFullSto else VDHWDay,
        final TAmb=TAmb,
        T_m=TDHW_nominal,
        final QHC1_flow_nominal=QDHW_flow_nominal,
        final mHC1_flow_nominal=mSup_flow_nominal[1],
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1,
        final use_HC2=storageBuf.useHeatingCoil2,
        final use_HC1=storageBuf.useHeatingCoil1,
        final dTLoadingHC2=9999999,
        final fHeiHC2=1,
        final fDiaHC2=1,
        final QHC2_flow_nominal=9999999,
        final mHC2_flow_nominal=9999999,
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_10x0_6 pipeHC2) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{20,-62},{34,-48}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        bufParameters.TAmb) "Constant ambient temperature of storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-10})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoDHWTop(final y(
      unit="K",
      displayUnit="degC") = storageDHW.layer[dhwParameters.nLayer].T)
    annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-30,70})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoBufTop(final y(
      unit="K",
      displayUnit="degC") = storageBuf.layer[bufParameters.nLayer].T)
    annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-30,87})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoBufBot(final y(
      unit="K",
      displayUnit="degC") = storageBuf.layer[1].T) annotation (Placement(
        transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-30,79})));
  Modelica.Blocks.Sources.RealExpression reaExpTStoDHWBot(final y(
      unit="K",
      displayUnit="degC") = storageDHW.layer[1].T) annotation (Placement(
        transformation(
        extent={{-10,-5},{10,5}},
        rotation=0,
        origin={-30,95})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(final T=
        dhwParameters.TAmb) "Constant ambient temperature of storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-88})));

  AixLib.Fluid.Storage.BufferStorage storageBuf(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
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
      final rhoIns=373,
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
      final rhoIns=373,
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

  BESMod.Systems.Hydraulical.Components.HeatingRodWithSecurityControl hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final dp_nominal=heatingRodAftBufParameters.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=QHRAftBuf_flow_nominal,
    final V=heatingRodAftBufParameters.V_hr,
    final eta=heatingRodAftBufParameters.eta_hr) if use_heatingRodAfterBuffer
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,90})));
  replaceable Generation.RecordsCollection.HeatingRodBaseDataDefinition heatingRodAftBufParameters
    if use_heatingRodAfterBuffer
    "Parameters for heating rod after buffer storage"
    annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={66,40})));
  AixLib.Fluid.Interfaces.PassThroughMedium passThroughMediumHRBuf(redeclare
      package Medium = Medium, allowFlowReversal=allowFlowReversal)
    if not use_heatingRodAfterBuffer
    annotation (Placement(transformation(extent={{40,54},{60,74}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHRStoDHWPre_flow(final
      T_ref=293.15, final alpha=0) if dhwParameters.use_hr annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-50})));
  Modelica.Blocks.Math.Gain gain(k=dhwParameters.QHR_flow_nominal)
 if dhwParameters.use_hr
    annotation (Placement(transformation(extent={{-112,-60},{-92,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHRStoBufPre_flow(final
      T_ref=293.15, final alpha=0) if bufParameters.use_hr annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,30})));
  Modelica.Blocks.Math.Gain gainHRBuf(k=bufParameters.QHR_flow_nominal)
 if bufParameters.use_hr
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Components.Valves.ThreeWayValveWithFlowReturn threeWayValveWithFlowReturn(
    redeclare package Medium = MediumGen,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve parameters=threeWayValveParameters)
    annotation (Placement(transformation(extent={{-84,54},{-64,74}})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHW(final use_inpCon=false, y=
        fixTemDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
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
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={76,80})));

  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHWHeaRod(use_inpCon=false, y=
        QHRStoDHWPre_flow.Q_flow) if dhwParameters.use_hr annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-170})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalAftBufHeaRod(use_inpCon=true)
    if use_heatingRodAfterBuffer annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-130})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalBufHeaRod(use_inpCon=false, y=
        QHRStoBufPre_flow.Q_flow) if bufParameters.use_hr
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
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
  connect(fixTemDHW.port, storageDHW.heatportOutside) annotation (Line(points={{
          -60,-88},{14,-88},{14,-49.62},{-0.45,-49.62}}, color={191,0,0}));
  connect(storageBuf.heatportOutside, fixTemBuf.port) annotation (Line(points={{
          -0.45,37.32},{-0.45,36},{4,36},{4,-12},{2,-12},{2,-10},{-60,-10}},
        color={191,0,0}));
  connect(portDHW_in, storageDHW.fluidportBottom2) annotation (Line(points={{100,
          -82},{-12,-82},{-12,-74.23},{-12.825,-74.23}}, color={0,127,255}));
  connect(hea.port_a, storageBuf.fluidportTop2) annotation (Line(points={{40,90},
          {28,90},{28,64},{-12.375,64},{-12.375,58.22}}, color={0,127,255},
      pattern=LinePattern.Dash));
  connect(passThroughMediumHRBuf.port_a, storageBuf.fluidportTop2) annotation (
      Line(points={{40,64},{-12.375,64},{-12.375,58.22}}, color={0,127,255},
      pattern=LinePattern.Dash));
  connect(portBui_in[1], storageBuf.fluidportBottom2) annotation (Line(points={{100,
          40},{102,40},{102,22},{26,22},{26,4},{-12.825,4},{-12.825,13.78}},
        color={0,127,255}));
  connect(storageDHW.heatingRod, QHRStoDHWPre_flow.port) annotation (Line(
      points={{-36,-51},{-48,-51},{-48,-50},{-60,-50}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(QHRStoDHWPre_flow.Q_flow, gain.y) annotation (Line(
      points={{-80,-50},{-91,-50}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(QHRStoBufPre_flow.Q_flow, gainHRBuf.y) annotation (Line(
      points={{-80,30},{-79,30},{-79,10}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(QHRStoBufPre_flow.port, storageBuf.heatingRod) annotation (Line(
      points={{-60,30},{-40,30},{-40,36},{-36,36}},
      color={191,0,0},
      pattern=LinePattern.Dash));
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
  connect(senTBuiSup.port_a, hea.port_b)
    annotation (Line(points={{66,80},{64,80},{64,90},{60,90}},
                                                       color={0,127,255}));
  connect(senTBuiSup.port_b, portBui_out[1]) annotation (Line(points={{86,80},{100,
          80}},                   color={0,127,255}));
  connect(senTBuiSup.T, sigBusDistr.TBuiSupMea) annotation (Line(points={{76,91},
          {76,100},{64,100},{64,104},{4,104},{4,102},{0,102},{0,101}},
                                                                     color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(passThroughMediumHRBuf.port_b, senTBuiSup.port_a)
    annotation (Line(points={{60,64},{64,64},{64,80},{66,80}},
                                                       color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(storageDHW.fluidportTop2, portDHW_out) annotation (Line(points={{-12.375,
          -27.77},{-12.375,-20},{100,-20},{100,-22}}, color={0,127,255}));
  connect(hea.Pel, eneKPICalAftBufHeaRod.u) annotation (Line(points={{61,96},{61,
          94},{66,94},{66,104},{114,104},{114,-130},{41.8,-130}}, color={0,0,127}));
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
  connect(eneKPICalAftBufHeaRod.KPI, outBusDist.PEleHRAftBuf) annotation (Line(
        points={{17.8,-130},{0,-130},{0,-100}}, color={135,135,135}), Text(
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
  connect(gainHRBuf.u, sigBusDistr.uHRStoBuf) annotation (Line(points={{-102,10},
          {-120,10},{-120,102},{0,102},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hea.u, sigBusDistr.uHRAftBuf) annotation (Line(points={{38,96},{32,96},
          {32,100},{0,100},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,100}})));
end PartialDistributionTwoStorageParallelDetailed;
