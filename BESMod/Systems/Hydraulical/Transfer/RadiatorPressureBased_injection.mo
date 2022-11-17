within BESMod.Systems.Hydraulical.Transfer;
model RadiatorPressureBased_injection
  "Pressure Based transfer system with mixing control"
  extends BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialTransfer(
     final dp_nominal=rad.dp_nominal .+ val.dpValve_nominal .+ res.dp_nominal .+
        val.dpFixed_nominal, final nParallelSup=1);

  replaceable parameter
    HugosProject.Systems.Hydraulical.Transfer.RecordsCollection.TransferDataBaseDefinition
    transferDataBaseDefinition(dpHeaSysValve_nominal=(dpRad_nominal .+
        dpHeaSysPreValve_nominal) ./ (1 .- valveAutho)) constrainedby
    HugosProject.Systems.Hydraulical.Transfer.RecordsCollection.TransferDataBaseDefinition(
    final Q_flow_nominal=Q_flow_nominal .* f_design,
    final nZones=nParallelDem,
    final AFloor=ABui,
    final heiBui=hBui) annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-62,-98},{-42,-78}})));

  replaceable parameter
    BESMod.HugosProject.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-98,78},{-72,100}})));

  replaceable parameter
    BESMod.HugosProject.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
    radParameters annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-100,-98},{-80,-78}})));
  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final nEle=radParameters.nEle,
    each final fraRad=radParameters.fraRad,
    final Q_flow_nominal=Q_flow_nominal.*f_design,
    final T_a_nominal=TSup_nominal,
    final T_b_nominal=TSup_nominal .- dTTra_nominal,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=radParameters.n,
    each final deltaM=0.3,
    final dp_nominal=transferDataBaseDefinition.dpRad_nominal,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator"
    annotation (Placement(transformation(
        extent={{11,11},{-11,-11}},
        rotation=90,
        origin={43,-19})));

  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=transferDataBaseDefinition.dpHeaDistr_nominal,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-12.5,-13.5},{12.5,13.5}},
        rotation=0,
        origin={-34.5,37.5})));
  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val[nParallelDem](
    redeclare package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=transferDataBaseDefinition.dpHeaSysValve_nominal,
    each final use_inputFilter=false,
    final dpFixed_nominal=transferDataBaseDefinition.dpHeaSysPreValve_nominal,
    each final l=transferDataBaseDefinition.leakageOpening)
                                            annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=180,
        origin={-54,-41})));

  IBPSA.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=sum(rad.m_flow_nominal),
    final m_flow_small=1E-4*abs(sum(rad.m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    final V(displayUnit="l") = transferDataBaseDefinition.vol,
    final use_C_flow=false,
    nPorts=1 + nParallelDem) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-58,18})));
  IBPSA.Fluid.Movers.SpeedControlled_y     pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    redeclare BESMod.HugosProject.Systems.RecordsCollection.Movers.AutomaticConfigurationData
                                                                                 per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=sum(m_flow_nominal),
      final dp_nominal=1/sum({1/dp_nominal[i] for i in 1:nParallelDem}),
      final rho=rho,
      final V_flowCurve=pumpData.V_flowCurve,
      final dpCurve=pumpData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=pumpData.addPowerToMedium,
    final tau=pumpData.tau,
    final use_inputFilter=pumpData.use_inputFilter,
    final riseTime=pumpData.riseTimeInpFilter,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1)                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,38})));

  Modelica.Blocks.Sources.Constant m_flow1(k=1)   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-48,68})));

  Utilities.Electrical.RealToElecCon              realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{28,-86},{48,-66}})));
  replaceable parameter
    BESMod.HugosProject.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumRadData
    annotation (choicesAllMatching=true, Placement(transformation(extent={{58,78},{78,98}})));
  IBPSA.Fluid.Movers.SpeedControlled_y pum[nParallelDem](
    redeclare final package Medium = Medium,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final allowFlowReversal=allowFlowReversal,
    each final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      each final speed_rpm_nominal=pumRadData.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal,
      final rho=rho,
      each final V_flowCurve=pumRadData.V_flowCurve,
      each final dpCurve=pumRadData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    each final addPowerToMedium=pumRadData.addPowerToMedium,
    each final tau=pumRadData.tau,
    each final use_inputFilter=pumRadData.use_inputFilter,
    each final riseTime=pumRadData.riseTimeInpFilter,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={42,22})));
  IBPSA.Fluid.FixedResistances.LosslessPipe pip[nParallelDem](
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-14,-18},{6,2}},rotation=90,
        origin={0,4})));
  Modelica.Blocks.Sources.Constant m_flow_open[nParallelDem](k=1) annotation (
      Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=180,
        origin={141,29})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold[nParallelDem](
      threshold=transferDataBaseDefinition.leakageOpening)
    annotation (Placement(transformation(extent={{-140,-4},{-126,10}},rotation=180,
        origin={8,62})));
  Modelica.Blocks.Sources.Constant m_flow_closed[nParallelDem](k=pum.m_flow_small
         ./ pum.m_flow_nominal)
                             annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=180,
        origin={141,89})));
  Modelica.Blocks.Logical.Switch switch1[nParallelDem] annotation (
      Placement(transformation(
        extent={{-24,-14},{-4,6}},
        rotation=180,
        origin={54,44})));
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{50.92,-21.2},{
          50.92,-24},{86,-24},{86,-40},{100,-40}},
                                          color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{50.92,-16.8},{
          86,-16.8},{86,40},{100,40}},             color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(res[i].port_a, vol.ports[i + 1]) annotation (Line(points={{-47,37.5},
            {-56,37.5},{-56,28},{-58,28}}, color={0,127,255}));
    connect(val[i].port_b, portTra_out[1]) annotation (Line(points={{-64,-41},{-80,
            -41},{-80,-40},{-100,-40},{-100,-42}},
                                          color={0,127,255}));
  end for;

  connect(portTra_in[1],pump.port_a)
    annotation (Line(points={{-100,38},{-84,38}}, color={0,127,255}));
  connect(pump.port_b, vol.ports[1]) annotation (Line(points={{-64,38},{-62,38},
          {-62,28},{-58,28}}, color={0,127,255}));

  connect(m_flow1.y,pump. y)
    annotation (Line(points={{-59,68},{-74,68},{-74,50}}, color={0,0,127}));
  connect(val.y, traControlBus.opening) annotation (Line(points={{-54,-54.2},{-28,
          -54.2},{-28,20},{-12,20},{-12,86},{0,86},{0,100}},
                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realToElecCon.PEleLoa, pump.P) annotation (Line(points={{26,-72},{6,
          -72},{6,-14},{-14,-14},{-14,54},{-58,54},{-58,47},{-63,47}},
                                     color={0,0,127}));
  connect(pum.port_b, rad.port_a) annotation (Line(points={{42,12},{42,3},{43,3},
          {43,-8}}, color={0,127,255}));
  connect(val.port_a, rad.port_b)
    annotation (Line(points={{-44,-41},{43,-41},{43,-30}}, color={0,127,255}));
  connect(res.port_b, pum.port_a)
    annotation (Line(points={{-22,37.5},{42,37.5},{42,32}}, color={0,127,255}));
  connect(rad.port_b, pip.port_a) annotation (Line(points={{43,-30},{42,
          -30},{42,-40},{8,-40},{8,-10}},
                                   color={0,127,255}));
  connect(pip.port_b, pum.port_a) annotation (Line(points={{8,10},{8,32},
          {42,32}}, color={0,127,255}));
  connect(greaterThreshold.u, traControlBus.opening) annotation (Line(points={{149.4,
          59},{0,59},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(switch1.u2, greaterThreshold.y) annotation (Line(points={{80,
          48},{86,48},{86,59},{133.3,59}}, color={255,0,255}));
  connect(switch1.y, pum.y) annotation (Line(points={{57,48},{28,48},{
          28,28},{24,28},{24,22},{30,22}}, color={0,0,127}));
  connect(m_flow_closed.y, switch1.u3) annotation (Line(points={{131.1,
          89},{84,89},{84,62},{80,62},{80,56}}, color={0,0,127}));
  connect(m_flow_open.y, switch1.u1) annotation (Line(points={{131.1,29},
          {114,29},{114,26},{80,26},{80,40}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{48.2,-75.8},{72,-75.8},{72,-98}},
      color={0,0,0},
      thickness=1));
end RadiatorPressureBased_injection;
