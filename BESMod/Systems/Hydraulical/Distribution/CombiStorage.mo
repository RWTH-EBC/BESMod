within BESMod.Systems.Hydraulical.Distribution;
model CombiStorage
  "Combi Storage for heating, dhw and solar assitance"
  extends BaseClasses.PartialDistribution(
    dpSup_nominal={0,sum(bufSto.heatingCoil2.pipe.res.dp_nominal)},
    final dpDem_nominal={0},
    final VStoDHW=parameters.V,
    final QDHWStoLoss_flow=parameters.QLoss_flow,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,

    dTTraDHW_nominal=parameters.dTLoadingHC1,
    final m_flow_nominal=mDem_flow_nominal,
    dTTra_nominal={0},
    final TSup_nominal=fill(TDem_nominal[1] .+ dTLoss_nominal[1] .+
        dTTra_nominal[1], nParallelSup),
    final nParallelSup=2,
    final nParallelDem=1);

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTempBuf(final T=
        parameters.TAmb) "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,10})));

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

  AixLib.Fluid.Storage.BufferStorage bufSto(
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
    annotation (Placement(transformation(extent={{-26,0},{22,60}})));
  Modelica.Blocks.Sources.Constant conDHWHeaRodOn(k=parameters.QHR_flow_nominal)
    if parameters.use_hr annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-54,-82})));
  Modelica.Blocks.Sources.Constant conDHWHeaRodOff(final k=0)
    if parameters.use_hr annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,-82})));
  Modelica.Blocks.Logical.Switch switch2 if parameters.use_hr
                                         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,-48})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                         prescribedHeatFlow
 if parameters.use_hr              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-18})));
  Modelica.Blocks.Sources.RealExpression reaExpTSen[parameters.nLayer](y(
      each final unit="K",
      each final displayUnit="degC") = bufSto.layer.T)
    "Temperatures of all layers"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Utilities.KPIs.EnergyKPICalculator eneKPICal(use_inpCon=false, y=fixTempBuf.port.Q_flow)
    "Energy KPI calculator"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
equation
  connect(fixTempBuf.port, bufSto.heatportOutside) annotation (Line(points={{40,
          10},{30,10},{30,31.8},{21.4,31.8}}, color={191,0,0}));
  connect(bufSto.TTop, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-26,
          56.4},{-40,56.4},{-40,74},{0,74},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_in[2], bufSto.portHC2In) annotation (Line(
      points={{-100,82.5},{-66,82.5},{-66,22},{-46,22},{-46,22.5},{-26.3,22.5}},

      color={255,255,0},
      thickness=0.5));
  connect(portGen_out[2], bufSto.portHC2Out) annotation (Line(
      points={{-100,42.5},{-78,42.5},{-78,14},{-52,14},{-52,12.9},{-26.3,12.9}},

      color={255,255,0},
      thickness=0.5));

  connect(prescribedHeatFlow.port, bufSto.heatingRod)
    annotation (Line(points={{-70,-8},{-70,30},{-26,30}}, color={191,0,0}));
  connect(switch2.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-70,-37},
          {-70,-28}},               color={0,0,127}));
  connect(conDHWHeaRodOn.y, switch2.u1) annotation (Line(points={{-54,-71},{-54,
          -66},{-62,-66},{-62,-60}}, color={0,0,127}));
  connect(switch2.u3, conDHWHeaRodOff.y)
    annotation (Line(points={{-78,-60},{-90,-60},{-90,-71}}, color={0,0,127}));
  connect(sigBusDistr.dhwHR_on, switch2.u2) annotation (Line(
      points={{0,101},{0,70},{-54,70},{-54,-66},{-70,-66},{-70,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufSto.TTop, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-26,
          56.4},{-42,56.4},{-42,92},{0,92},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufSto.TBottom, sigBusDistr.TStoBufBotMea) annotation (Line(points={{
          -26,6},{-42,6},{-42,90},{0,90},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufSto.TBottom, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{
          -26,6},{-42,6},{-42,90},{0,90},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_in[1], bufSto.fluidportTop1) annotation (Line(points={{-100,
          77.5},{-88,77.5},{-88,76},{-52,76},{-52,74},{-50,74},{-50,60},{-30,60},
          {-30,68},{-10.4,68},{-10.4,60.3}}, color={0,127,255}));
  connect(bufSto.fluidportBottom1, portGen_out[1]) annotation (Line(points={{
          -10.1,-0.6},{-10.1,-6},{-86,-6},{-86,37.5},{-100,37.5}}, color={0,127,
          255}));
  connect(bufSto.fluidportTop2, portBui_out[1]) annotation (Line(points={{5.5,
          60.3},{4,60.3},{4,76},{84,76},{84,80},{100,80}}, color={0,127,255}));
  connect(portBui_in[1], bufSto.fluidportBottom2) annotation (Line(points={{100,
          40},{32,40},{32,-6},{4.9,-6},{4.9,-0.3}}, color={0,127,255}));
  connect(bufSto.portHC1In, portDHW_in) annotation (Line(points={{-26.6,47.1},{
          -26.6,46},{-40,46},{-40,-82},{100,-82}}, color={0,127,255}));
  connect(portDHW_out, bufSto.portHC1Out) annotation (Line(points={{100,-22},{
          -34,-22},{-34,37.8},{-26.3,37.8}}, color={0,127,255}));
  connect(reaExpTSen.y, outBusDist.TSto) annotation (Line(points={{41,-50},{64,
          -50},{64,-84},{0,-84},{0,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{60,-70},{70,-70},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(eneKPICal.KPI, outBusDist.QStoLos_flow) annotation (Line(points={{2.2,
          -50},{8,-50},{8,-80},{0,-80},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end CombiStorage;
