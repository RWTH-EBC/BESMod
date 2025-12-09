within BESMod.Systems.Ventilation.Generation;
model ControlledDomesticVentilation
  extends BESMod.Systems.Ventilation.Generation.BaseClasses.PartialGeneration(
    dp_design={2 * parameters.dpHex_nominal + 2*
        threeWayValveParas.dpValve_nominal},
    dTTra_nominal={0},
    nParallelSup=1,
    nParallelDem=1,
      TSup_nominal=TDem_nominal);

  IBPSA.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final m1_flow_nominal=m_flow_design[1],
    final m2_flow_nominal=m_flow_design[1],
    final dp1_nominal=parameters.dpHex_nominal,
    final dp2_nominal=parameters.dpHex_nominal,
    final eps=parameters.epsHex)
             annotation (Placement(transformation(extent={{32,-44},{0,-16}})));
  IBPSA.Fluid.Sources.Boundary_pT bouSup(
    redeclare final package Medium = Medium,
    final use_p_in=true,
    final use_T_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=180,
        origin={78,-22})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TExhIn(
    final initType=tempSensorData.initType,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=1E-4*m_flow_design[1],
    final T_start=T_start,
    final tau=tempSensorData.tau,
    final m_flow_nominal=m_flow_design[1],
    final transferHeat=tempSensorData.transferHeat,
    final TAmb=tempSensorData.TAmb,
    final tauHeaTra=tempSensorData.tauHeaTra)
    "Temperature at exhaust inlet" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-42,-40})));
  IBPSA.Fluid.Sources.Boundary_pT bouExh(redeclare final package Medium =
        Medium, nPorts=1)
                annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={73,-41})));

  replaceable parameter
    BESMod.Systems.Ventilation.Generation.RecordsCollection.PartialHeatExchangerRecovery
    parameters annotation (choicesAllMatching=true, Placement(transformation(
          extent={{24,64},{38,78}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TSup(
    final initType=tempSensorData.initType,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=1E-4*m_flow_design[1],
    final T_start=T_start,
    final tau=tempSensorData.tau,
    final m_flow_nominal=m_flow_design[1],
    final transferHeat=tempSensorData.transferHeat,
    final TAmb=tempSensorData.TAmb,
    final tauHeaTra=tempSensorData.tauHeaTra)
    "Temperature at supply inlet" annotation (Placement(transformation(
        extent={{-9,8},{9,-8}},
        rotation=180,
        origin={-53,42})));

  replaceable IBPSA.Fluid.Actuators.Valves.ThreeWayLinear threeWayValve_b constrainedby
    IBPSA.Fluid.Actuators.BaseClasses.PartialThreeWayValve(
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final tau=threeWayValveParas.tau,
    final from_dp=threeWayValveParas.from_dp,
    final use_strokeTime=threeWayValveParas.use_strokeTime,
    final strokeTime=threeWayValveParas.strokeTime,
    final init=threeWayValveParas.init,
    final y_start=threeWayValveParas.y_start,
    final deltaM=threeWayValveParas.deltaM,
    final dpValve_nominal=threeWayValveParas.dpValve_nominal,
    final dpFixed_nominal=threeWayValveParas.dpFixed_nominal,
    final fraK=threeWayValveParas.fraK,
    redeclare final package Medium = Medium,
    final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_design[1]) annotation (choicesAllMatching=true,
      Placement(transformation(extent={{22,-64},{38,-80}})));
  replaceable IBPSA.Fluid.Actuators.Valves.ThreeWayLinear threeWayValve_a constrainedby
    IBPSA.Fluid.Actuators.BaseClasses.PartialThreeWayValve(
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final tau=threeWayValveParas.tau,
    final from_dp=threeWayValveParas.from_dp,
    final use_strokeTime=threeWayValveParas.use_strokeTime,
    final strokeTime=threeWayValveParas.strokeTime,
    final init=threeWayValveParas.init,
    final y_start=threeWayValveParas.y_start,
    final deltaM=threeWayValveParas.deltaM,
    final dpValve_nominal=threeWayValveParas.dpValve_nominal,
    final dpFixed_nominal=threeWayValveParas.dpFixed_nominal,
    final fraK=threeWayValveParas.fraK,
    redeclare final package Medium = Medium,
    final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_design[1]) annotation (choicesAllMatching=true,
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={-11,-69})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    threeWayValveParas constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    m_flow_nominal=m_flow_design[1],
    dp_nominal={0, parameters.dpHex_nominal})
    annotation (choicesAllMatching=true, Placement(transformation(extent={{44,64},
            {58,78}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    tempSensorData
    annotation (Placement(transformation(extent={{62,64},{78,78}})),
      choicesAllMatching=true);
  Utilities.Electrical.ZeroLoad        zeroLoad
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
equation
  connect(bouSup.p_in, weaBus.pAtm) annotation (Line(points={{87.6,-28.4},{112,-28.4},
          {112,92},{41.105,92},{41.105,100.11}},       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bouSup.T_in, weaBus.TDryBul) annotation (Line(points={{87.6,-25.2},{112,
          -25.2},{112,92},{41.105,92},{41.105,100.11}},     color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TExhIn.T,outBusGen.TExhIn)  annotation (Line(points={{-42,-51},{-42,-56},
          {102,-56},{102,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(TSup.T, sigBusGen.THROut) annotation (Line(points={{-53,50.8},{-53,66},
          {-42,66},{-42,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSup.port_a, hex.port_b1) annotation (Line(points={{-44,42},{-18,42},{
          -18,-21.6},{0,-21.6}}, color={0,127,255}));
  connect(bouExh.ports[1], threeWayValve_b.port_2) annotation (Line(points={{68,
          -41},{62,-41},{62,-72},{38,-72}}, color={0,127,255}));
  connect(TExhIn.port_b, threeWayValve_a.port_2) annotation (Line(points={{-32,
          -40},{-20,-40},{-20,-58},{-22,-58},{-22,-69},{-18,-69}}, color={0,127,
          255}));
  connect(threeWayValve_a.port_3, hex.port_a2) annotation (Line(points={{-11,-62},
          {-10,-62},{-10,-38.4},{0,-38.4}}, color={0,127,255}));
  connect(threeWayValve_a.y, sigBusGen.uByPass) annotation (Line(points={{-11,-77.4},
          {-11,-84},{-42,-84},{-42,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(threeWayValve_b.y, sigBusGen.uByPass) annotation (Line(points={{30,
          -81.6},{30,-86},{-42,-86},{-42,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(threeWayValve_b.port_3, hex.port_b2) annotation (Line(points={{30,-64},
          {30,-48},{36,-48},{36,-38.4},{32,-38.4}}, color={0,127,255}));
  connect(threeWayValve_a.port_1, threeWayValve_b.port_1) annotation (Line(
        points={{-4,-69},{14,-69},{14,-72},{22,-72}}, color={0,127,255}));
  connect(hex.port_a1, bouSup.ports[1]) annotation (Line(points={{32,-21.6},{51,
          -21.6},{51,-22},{70,-22}}, color={0,127,255}));

  connect(TSup.port_b, portVent_in[1])
    annotation (Line(points={{-62,42},{-100,42}}, color={0,127,255}));
  connect(TExhIn.port_a, portVent_out[1])
    annotation (Line(points={{-52,-40},{-100,-40}}, color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{20,-100},{42,-100},{42,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
end ControlledDomesticVentilation;
