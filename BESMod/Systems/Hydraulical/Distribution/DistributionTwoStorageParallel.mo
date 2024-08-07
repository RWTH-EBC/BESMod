within BESMod.Systems.Hydraulical.Distribution;
model DistributionTwoStorageParallel
  "Buffer storage and DHW storage"
  extends BaseClasses.PartialDistribution(
    final dpDHW_nominal=0,
    final VStoDHW=parStoDHW.V,
    final QDHWStoLoss_flow=parStoDHW.QLoss_flow,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    final dpDem_nominal={0},
    dpSup_nominal={2*(parThrWayVal.dpValve_nominal + max(
        parThrWayVal.dp_nominal))},
    final dTTraDHW_nominal=parStoDHW.dTLoadingHC1,
    final dTTra_nominal={parStoBuf.dTLoadingHC1},
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    dTLoss_nominal=fill(0, nParallelDem),
    final m_flow_nominal=mDem_flow_nominal,
      nParallelSup=1,
    final nParallelDem=1);

  AixLib.Fluid.Storage.Storage stoDHW(
    redeclare final package Medium = MediumDHW,
    final n=parStoDHW.nLayer,
    final d=parStoDHW.d,
    final h=parStoDHW.h,
    final lambda_ins=parStoDHW.lambda_ins,
    final s_ins=parStoDHW.sIns,
    final hConIn=parStoDHW.hConIn,
    final hConOut=parStoDHW.hConOut,
    final k_HE=parStoDHW.k_HE,
    final A_HE=parStoDHW.A_HE,
    final V_HE=parStoDHW.V_HE,
    final beta=parStoDHW.beta,
    final kappa=parStoDHW.kappa,
    final m_flow_nominal_layer=mDHW_flow_nominal,
    final m_flow_nominal_HE=mSup_flow_nominal[1],
    final energyDynamics=energyDynamics,
    final T_start=TDHW_nominal,
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(stoDHW.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(stoDHW.m_flow_nominal_HE))
    "The DHW storage (TWWS) for domestic hot water demand"
    annotation (Placement(transformation(extent={{64,-68},{38,-28}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        parStoBuf.TAmb) "Constant ambient temperature of storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,90})));
  AixLib.Fluid.Storage.Storage stoBuf(
    redeclare package Medium = Medium,
    final n=parStoBuf.nLayer,
    final d=parStoBuf.d,
    final h=parStoBuf.h,
    final lambda_ins=parStoBuf.lambda_ins,
    final s_ins=parStoBuf.sIns,
    final hConIn=parStoBuf.hConIn,
    final hConOut=parStoBuf.hConOut,
    final k_HE=parStoBuf.k_HE,
    final A_HE=parStoBuf.A_HE,
    final V_HE=parStoBuf.V_HE,
    final beta=parStoBuf.beta,
    final kappa=parStoBuf.kappa,
    final m_flow_nominal_layer=m_flow_nominal[1],
    final m_flow_nominal_HE=mSup_flow_nominal[1],
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(stoBuf.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(stoBuf.m_flow_nominal_HE))
    "The buffer storage (PS) for the building"
    annotation (Placement(transformation(extent={{64,30},{38,70}})));
  Components.Valves.ThreeWayValveWithFlowReturn
                                            threeWayValveWithFlowReturn(
    redeclare package Medium = MediumGen,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve parameters=parThrWayVal)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.RealExpression T_stoDHWTop(final y(unit="K", displayUnit="degC")=stoDHW.layer[
        parStoDHW.nLayer].T) annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={37,87})));
  Modelica.Blocks.Sources.RealExpression T_stoBufTop(final y(unit="K", displayUnit="degC")=stoBuf.layer[
        parStoBuf.nLayer].T) annotation (Placement(transformation(
        extent={{-5,-2},{5,2}},
        rotation=180,
        origin={23,92})));
  Modelica.Blocks.Sources.RealExpression T_stoBufBot(final y(unit="K", displayUnit="degC")=stoBuf.layer[1].T)
    annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={23,87})));
  Modelica.Blocks.Sources.RealExpression T_stoDHWBot(final y(unit="K", displayUnit="degC")=stoDHW.layer[1].T)
    annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={37,99})));

  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    parStoBuf constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
        final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final T_m=TDem_nominal[1],
        final QHC1_flow_nominal=Q_flow_nominal[1],
        final mHC1_flow_nominal=mSup_flow_nominal[1])                    annotation (
      choicesAllMatching=true, Placement(transformation(extent={{84,56},{98,70}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    parStoDHW constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final QHC1_flow_nominal=QDHW_flow_nominal,
        V=if designType == Types.DHWDesignType.FullStorage then VDHWDay * fFullSto else VDHWDay,
        final Q_flow_nominal=0,
        final VPerQ_flow=0,
        final T_m=TDHW_nominal,
        final mHC1_flow_nominal=mSup_flow_nominal[1])                                          annotation (
      choicesAllMatching=true, Placement(transformation(extent={{82,-58},{98,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(final T=
        parStoDHW.TAmb) "Constant ambient temperature of storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-90})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHW(use_inpCon=false, y=fixTemDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    parThrWayVal constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={resBui.dp_nominal,  resDHW.dp_nominal},
    final m_flow_nominal=mSup_flow_nominal[1],
    final fraK=1,
    use_inputFilter=false) annotation (Placement(
        transformation(extent={{-58,4},{-42,18}})), choicesAllMatching=true);
  IBPSA.Fluid.FixedResistances.PressureDrop resBui(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=1000,
    final linearized=false,
    final deltaM=0.3)
    "Assume some pressure loss to avoid division by zero error."
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  IBPSA.Fluid.FixedResistances.PressureDrop resDHW(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=1000,
    final linearized=false,
    final deltaM=0.3)
    "Assume some pressure loss to avoid division by zero error."
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  IBPSA.Fluid.Sources.Boundary_pT bouPumTra(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    nPorts=1)
    "Pressure reference for transfer circuit as generation circuit reference is not connected (indirect loading)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,0})));
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
        origin={-76,48})));
  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1) "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,40})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPum
    "Parameters for pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-86,4},{-72,16}})));
  Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-120})));
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
  connect(fixTemBuf.port, stoBuf.heatPort) annotation (Line(points={{70,90},{74,
          90},{74,50},{61.4,50}},     color={191,0,0}));
  connect(stoBuf.port_b_consumer, portBui_out[1]) annotation (Line(points={{51,70},
          {76,70},{76,80},{100,80}},     color={0,127,255}));
  connect(stoDHW.port_b_consumer, portDHW_out) annotation (Line(points={{51,-28},
          {51,-20},{86,-20},{86,-22},{100,-22}},
                                             color={0,127,255}));
  connect(portDHW_in, stoDHW.port_a_consumer) annotation (Line(points={{100,-82},
          {51,-82},{51,-68}},               color={0,127,255}));
  connect(fixTemDHW.port, stoDHW.heatPort) annotation (Line(points={{40,-90},{
          54,-90},{54,-76},{68,-76},{68,-48},{61.4,-48}},
                                         color={191,0,0}));
  connect(T_stoDHWBot.y, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{31.5,
          99},{0,99},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoDHWTop.y, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{31.5,
          87},{28,87},{28,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoBufBot.y, sigBusDistr.TStoBufBotMea) annotation (Line(points={{17.5,
          87},{0,87},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_stoBufTop.y, sigBusDistr.TStoBufTopMea) annotation (Line(points={{17.5,
          92},{0,92},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(stoBuf.port_b_heatGenerator, threeWayValveWithFlowReturn.portBui_a)
    annotation (Line(points={{40.08,34},{-12,34},{-12,74},{-40,74}},
        color={0,127,255}));
  connect(stoDHW.port_b_heatGenerator, threeWayValveWithFlowReturn.portDHW_a)
    annotation (Line(points={{40.08,-64},{2,-64},{2,-44},{-34,-44},{-34,62.4},{
          -40,62.4}},                                               color={0,127,
          255}));
  connect(portGen_in[1], threeWayValveWithFlowReturn.portGen_a) annotation (
      Line(points={{-100,80},{-72,80},{-72,74.4},{-60,74.4}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
     Line(points={{-50,82},{-50,100},{-4,100},{-4,102},{0,102},{0,101}},
                                                                     color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(threeWayValveWithFlowReturn.portBui_b, resBui.port_a)
    annotation (Line(points={{-40,78},{-4,78},{-4,70},{0,70}},
                                               color={0,127,255}));
  connect(stoBuf.port_a_heatGenerator, resBui.port_b) annotation (Line(
        points={{40.08,67.6},{40.08,78},{28,78},{28,70},{20,70}},
                                                   color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, resDHW.port_a) annotation (
      Line(points={{-40,66.4},{-22,66.4},{-22,-30},{0,-30}}, color={0,127,255}));
  connect(stoDHW.port_a_heatGenerator, resDHW.port_b) annotation (Line(
        points={{40.08,-30.4},{30.04,-30.4},{30.04,-30},{20,-30}},
                                                      color={0,127,255}));
  connect(eneKPICalDHW.KPI, outBusDist.QDHWLos_flow) annotation (Line(points={{
          -57.8,-90},{0,-90},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(eneKPICalBuf.KPI, outBusDist.QBufLos_flow) annotation (Line(points={{
          -57.8,-50},{0,-50},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bouPum.ports[1],pump. port_a)
    annotation (Line(points={{-60,40},{-60,48},{-66,48}}, color={0,127,255}));
  connect(pump.port_b, portGen_out[1])
    annotation (Line(points={{-86,48},{-86,40},{-100,40}}, color={0,127,255}));
  connect(pump.port_a, threeWayValveWithFlowReturn.portGen_b) annotation (Line(
        points={{-66,48},{-66,58},{-60,58},{-60,66.4}}, color={0,127,255}));
  connect(pump.y, sigBusDistr.uPump) annotation (Line(points={{-76,60},{-76,101},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{40.2,-119.8},{70,-119.8},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(pump.P, realToElecCon.PEleLoa) annotation (Line(points={{-87,57},{
          -116,57},{-116,-116},{18,-116}}, color={0,0,127}));
  connect(pumpTra.port_b, stoBuf.port_a_consumer)
    annotation (Line(points={{60,10},{51,10},{51,30}}, color={0,127,255}));
  connect(bouPumTra.ports[1], pumpTra.port_a) annotation (Line(points={{40,0},{
          56,0},{56,-8},{84,-8},{84,10},{80,10}}, color={0,127,255}));
  connect(pumpTra.port_a, portBui_in[1]) annotation (Line(points={{80,10},{86,
          10},{86,40},{100,40}}, color={0,127,255}));
end DistributionTwoStorageParallel;
