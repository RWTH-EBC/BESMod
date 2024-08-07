within BESMod.Systems.Hydraulical.Distribution;
model CombiStorage
  "Combi Storage for heating, dhw and solar assitance"
  extends BaseClasses.PartialDistribution(
    final dpDHW_nominal=sum(bufSto.heatingCoil1.pipe.res.dp_nominal),
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
    final TSupOld_design=fill(TDemOld_design[1] .+ dTLoss_nominal[1] .+
        dTTraOld_design[1], nParallelSup),
    final nParallelSup=2,
    final nParallelDem=1);

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTempBuf(final T=
        parameters.TAmb) "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,30})));

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
    annotation (Placement(transformation(extent={{-18,0},{20,48}})));
  Modelica.Blocks.Sources.Constant conDHWHeaRodOn(k=parameters.QHR_flow_nominal)
    if parameters.use_hr annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-52,-90})));
  Modelica.Blocks.Sources.Constant conDHWHeaRodOff(final k=0)
    if parameters.use_hr annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,-90})));
  Modelica.Blocks.Logical.Switch switch2 if parameters.use_hr
                                         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,-56})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                         prescribedHeatFlow
 if parameters.use_hr              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-56})));
  Modelica.Blocks.Sources.RealExpression reaExpTSen[parameters.nLayer](y(
      each final unit="K",
      each final displayUnit="degC") = bufSto.layer.T)
    "Temperatures of all layers"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Utilities.KPIs.EnergyKPICalculator eneKPICal(use_inpCon=false, y=fixTempBuf.port.Q_flow)
    "Energy KPI calculator"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
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
        origin={-80,28})));
  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1) "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,50})));
  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pumpSec(
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
    final y_start=1) "Pump for secondary generation device, e.g. solar thermal"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-80,-10})));
  IBPSA.Fluid.Sources.Boundary_pT bouPumSec(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1) "Pressure boundary for secondary pump" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-26})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPum
    "Parameters for pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-88,56},{-74,68}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2)                           annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={29,-69})));
  Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={38,-98})));
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
        origin={70,10})));
equation
  connect(fixTempBuf.port, bufSto.heatportOutside) annotation (Line(points={{40,30},
          {28,30},{28,25.44},{19.525,25.44}}, color={191,0,0}));
  connect(bufSto.TTop, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-18,
          45.12},{-38,45.12},{-38,92},{0,92},{0,101}},
                                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_in[2], bufSto.portHC2In) annotation (Line(
      points={{-100,82.5},{-28,82.5},{-28,18},{-18.2375,18}},
      color={255,255,0},
      thickness=0.5));

  connect(prescribedHeatFlow.port, bufSto.heatingRod)
    annotation (Line(points={{-40,-46},{-40,24},{-18,24}},color={191,0,0}));
  connect(switch2.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-70,-45},
          {-52,-45},{-52,-66},{-40,-66}},
                                    color={0,0,127}));
  connect(conDHWHeaRodOn.y, switch2.u1) annotation (Line(points={{-52,-79},{-52,
          -66},{-62,-66},{-62,-68}}, color={0,0,127}));
  connect(switch2.u3, conDHWHeaRodOff.y)
    annotation (Line(points={{-78,-68},{-90,-68},{-90,-79}}, color={0,0,127}));
  connect(sigBusDistr.dhwHR_on, switch2.u2) annotation (Line(
      points={{0,101},{0,68},{-48,68},{-48,-66},{-70,-66},{-70,-68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufSto.TTop, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-18,
          45.12},{-38,45.12},{-38,92},{0,92},{0,101}},
                                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufSto.TBottom, sigBusDistr.TStoBufBotMea) annotation (Line(points={{-18,4.8},
          {-34,4.8},{-34,92},{0,92},{0,101}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufSto.TBottom, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{-18,4.8},
          {-34,4.8},{-34,92},{0,92},{0,101}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_in[1], bufSto.fluidportTop1) annotation (Line(points={{-100,
          77.5},{-100,80},{-5.65,80},{-5.65,48.24}},
                                             color={0,127,255}));
  connect(bufSto.fluidportTop2, portBui_out[1]) annotation (Line(points={{6.9375,
          48.24},{6.9375,80},{100,80}},                    color={0,127,255}));
  connect(bufSto.portHC1In, portDHW_in) annotation (Line(points={{-18.475,37.68},
          {-20,37.68},{-20,4},{-22,4},{-22,-12},{86,-12},{86,-8},{114,-8},{114,
          -68},{100,-68},{100,-82}},               color={0,127,255}));
  connect(portDHW_out, bufSto.portHC1Out) annotation (Line(points={{100,-22},{
          -24,-22},{-24,30.24},{-18.2375,30.24}},
                                             color={0,127,255}));
  connect(reaExpTSen.y, outBusDist.TSto) annotation (Line(points={{41,-50},{64,
          -50},{64,-84},{0,-84},{0,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(eneKPICal.KPI, outBusDist.QStoLos_flow) annotation (Line(points={{2.2,
          -50},{8,-50},{8,-80},{0,-80},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bouPum.ports[1],pump. port_a)
    annotation (Line(points={{-60,40},{-60,28},{-70,28}}, color={0,127,255}));
  connect(bouPumSec.ports[1], pumpSec.port_a) annotation (Line(points={{-60,-16},
          {-60,-10},{-70,-10}}, color={0,127,255}));
  connect(pump.y, sigBusDistr.uPump) annotation (Line(points={{-80,40},{-80,52},
          {-108,52},{-108,98},{0,98},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumpSec.y, sigBusDistr.uPumpSec) annotation (Line(points={{-80,2},{
          -80,6},{-108,6},{-108,98},{0,98},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pump.port_b, portGen_out[1]) annotation (Line(points={{-90,28},{-100,
          28},{-100,37.5}}, color={0,127,255}));
  connect(pump.port_a, bufSto.fluidportBottom1) annotation (Line(points={{-70,
          28},{-64,28},{-64,-6},{-5.4125,-6},{-5.4125,-0.48}}, color={0,127,255}));
  connect(bufSto.portHC2Out, pumpSec.port_a) annotation (Line(points={{-18.2375,
          10.32},{-60,10.32},{-60,-10},{-70,-10}}, color={0,127,255}));
  connect(portGen_out[2], pumpSec.port_b) annotation (Line(points={{-100,42.5},
          {-100,-10},{-90,-10}}, color={0,127,255}));
  connect(multiSum.y,realToElecCon. PEleLoa)
    annotation (Line(points={{39.53,-69},{39.53,-68},{50,-68},{50,-94},{26,-94}},
                                                      color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{48.2,-97.8},{59.1,-97.8},{59.1,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(multiSum.u[1], pumpSec.P) annotation (Line(points={{20,-70.575},{-20,
          -70.575},{-20,-104},{-114,-104},{-114,-1},{-91,-1}}, color={0,0,127}));
  connect(multiSum.u[2], pump.P) annotation (Line(points={{20,-67.425},{-20,
          -67.425},{-20,-104},{-114,-104},{-114,37},{-91,37}}, color={0,0,127}));
  connect(pumpTra.port_a, portBui_in[1])
    annotation (Line(points={{80,10},{100,10},{100,40}}, color={0,127,255}));
  connect(pumpTra.port_b, bufSto.fluidportBottom2) annotation (Line(points={{60,
          10},{26,10},{26,-8},{6.4625,-8},{6.4625,-0.24}}, color={0,127,255}));
end CombiStorage;
