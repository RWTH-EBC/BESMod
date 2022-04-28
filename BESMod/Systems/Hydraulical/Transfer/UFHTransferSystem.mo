within BESMod.Systems.Hydraulical.Transfer;
model UFHTransferSystem
  extends BaseClasses.PartialTransfer(final nParallelSup=1, final dp_nominal=fill(0, nParallelDem));

  IBPSA.Fluid.FixedResistances.PressureDrop res1[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=1,
    final m_flow_nominal=m_flow_nominal)     "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-10.5,-12},{10.5,12}},
        rotation=0,
        origin={-64.5,38})));

  Modelica.Blocks.Math.Gain gain[nParallelDem](k=m_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-28,72})));
  BESMod.Components.UFH.PanelHeating panelHeating[
    nParallelDem](
    redeclare package Medium = Medium,
    final floorHeatingType=floorHeatingType,
    each final dis=5,
    final A=UFHParameters.area,
    final T0=TDem_nominal,
    each calcMethod=1) annotation (Placement(transformation(
        extent={{-23,-10},{23,10}},
        rotation=270,
        origin={5,-4})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
                                                      fixedTemperature
                                                                   [nParallelDem](final T=
        UFHParameters.T_floor)
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
                                                                   [nParallelDem]
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-46,-6})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow[nParallelDem](final
      Q_flow=0)
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-92,-20})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
                                                      heatCapacitor[nParallelDem](C=100)
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-114,2})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.UFHData UFHParameters
    constrainedby RecordsCollection.UFHData(nZones=nParallelDem, area=AZone)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{22,12},{42,32}})));

  Utilities.KPIs.InputKPICalculator inputKPICalculatorOpening[nParallelDem](
    unit=fill("", nParallelDem),
    integralUnit=fill("s", nParallelDem),
    calc_singleOnTime=false,
    calc_integral=false,
    calc_totalOnTime=false,
    calc_numSwi=false,
    calc_movAve=false)
    annotation (Placement(transformation(extent={{-46,-94},{-26,-58}})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorLossUFH[nParallelDem](
    unit=fill("W", nParallelDem),
    integralUnit=fill("J", nParallelDem),
    calc_singleOnTime=false,
    calc_integral=false,
    calc_totalOnTime=false,
    calc_numSwi=false,
    calc_movAve=false)
    annotation (Placement(transformation(extent={{-46,-120},{-26,-84}})));
  IBPSA.Fluid.Sources.Boundary_pT bouPumpHP[nParallelDem](
    redeclare package Medium = Medium,
    each final p=p_start,
    each final T=T_start,
    each final nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,58})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pumpFix_m_flow[nParallelDem](
    redeclare package Medium = Medium,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=1E-4*abs(m_flow_nominal),
    each final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData
      per(
      each final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal,
      each final rho=rho,
      each final V_flowCurve=pumpData.V_flowCurve,
      each final dpCurve=pumpData.dpCurve),
    each final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    each final addPowerToMedium=pumpData.addPowerToMedium,
    each final nominalValuesDefineDefaultPressureCurve=true,
    each final tau=pumpData.tau,
    each final use_inputFilter=false,
    final m_flow_start=m_flow_nominal)             annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-23,37})));
  replaceable
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,78},
            {-78,98}})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{32,-108},{52,-88}})));
protected
  parameter BESMod.Components.UFH.ActiveWallBaseDataDefinition floorHeatingType[nParallelDem]={BESMod.Components.UFH.ActiveWallBaseDataDefinition(
        Temp_nom=Modelica.Units.Conversions.from_degC(  {TSup_nominal[i],
          TSup_nominal[i]-dTTra_nominal[i],TDem_nominal[i]}),
        q_dot_nom=Q_flow_nominal[i] / UFHParameters.area[i],
        k_isolation=UFHParameters.k_top[i] + UFHParameters.k_down[i],
        k_top=UFHParameters.k_top[i],
        k_down=UFHParameters.k_down[i],
        VolumeWaterPerMeter=0,
        eps=0.9,
        C_ActivatedElement=UFHParameters.C_ActivatedElement[i],
        c_top_ratio=UFHParameters.c_top_ratio[i],
        PressureDropExponent=0,
        PressureDropCoefficient=0,
        diameter=UFHParameters.diameter) for i in 1:nParallelDem};

