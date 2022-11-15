within BESMod.Systems.Hydraulical.Distribution;
model DistributionTwoStorageParallel
  "Buffer storage and DHW storage"
  extends BaseClasses.PartialDistribution(
    final VStoDHW=dhwParameters.V,
    final QDHWStoLoss_flow=dhwParameters.QLoss_flow,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    final dpDem_nominal={0},
    final dpSup_nominal={2*(threeWayValveParameters.dpValve_nominal + max(
        threeWayValveParameters.dp_nominal))},
    final dTTraDHW_nominal=dhwParameters.dTLoadingHC1,
    final dTTra_nominal={bufParameters.dTLoadingHC1},
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    dTLoss_nominal=fill(0, nParallelDem),
    final m_flow_nominal=mDem_flow_nominal,
    final nParallelSup=1,
    final nParallelDem=1);

  AixLib.Fluid.Storage.Storage storageDHW(
    redeclare final package Medium = MediumDHW,
    final n=dhwParameters.nLayer,
    final d=dhwParameters.d,
    final h=dhwParameters.h,
    final lambda_ins=dhwParameters.lambda_ins,
    final s_ins=dhwParameters.sIns,
    final hConIn=dhwParameters.hConIn,
    final hConOut=dhwParameters.hConOut,
    final k_HE=dhwParameters.k_HE,
    final A_HE=dhwParameters.A_HE,
    final V_HE=dhwParameters.V_HE,
    final beta=dhwParameters.beta,
    final kappa=dhwParameters.kappa,
    final m_flow_nominal_layer=mDHW_flow_nominal,
    final m_flow_nominal_HE=mSup_flow_nominal[1],
    final energyDynamics=energyDynamics,
    final T_start=TDHW_nominal,
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(storageDHW.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(storageDHW.m_flow_nominal_HE))
    "The DHW storage (TWWS) for domestic hot water demand"
    annotation (Placement(transformation(extent={{66,-70},{32,-32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        bufParameters.TAmb) "Constant ambient temperature of storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,10})));
  AixLib.Fluid.Storage.Storage storageBuf(
    redeclare package Medium = Medium,
    final n=bufParameters.nLayer,
    final d=bufParameters.d,
    final h=bufParameters.h,
    final lambda_ins=bufParameters.lambda_ins,
    final s_ins=bufParameters.sIns,
    final hConIn=bufParameters.hConIn,
    final hConOut=bufParameters.hConOut,
    final k_HE=bufParameters.k_HE,
    final A_HE=bufParameters.A_HE,
    final V_HE=bufParameters.V_HE,
    final beta=bufParameters.beta,
    final kappa=bufParameters.kappa,
    final m_flow_nominal_layer=m_flow_nominal[1],
    final m_flow_nominal_HE=mSup_flow_nominal[1],
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final p_start=p_start,
    final m_flow_small_layer=1E-4*abs(storageBuf.m_flow_nominal_layer),
    final m_flow_small_layer_HE=1E-4*abs(storageBuf.m_flow_nominal_HE))
    "The buffer storage (PS) for the building"
    annotation (Placement(transformation(extent={{66,40},{32,76}})));
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
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve parameters=threeWayValveParameters)
    annotation (Placement(transformation(extent={{-60,40},{-20,80}})));
  Modelica.Blocks.Sources.RealExpression T_stoDHWTop(final y(unit="K", displayUnit="degC")=storageDHW.layer[
        dhwParameters.nLayer].T) annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={37,87})));
  Modelica.Blocks.Sources.RealExpression T_stoBufTop(final y(unit="K", displayUnit="degC")=storageBuf.layer[
        bufParameters.nLayer].T) annotation (Placement(transformation(
        extent={{-5,-2},{5,2}},
        rotation=180,
        origin={23,92})));
  Modelica.Blocks.Sources.RealExpression T_stoBufBot(final y(unit="K", displayUnit="degC")=storageBuf.layer[1].T)
    annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={23,87})));
  Modelica.Blocks.Sources.RealExpression T_stoDHWBot(final y(unit="K", displayUnit="degC")=storageDHW.layer[1].T)
    annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={37,99})));

  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    bufParameters constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
        final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final T_m=TDem_nominal[1],
        final QHC1_flow_nominal=Q_flow_nominal[1],
        final mHC1_flow_nominal=mSup_flow_nominal[1],
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1)                    annotation (
      choicesAllMatching=true, Placement(transformation(extent={{84,56},{98,70}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition
    dhwParameters constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition(
        final rho=rho,
        final c_p=cp,
        final TAmb=TAmb,
        final QHC1_flow_nominal=QDHW_flow_nominal,
        final V=if designType == Types.DHWDesignType.FullStorage then VDHWDay * fFullSto else VDHWDay,
        final Q_flow_nominal=0,
        final VPerQ_flow=0,
        final T_m=TDHW_nominal,
        final mHC1_flow_nominal=mSup_flow_nominal[1],
        redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1)                                          annotation (
      choicesAllMatching=true, Placement(transformation(extent={{82,-58},{98,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(final T=
        dhwParameters.TAmb) "Constant ambient temperature of storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-90})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHW(use_inpCon=false, y=fixTemDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{34,-110},{54,-90}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    threeWayValveParameters constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={resBui.dp_nominal,  resDHW.dp_nominal},
    final m_flow_nominal=mSup_flow_nominal[1],
    final fraK=1,
    use_inputFilter=false) annotation (Placement(
        transformation(extent={{-60,2},{-40,22}})), choicesAllMatching=true);
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
  IBPSA.Fluid.Sources.Boundary_pT bouPumBuf(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1)
    "Pressure reference for transfer circuit as generation circuit reference is not connected (indirect loading)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,10})));
equation
  connect(fixTemBuf.port, storageBuf.heatPort) annotation (Line(points={{60,10},
          {80,10},{80,58},{62.6,58}}, color={191,0,0}));
  connect(storageBuf.port_b_consumer, portBui_out[1]) annotation (Line(points={{49,76},
          {50,76},{50,80},{100,80}},     color={0,127,255}));
  connect(storageBuf.port_a_consumer, portBui_in[1]) annotation (Line(points={{49,40},
          {100,40}},                 color={0,127,255}));
  connect(storageDHW.port_b_consumer, portDHW_out) annotation (Line(points={{49,-32},
          {48,-32},{48,-22},{100,-22}},      color={0,127,255}));
  connect(portDHW_in, storageDHW.port_a_consumer) annotation (Line(points={{100,-82},
          {48,-82},{48,-70},{49,-70}},      color={0,127,255}));
  connect(fixTemDHW.port, storageDHW.heatPort) annotation (Line(points={{40,-90},
          {70,-90},{70,-51},{62.6,-51}}, color={191,0,0}));
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
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{54,-100},{54,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(storageBuf.port_b_heatGenerator, threeWayValveWithFlowReturn.portBui_a)
    annotation (Line(points={{34.72,43.6},{34.72,42},{-12,42},{-12,68},{-20,68}},
        color={0,127,255}));
  connect(storageDHW.port_b_heatGenerator, threeWayValveWithFlowReturn.portDHW_a)
    annotation (Line(points={{34.72,-66.2},{-20,-66.2},{-20,44.8}}, color={0,127,
          255}));
  connect(threeWayValveWithFlowReturn.portGen_b, portGen_out[1]) annotation (
      Line(points={{-60,52.8},{-84,52.8},{-84,40},{-100,40}}, color={0,127,255}));
  connect(portGen_in[1], threeWayValveWithFlowReturn.portGen_a) annotation (
      Line(points={{-100,80},{-66,80},{-66,68.8},{-60,68.8}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
     Line(points={{-40,84},{-40,98},{4,98},{4,100},{0,100},{0,101}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(threeWayValveWithFlowReturn.portBui_b, resBui.port_a)
    annotation (Line(points={{-20,76},{-10,76},{-10,70},{0,70}},
                                               color={0,127,255}));
  connect(storageBuf.port_a_heatGenerator, resBui.port_b) annotation (Line(
        points={{34.72,73.84},{34.72,70},{20,70}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, resDHW.port_a) annotation (
      Line(points={{-20,52.8},{-14,52.8},{-14,-30},{0,-30}}, color={0,127,255}));
  connect(storageDHW.port_a_heatGenerator, resDHW.port_b) annotation (Line(
        points={{34.72,-34.28},{34,-34.28},{34,-30},{20,-30}},
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
  connect(bouPumBuf.ports[1], storageBuf.port_a_consumer) annotation (Line(
        points={{10,20},{10,32},{49,32},{49,40}}, color={0,127,255}));
end DistributionTwoStorageParallel;
