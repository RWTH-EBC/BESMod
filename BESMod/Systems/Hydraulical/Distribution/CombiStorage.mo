within BESMod.Systems.Hydraulical.Distribution;
model CombiStorage
  "Combi Storage for heating, dhw and solar assitance"
  extends BaseClasses.PartialDistribution(
    dpSup_nominal={0,sum(bufferStorage.heatingCoil2.pipe.res.dp_nominal)},
    final dpDem_nominal={0},
    final VStoDHW=parameters.V,
    final QDHWStoLoss_flow=parameters.QLoss_flow,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    dTTraDHW_nominal=parameters.dTLoadingHC1,
    final m_flow_nominal=mDem_flow_nominal,
    dTTra_nominal={0},
    final TSup_nominal=fill(TDem_nominal[1] .+ dTLoss_nominal[1] .+ dTTra_nominal[1], nParallelSup),
    final nParallelSup=2,
    final nParallelDem=1);

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureBuf(final T=
        parameters.TAmb)                     annotation (Placement(transformation(
        extent={{-12,12},{12,-12}},
        rotation=180,
        origin={62,-50})));

  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
    parameters constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    final QHC1_flow_nominal=QDHW_flow_nominal,
    final rho=rho,
    final TAmb=TAmb,
    final c_p=cp,
    final mHC2_flow_nominal=mSup_flow_nominal[2],
    final mHC1_flow_nominal=mDHW_flow_nominal,
    final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
    final QHC2_flow_nominal=Q_flow_nominal[1]*f_design[1],
    final T_m=TSup_nominal[1])
    annotation (choicesAllMatching=true, Placement(transformation(extent={{82,56},
            {96,70}})));

  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final mSenFac=1,
    redeclare final package MediumHC1 = MediumDHW,
    redeclare final package MediumHC2 = Medium,
    final m1_flow_nominal=mSup_flow_nominal[1],
    final m2_flow_nominal=mDem_flow_nominal[1],
    final mHC1_flow_nominal=parameters.mHC1_flow_nominal,
    final mHC2_flow_nominal=parameters.mHC2_flow_nominal,
    final useHeatingCoil1=true,
    final useHeatingCoil2=true,
    final useHeatingRod=parameters.use_hr,
    final TStart=T_start,
    redeclare
      BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.bufferData
      data(
      final hTank=parameters.h,
      hHC1Low=0,
      final dTank=parameters.d,
      final sWall=parameters.sIns/2,
      final sIns=parameters.sIns/2,
      final lambdaWall=parameters.lambda_ins,
      final lambdaIns=parameters.lambda_ins,
      final rhoIns=373,
      final cIns=1000,
      pipeHC1=parameters.pipeHC1,
      pipeHC2=parameters.pipeHC2,
      lengthHC1=parameters.lengthHC1,
      lengthHC2=parameters.lengthHC2),
    final n=parameters.nLayer,
    final hConIn=parameters.hConIn,
    final hConOut=parameters.hConOut,
    final hConHC1=parameters.hConHC1,
    final hConHC2=parameters.hConHC2,
    final upToDownHC1=false,
    final upToDownHC2=true,
    final TStartWall=T_start,
    final TStartIns=T_start,
    redeclare model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferBuoyancyWetter,
    final allowFlowReversal_layers=allowFlowReversal,
    final allowFlowReversal_HC1=allowFlowReversal,
    final allowFlowReversal_HC2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-34,-30},{26,46}})));
  Modelica.Blocks.Sources.Constant const_dhwHROn(k=parameters.QHR_flow_nominal)
 if parameters.use_hr
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-132,-84})));
  Modelica.Blocks.Sources.Constant const_dhwHROff(final k=0) if parameters.use_hr
                                                             annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-132,-62})));
  Modelica.Blocks.Logical.Switch switch2 if parameters.use_hr
                                         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-102,-72})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                         prescribedHeatFlow
 if parameters.use_hr              annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={-62,-72})));
    Modelica.Blocks.Sources.RealExpression realExpression[parameters.nLayer](y(each final unit="K", each final displayUnit="degC")=
          bufferStorage.layer.T)
      annotation (Placement(transformation(extent={{-42,-122},{-22,-102}})));

  BESMod.Utilities.KPIs.InternalKPICalculator internalKPICalculatorBufLoss(
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
    annotation (Placement(transformation(extent={{-76,-124},{-56,-86}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
equation
  connect(fixedTemperatureBuf.port, bufferStorage.heatportOutside) annotation (
      Line(points={{50,-50},{34,-50},{34,10.28},{25.25,10.28}},
        color={191,0,0}));
  connect(bufferStorage.TTop, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-34,
          41.44},{-46,41.44},{-46,101},{0,101}},                   color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_in[2], bufferStorage.portHC2In) annotation (Line(
      points={{-100,82.5},{-74,82.5},{-74,-1.5},{-34.375,-1.5}},
      color={255,255,0},
      thickness=0.5));
  connect(portGen_out[2], bufferStorage.portHC2Out) annotation (Line(
      points={{-100,42.5},{-100,20},{-62,20},{-62,-13.66},{-34.375,-13.66}},
      color={255,255,0},
      thickness=0.5));

  connect(prescribedHeatFlow.port, bufferStorage.heatingRod)
    annotation (Line(points={{-50,-72},{-44,-72},{-44,8},{-34,8}},
                                                           color={191,0,0}));
  connect(switch2.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-91,-72},
          {-74,-72}},               color={0,0,127}));
  connect(const_dhwHROn.y, switch2.u1) annotation (Line(points={{-125.4,-84},{-120,
          -84},{-120,-80},{-114,-80}},
                                  color={0,0,127}));
  connect(switch2.u3, const_dhwHROff.y) annotation (Line(points={{-114,-64},{-122,
          -64},{-122,-62},{-125.4,-62}},
                                  color={0,0,127}));
  connect(sigBusDistr.dhwHR_on, switch2.u2) annotation (Line(
      points={{0,101},{-122,101},{-122,-72},{-114,-72}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufferStorage.TTop, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-34,
          41.44},{-46,41.44},{-46,101},{0,101}},                   color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufferStorage.TBottom, sigBusDistr.TStoBufBotMea) annotation (Line(
        points={{-34,-22.4},{-46,-22.4},{-46,100},{0,100},{0,101}},
                                                               color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufferStorage.TBottom, sigBusDistr.TStoDHWBotMea) annotation (Line(
        points={{-34,-22.4},{-46,-22.4},{-46,101},{0,101}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_in[1], bufferStorage.fluidportTop1) annotation (Line(points={{-100,
          77.5},{-100,76},{-16,76},{-16,58},{-14.5,58},{-14.5,46.38}},
                                              color={0,127,255}));
  connect(bufferStorage.fluidportBottom1, portGen_out[1]) annotation (Line(
        points={{-14.125,-30.76},{-14.125,-44},{-86,-44},{-86,37.5},{-100,37.5}},
        color={0,127,255}));
  connect(bufferStorage.fluidportTop2, portBui_out[1]) annotation (Line(points={{5.375,
          46.38},{5.375,80},{100,80}},        color={0,127,255}));
  connect(portBui_in[1], bufferStorage.fluidportBottom2) annotation (Line(points={{100,40},
          {100,14},{26,14},{26,-40},{4.625,-40},{4.625,-30.38}},
        color={0,127,255}));
  connect(bufferStorage.portHC1In, portDHW_in) annotation (Line(points={{-34.75,
          29.66},{-50,29.66},{-50,-82},{100,-82}},        color={0,127,255}));
  connect(portDHW_out, bufferStorage.portHC1Out) annotation (Line(points={{100,-22},
          {18,-22},{18,-62},{-38,-62},{-38,17.88},{-34.375,17.88}},
        color={0,127,255}));
    connect(realExpression.y, outBusDist.TSto) annotation (Line(points={{-21,
            -112},{0,-112},{0,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

  connect(internalKPICalculatorBufLoss.KPIBus, outBusDist.QStoLoss) annotation (
     Line(
      points={{-55.8,-105},{-48,-105},{-48,-90},{-14,-90},{-14,-86},{0,-86},{0,
          -100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
end CombiStorage;
