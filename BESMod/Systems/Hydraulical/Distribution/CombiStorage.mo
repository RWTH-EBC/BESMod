within BESMod.Systems.Hydraulical.Distribution;
model CombiStorage
  "Combi Storage for heating, dhw and solar assitance"
  extends BaseClasses.PartialDistribution(
    final dpDHW_nominal=sum(bufSto.heatingCoil1.pipe.res.dp_nominal),
    final VStoDHW=parSto.V,
    final QDHWStoLoss_flow=parSto.QLoss_flow,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    dTTraDHW_nominal=parSto.dTLoadingHC1,
    dTTra_nominal={0},
    final TSup_nominal=fill(TDem_nominal[1] .+ dTLoss_nominal[1] .+
        dTTra_nominal[1], nParallelSup),
    final TSupOld_design=fill(TDemOld_design[1] .+ dTLoss_nominal[1] .+
        dTTraOld_design[1], nParallelSup),
    final nParallelSup=2,
    final nParallelDem=1);
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.DPVar parPumGen constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition (iconName="Pump Gen",
      externalCtrlTyp=BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.onOff)
    "Parameters for pump feeding supply system (generation)" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{26,84},{38,96}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.DPVar parPumTra
    constrainedby BESMod.Systems.RecordsCollection.Movers.DPVar(    iconName="Pump Tra")
    "Parameters for pump feeding transfer system"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{64,84},{76,96}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Movers.DPVar parPumGenSec constrainedby
    BESMod.Systems.RecordsCollection.Movers.DPVar(iconName="Pump Sec Gen",
      externalCtrlTyp=BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.onOff)
    "Parameters for second pump feeding supply system (generation)" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{84,84},{96,96}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
    parSto constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    final QHC1_flow_nominal=QDHW_flow_nominal,
    final rho=rho,
    final TAmb=TAmb,
    final c_p=cp,
    final mHC2_flow_nominal=mSup_flow_design[2],
    final mHC1_flow_nominal=mDHW_flow_nominal,
    final Q_flow_nominal=Q_flow_design[1]*f_design[1],
    final QHC2_flow_nominal=Q_flow_design[1]*f_design[1],
    final T_m=TSup_nominal[1]) "Combi storage parameters" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{44,84},{56,96}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTempBuf(final T=
        parSto.TAmb) "Constant ambient temperature of storage" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,50})));


  AixLib.Fluid.Storage.StorageDetailed bufSto(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final mSenFac=1,
    redeclare final package MediumHC1 = MediumDHW,
    redeclare final package MediumHC2 = Medium,
    final m1_flow_nominal=mSup_flow_design[1],
    final m2_flow_nominal=mDem_flow_design[1],
    final mHC1_flow_nominal=parSto.mHC1_flow_nominal,
    final mHC2_flow_nominal=parSto.mHC2_flow_nominal,
    final useHeatingCoil1=true,
    final useHeatingCoil2=true,
    final useHeatingRod=parSto.use_hr,
    final TStart=fill(T_start, parSto.nLayer),
    redeclare
      BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.bufferData
      data(
      final hTank=parSto.h,
      hHC1Low=0,
      final dTank=parSto.d,
      final sWall=parSto.sIns/2,
      final sIns=parSto.sIns/2,
      final lambdaWall=parSto.lambda_ins,
      final lambdaIns=parSto.lambda_ins,
      final rhoIns=373,
      final cIns=1000,
      pipeHC1=parSto.pipeHC1,
      pipeHC2=parSto.pipeHC2,
      lengthHC1=parSto.lengthHC1,
      lengthHC2=parSto.lengthHC2),
    final n=parSto.nLayer,
    final hConIn=parSto.hConIn,
    final hConOut=parSto.hConOut,
    final hConHC1=parSto.hConHC1,
    final hConHC2=parSto.hConHC2,
    final upToDownHC1=false,
    final upToDownHC2=true,
    final TStartWall=T_start,
    final TStartIns=T_start,
    redeclare model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferBuoyancyWetter,
    final allowFlowReversal_layers=allowFlowReversal,
    final allowFlowReversal_HC1=allowFlowReversal,
    final allowFlowReversal_HC2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-12,20},{20,60}})));
  Modelica.Blocks.Sources.RealExpression reaExpTSen[parSto.nLayer](y(
      each final unit="K",
      each final displayUnit="degC") = bufSto.layer.T)
    "Temperatures of all layers"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  BESMod.Utilities.KPIs.EnergyKPICalculator eneKPICal(use_inpCon=false, y=fixTempBuf.port.Q_flow)
    "Energy KPI calculator"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  IBPSA.Fluid.Sources.Boundary_pT bouPumSec(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    nPorts=1)       "Pressure boundary for secondary pump" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-50})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=4)                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-70})));
  BESMod.Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-68})));
  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
    pumGen(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_design[1],
    final dp_nominal=dpSup_design[1],
    final externalCtrlTyp=parPumGen.externalCtrlTyp,
    final ctrlType=parPumGen.ctrlType,
    final dpVarBase_nominal=parPumGen.dpVarBase_nominal,
    final addPowerToMedium=parPumGen.addPowerToMedium,
    final use_riseTime=parPumGen.use_riseTime,
    final riseTime=parPumGen.riseTime,
    final y_start=1) "Pump for supply system (generation)" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,10})));
  IBPSA.Fluid.Sources.Boundary_pT bouPumGen(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    nPorts=1) "Pressure boundary for pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-10})));

  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
    pumTra(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mDem_flow_design[1],
    final dp_nominal=dpDem_design[1],
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
        origin={70,10})));
  Components.ConditionalPrescibedHeater                                         heaRodBuf(
      Q_flow_nominal=parSto.QHR_flow_nominal, useHeater=parSto.use_hr)
                                  "Heating rod in buffer storage"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
    pumGenSec(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_design[2],
    final dp_nominal=dpSup_design[2] + sum(bufSto.heatingCoil2.pipe.res.dp_nominal),
    final externalCtrlTyp=parPumGenSec.externalCtrlTyp,
    final ctrlType=parPumGenSec.ctrlType,
    final dpVarBase_nominal=parPumGenSec.dpVarBase_nominal,
    final addPowerToMedium=parPumGenSec.addPowerToMedium,
    final use_riseTime=parPumGenSec.use_riseTime,
    final riseTime=parPumGenSec.riseTime,
    final y_start=1) "Pump for second supply system (generation)" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,-30})));