equation

  for i in 1:nParallelDem loop
    connect(res1[i].port_a, portTra_in[1])
    annotation (Line(points={{-75,38},{-100,38}}, color={0,127,255}));
    connect(panelHeating[i].port_b, portTra_out[1]) annotation (Line(points={{3.33333,
            -27},{3.33333,-42},{-100,-42}},
                                          color={0,127,255}));
  if UFHParameters.is_groundFloor[i] then
   connect(fixedHeatFlow[i].port, heatCapacitor[i].port) annotation (Line(points=
         {{-82,-20},{-76,-20},{-76,-8},{-114,-8}}, color={191,0,0}));
   connect(fixedTemperature[i].port, heatFlowSensor[i].port_a) annotation (Line(
      points={{-80,10},{-64,10},{-64,-6},{-56,-6}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  else
   connect(fixedHeatFlow[i].port, heatFlowSensor[i].port_a) annotation (Line(
      points={{-82,-20},{-66,-20},{-66,-6},{-56,-6}},
      color={191,0,0},
      pattern=LinePattern.Dash));
   connect(fixedTemperature[i].port, heatCapacitor[i].port) annotation (Line(
      points={{-80,10},{-80,-8},{-114,-8}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  end if;
  end for;

  connect(panelHeating.thermConv, heatPortCon) annotation (Line(points={{16.6667,
          -7.22},{52,-7.22},{52,42},{100,42},{100,40}}, color={191,0,0}));
  connect(panelHeating.starRad, heatPortRad) annotation (Line(points={{16,-1.24},
          {40,-1.24},{40,-40},{100,-40}}, color={0,0,0}));

  connect(heatFlowSensor.port_b, panelHeating.ThermDown) annotation (Line(
        points={{-36,-6},{-22,-6},{-22,-5.84},{-6,-5.84}}, color={191,0,0}));

  connect(gain.u, traControlBus.opening) annotation (Line(points={{-28,84},{-28,
          100},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(gain.y, inputKPICalculatorOpening.u) annotation (Line(points={{-28,61},
          {-28,54},{-46,54},{-46,8},{-60,8},{-60,-76},{-48.2,-76}}, color={0,0,
          127}));
  connect(inputKPICalculatorOpening.KPIBus, outBusTra.opening) annotation (Line(
      points={{-25.8,-76},{0,-76},{0,-104}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heatFlowSensor.Q_flow, inputKPICalculatorLossUFH.u) annotation (Line(
        points={{-46,-17},{-46,-22},{-62,-22},{-62,-102},{-48.2,-102}}, color={
          0,0,127}));
  connect(inputKPICalculatorLossUFH.KPIBus, outBusTra.QLossUFH) annotation (
      Line(
      points={{-25.8,-102},{-14,-102},{-14,-100},{0,-100},{0,-104}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bouPumpHP.ports[1],pumpFix_m_flow. port_a) annotation (Line(points={{-58,58},
          {-48,58},{-48,37},{-34,37}},     color={0,127,255}));
  connect(res1.port_b, pumpFix_m_flow.port_a) annotation (Line(points={{-54,38},
          {-44,38},{-44,37},{-34,37}}, color={0,127,255}));
  connect(pumpFix_m_flow.port_b, panelHeating.port_a) annotation (Line(points={{
          -12,37},{-6,37},{-6,38},{3.33333,38},{3.33333,19}}, color={0,127,255}));
  connect(gain.y, pumpFix_m_flow.m_flow_in) annotation (Line(points={{-28,61},{-28,
          56},{-23,56},{-23,50.2}}, color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{52,-98},{72,-98}},
      color={0,0,0},
      thickness=1));
end UFHTransferSystem;
