within BESMod.Systems.Hydraulical.Transfer;
model UFHPressureBased
  // Abui =1 and hBui =1 to avoid warnings, will be overwritten anyway
  extends BaseClasses.PartialTransfer(
  ABui=1,
  hBui=1,
  final nParallelSup=1,
  final dp_nominal=transferDataBaseDefinition_forUFH.dp_nominal);
  parameter Boolean use_preRelVal=false "=false to disable pressure relief valve"
    annotation(Dialog(group="Component choices"));
  parameter Real perPreRelValOpens=0.99
    "Percentage of nominal pressure difference at which the pressure relief valve starts to open"
      annotation(Dialog(group="Component choices", enable=use_preRelVal));
  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=transferDataBaseDefinition_forUFH.dpHeaDistr_nominal,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,56})));

  BESMod.Systems.Hydraulical.Components.UFH.PanelHeating ufh[nParallelDem](
    redeclare package Medium = Medium,
    final floorHeatingType=floorHeatingType,
    each final dis=5,
    final A=UFHParameters.area,
    final T0=TDem_nominal,
    each calcMethod=1) "Underfloor heating" annotation (Placement(
        transformation(
        extent={{-29.5,-10.5},{29.5,10.5}},
        rotation=270,
        origin={61.5,9.5})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemp[nParallelDem](
      each final T=UFHParameters.T_floor) "Fixed floor temperature" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen[nParallelDem]
    "Heat flow sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={34,-30})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo[nParallelDem](
      each final Q_flow=0) "Fixed heat flow rate of 0 W" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-92,-20})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap[nParallelDem](
      each final C=100) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,4})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.UFHData UFHParameters
    constrainedby RecordsCollection.UFHData(nZones=nParallelDem, area=AZone)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{78,78},
            {98,98}})));

  Utilities.KPIs.EnergyKPICalculator integralKPICalculator[nParallelDem]
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,78},
            {-78,98}})));
  IBPSA.Fluid.Movers.SpeedControlled_y pump(redeclare package Medium = Medium,
    energyDynamics=energyDynamics,
    p_start=p_start,
    T_start=T_start,
    allowFlowReversal=allowFlowReversal,
    m_flow_small=1E-4*abs(m_flow_nominal[1]),
    show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=sum(m_flow_nominal),
      final dp_nominal=transferDataBaseDefinition_forUFH.dpPumpHeaCir_nominal +
          dpSup_nominal[1],
      final rho=rho,
      final V_flowCurve=pumpData.V_flowCurve,
      final dpCurve=pumpData.dpCurve),
    addPowerToMedium=pumpData.addPowerToMedium,
    tau=pumpData.tau,
    use_inputFilter=pumpData.use_inputFilter,
    riseTime=pumpData.riseTimeInpFilter,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=1)
    annotation (Placement(transformation(extent={{-80,28},{-60,48}})));
  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val[nParallelDem](redeclare package
      Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    dpValve_nominal=transferDataBaseDefinition_forUFH.dpHeaSysValve_nominal,
    use_inputFilter=false,
    dpFixed_nominal=transferDataBaseDefinition_forUFH.dpHeaSysPreValve_nominal,
    l=transferDataBaseDefinition_forUFH.leakageOpening)
    annotation (Placement(transformation(extent={{20,46},{40,66}})));

  Distribution.Components.Valves.PressureReliefValve pressureReliefValve(
      redeclare package Medium = Medium,
    m_flow_nominal=mSup_flow_nominal[1],
    dpFullOpen_nominal=dp_nominal[1],
    dpThreshold_nominal=perPreRelValOpens*dp_nominal[1],
    facDpValve_nominal=transferDataBaseDefinition_forUFH.valveAutho[1],
    l=transferDataBaseDefinition_forUFH.leakageOpening) if use_preRelVal
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,
        origin={-34,-2})));
  IBPSA.Fluid.MixingVolumes.MixingVolume vol(redeclare package Medium = Medium,
    energyDynamics=energyDynamics,
    massDynamics=energyDynamics,
    p_start=p_start,
    T_start=T_start,
    m_flow_nominal=sum(res.m_flow_nominal),
    allowFlowReversal=allowFlowReversal,
    V=transferDataBaseDefinition_forUFH.vol,
  nPorts=1 + nParallelDem)
    annotation (Placement(transformation(extent={{-40,72},{-20,92}})));
  Modelica.Blocks.Sources.Constant m_flow1(k=1)   annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={-57,63})));
  Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{48,-84},{60,-72}})));
  replaceable parameter RecordsCollection.TransferDataBaseDefinition_forUFH
    transferDataBaseDefinition_forUFH(
    nZones=nParallelDem,
    Q_flow_nominal=Q_flow_nominal .* f_design,
    AFloor=ABui,
    heiBui=hBui,
    mUFH_flow_nominal=m_flow_nominal,
    dpUFH_nominal=ufh.pressureDrop.m .* ufh.pressureDrop.tubeLength .* (
        m_flow_nominal .^ ufh.pressureDrop.n))
                                  annotation (Placement(transformation(extent={{
            -94,-98},{-74,-78}})), choicesAllMatching=true);