equation
  connect(fixTempBuf.port, bufSto.heatportOutside) annotation (Line(points={{40,50},
          {30,50},{30,41.2},{19.6,41.2}},     color={191,0,0}));
  connect(bufSto.TTop, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-12,
          57.6},{-34,57.6},{-34,102},{0,102},{0,101}},
                                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(bufSto.TTop, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-12,
          57.6},{-34,57.6},{-34,102},{0,102},{0,101}},
                                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufSto.TBottom, sigBusDistr.TStoBufBotMea) annotation (Line(points={{-12,24},
          {-34,24},{-34,102},{0,102},{0,101}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bufSto.TBottom, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{-12,24},
          {-34,24},{-34,102},{0,102},{0,101}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_in[1], bufSto.fluidportTop1) annotation (Line(points={{-100,77.5},
          {-100,72},{-1.6,72},{-1.6,60.2}},  color={0,127,255}));
  connect(bufSto.fluidportTop2, portBui_out[1]) annotation (Line(points={{9,60.2},
          {9,80},{100,80}},                                color={0,127,255}));
  connect(bufSto.portHC1In, portDHW_in) annotation (Line(points={{-12.4,51.4},{-22,
          51.4},{-22,-24},{84,-24},{84,-82},{100,-82}},
                                                   color={0,127,255}));
  connect(portDHW_out, bufSto.portHC1Out) annotation (Line(points={{100,-22},{-20,
          -22},{-20,45.2},{-12.2,45.2}},     color={0,127,255}));
  connect(reaExpTSen.y, outBusDist.TSto) annotation (Line(points={{-39,-90},{-16,
          -90},{-16,-100},{0,-100}},       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(eneKPICal.KPI, outBusDist.QStoLos_flow) annotation (Line(points={{-77.8,
          -80},{-6,-80},{-6,-100},{0,-100}},      color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(multiSum.y,realToElecCon. PEleLoa)
    annotation (Line(points={{21.7,-70},{30,-70},{30,-64},{38,-64}},
                                                      color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{60.2,-67.8},{70,-67.8},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(pumGen.y, sigBusDistr.uPumGen) annotation (Line(points={{-70,22},{-30,
          22},{-30,102},{-4,102},{-4,101},{0,101}},
                    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumGen.on, sigBusDistr.pumGenOn) annotation (Line(points={{-65,22},{-110,
          22},{-110,102},{0,102},{0,101}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bouPumGen.ports[1], pumGen.port_a)
    annotation (Line(points={{-40,0},{-40,10},{-60,10}}, color={0,127,255}));
  connect(portGen_out[1],pumGen. port_b) annotation (Line(points={{-100,37.5},{-86,
          37.5},{-86,10},{-80,10}},
                          color={0,127,255}));
  connect(bufSto.fluidportBottom1, pumGen.port_a) annotation (Line(points={{-1.4,
          19.6},{-1.4,10},{-60,10}},
        color={0,127,255}));
  connect(pumTra.port_a, portBui_in[1])
    annotation (Line(points={{80,10},{100,10},{100,40}},
                                                color={0,127,255}));
  connect(pumTra.P, multiSum.u[1]) annotation (Line(points={{59,16},{26,16},{26,
          -42},{-24,-42},{-24,-72.625},{0,-72.625}},
                                           color={0,0,127}));
  connect(pumTra.on, sigBusDistr.pumTraOn) annotation (Line(points={{75,22},{75,
          101},{0,101}},                 color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaRodBuf.PEleHea, multiSum.u[2]) annotation (Line(points={{-39,33},{-24,
          33},{-24,-70.875},{0,-70.875}},            color={0,0,127}));
  connect(heaRodBuf.port, bufSto.heatingRod)
    annotation (Line(points={{-40,40},{-12,40}}, color={191,0,0}));
  connect(heaRodBuf.uHea, sigBusDistr.dhwHeaRodOn) annotation (Line(points={{-61.8,
          40},{-68,40},{-68,102},{-2,102},{-2,101},{0,101}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumTra.port_b, bufSto.fluidportBottom2) annotation (Line(points={{60,10},
          {8.6,10},{8.6,19.8}},               color={0,127,255}));
  connect(bufSto.portHC2In, portGen_in[2]) annotation (Line(points={{-12.2,35},{
          -36,35},{-36,72},{-100,72},{-100,82.5}},
                                           color={0,127,255}));
  connect(pumGenSec.y, sigBusDistr.uPumGenSec) annotation (Line(points={{-70,-18},
          {-110,-18},{-110,102},{0,102},{0,101}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumGenSec.on, sigBusDistr.pumGenOnSec) annotation (Line(points={{-65,-18},
          {-110,-18},{-110,102},{0,102},{0,101}},              color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumGenSec.port_b, portGen_out[2]) annotation (Line(points={{-80,-30},{
          -86,-30},{-86,38},{-98,38},{-98,42.5},{-100,42.5}},
                                      color={0,127,255}));
  connect(pumGenSec.port_a, bufSto.portHC2Out) annotation (Line(points={{-60,-30},
          {-18,-30},{-18,28.6},{-12.2,28.6}},
                                            color={0,127,255}));
  connect(bouPumSec.ports[1], pumGenSec.port_a)
    annotation (Line(points={{-40,-40},{-40,-30},{-60,-30}},
                                                         color={0,127,255}));
  connect(pumGenSec.P, multiSum.u[3]) annotation (Line(points={{-81,-24},{-94,-24},
          {-94,-68},{-48,-68},{-48,-69.125},{0,-69.125}},
                                    color={0,0,127}));
  connect(pumGen.P, multiSum.u[4]) annotation (Line(points={{-81,16},{-94,16},{-94,
          -68},{-48,-68},{-48,-67.375},{0,-67.375}},
                                   color={0,0,127}));
end CombiStorage;