protected
  parameter
    BESMod.Systems.Hydraulical.Components.UFH.ActiveWallBaseDataDefinition
    floorHeatingType[nParallelDem]={
      BESMod.Systems.Hydraulical.Components.UFH.ActiveWallBaseDataDefinition(
      Temp_nom=Modelica.Units.Conversions.from_degC({TTra_nominal[i],
        TTra_nominal[i] - dTTra_nominal[i],TDem_nominal[i]}),
      q_dot_nom=Q_flow_nominal[i]/UFHParameters.area[i],
      k_isolation=UFHParameters.k_top[i] + UFHParameters.k_down[i],
      k_top=UFHParameters.k_top[i],
      k_down=UFHParameters.k_down[i],
      VolumeWaterPerMeter=0,
      eps=0.9,
      C_ActivatedElement=UFHParameters.C_ActivatedElement[i],
      c_top_ratio=UFHParameters.c_top_ratio[i],
      PressureDropExponent=1.7,
      PressureDropCoefficient=213,
      diameter=UFHParameters.diameter) for i in 1:nParallelDem};

equation

  for i in 1:nParallelDem loop
    connect(ufh[i].port_b, portTra_out[1]) annotation (Line(points={{59.75,-20},
            {62,-20},{62,-50},{-72,-50},{-72,-42},{-100,-42}},
                                         color={0,127,255}));
    connect(res[i].port_a, vol.ports[i+1])
    annotation (Line(points={{-18,56},{-30,56},{-30,72}}, color={0,127,255}));
  if UFHParameters.is_groundFloor[i] then
      connect(fixHeaFlo[i].port, heaCap[i].port) annotation (Line(points={{-82,
              -20},{-64,-20},{-64,-6}}, color={191,0,0}));
      connect(fixTemp[i].port, heaFloSen[i].port_a) annotation (Line(
          points={{-80,10},{-84,10},{-84,-20},{-78,-20},{-78,-38},{12,-38},{12,-30},
              {24,-30}},
          color={191,0,0},
          pattern=LinePattern.Dash));
  else
      connect(fixHeaFlo[i].port, heaFloSen[i].port_a) annotation (Line(
          points={{-82,-20},{-72,-20},{-72,-30},{24,-30}},
          color={191,0,0},
          pattern=LinePattern.Dash));
      connect(fixTemp[i].port, heaCap[i].port) annotation (Line(
          points={{-80,10},{-80,12},{-76,12},{-76,-6},{-64,-6}},
          color={191,0,0},
          pattern=LinePattern.Dash));
  end if;
  end for;

  connect(ufh.thermConv, heatPortCon) annotation (Line(points={{73.75,5.37},{73.75,
          4},{100,4},{100,26},{86,26},{86,40},{100,40}},
                                             color={191,0,0}));
  connect(ufh.starRad, heatPortRad) annotation (Line(points={{73.05,13.04},{73.05,
          12},{102,12},{102,-26},{86,-26},{86,-40},{100,-40}},     color={0,0,0}));

  connect(heaFloSen.port_b, ufh.ThermDown) annotation (Line(points={{44,-30},{48,
          -30},{48,-16},{42,-16},{42,7.14},{49.95,7.14}},
                                           color={191,0,0}));

  connect(heaFloSen.Q_flow, integralKPICalculator.u) annotation (Line(points={{34,-41},
          {34,-54},{-48,-54},{-48,-70},{-41.8,-70}},           color={0,0,127}));
  connect(integralKPICalculator.KPI, outBusTra.QUFH_flow) annotation (Line(
        points={{-17.8,-70},{0,-70},{0,-104}},   color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(val.y, traControlBus.opening) annotation (Line(points={{30,68},{30,86},
          {0,86},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(val.port_b, ufh.port_a) annotation (Line(points={{40,56},{59.75,56},{59.75,
          39}}, color={0,127,255}));
  connect(res.port_b, val.port_a)
    annotation (Line(points={{2,56},{20,56}},        color={0,127,255}));
  connect(pump.port_b, pressureReliefValve.port_a)
    annotation (Line(points={{-60,38},{-34,38},{-34,8}}, color={0,127,255}));
  connect(pressureReliefValve.port_b, portTra_out[1]) annotation (Line(points={{
          -34,-12},{-34,-42},{-100,-42}}, color={0,127,255}));
  connect(vol.ports[1], pump.port_b)
    annotation (Line(points={{-30,72},{-30,38},{-60,38}}, color={0,127,255}));
  connect(m_flow1.y, pump.y) annotation (Line(points={{-64.7,63},{-64.7,58},{
          -70,58},{-70,50}}, color={0,0,127}));
  connect(portTra_in[1], pump.port_a)
    annotation (Line(points={{-100,38},{-80,38}}, color={0,127,255}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{60.12,-77.88},{60.12,-78},{72,-78},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(realToElecCon.PEleLoa, pump.P) annotation (Line(points={{46.8,-75.6},
          {46.8,-76},{6,-76},{6,14},{-56,14},{-56,47},{-59,47}}, color={0,0,127}));
end UFHPressureBased;
