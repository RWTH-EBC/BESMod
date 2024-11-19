within BESMod.Systems.Hydraulical.Generation;
model ElectricalHeater "Only heat using an electric heater"
  extends BaseClasses.PartialGeneration(
    final dTLoss_nominal=fill(0, nParallelDem),
    dp_nominal={hea.dp_nominal}, final nParallelDem=1);


  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-16})));
  Modelica.Blocks.Sources.Constant       dummyMassFlow(final k=1)
    annotation (Placement(transformation(extent={{84,-6},{64,14}})));
  Modelica.Blocks.Sources.Constant       dummyZero(k=0)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={18,4})));

  AixLib.Fluid.HeatExchangers.HeatingRod hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final dp_nominal=parEleHea.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=Q_flow_nominal[1],
    final V=parEleHea.V_hr,
    final eta=parEleHea.eta)
    annotation (Placement(transformation(extent={{-16,-16},{16,16}},
        rotation=90,
        origin={-32,10})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.Generic
    parEleHea "Electric heater parameters" annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-62,-42},{-50,-30}})));

  Modelica.Blocks.Logical.GreaterThreshold isOnHR(threshold=Modelica.Constants.eps)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={46,14})));

  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_nominal=m_flow_nominal[1],
    final dp_nominal=dpDem_nominal[1] + dp_nominal[1],
    final addPowerToMedium=parPum.addPowerToMedium,
    final tau=parPum.tau,
    final use_inputFilter=parPum.use_inputFilter,
    final riseTime=parPum.riseTimeInpFilter,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={48,-48})));
  IBPSA.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    p=p_start,
    T=T_start,
    nPorts=1)                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={62,-74})));

  Utilities.KPIs.EnergyKPICalculator KPIQEleHea(use_inpCon=false, y=hea.vol.heatPort.Q_flow)
    "Electric heater heat flow rate"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    parPum annotation (choicesAllMatching=true, Placement(transformation(extent={{14,-64},
            {28,-52}})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{32,-108},{52,-88}})));
  Utilities.KPIs.DeviceKPICalculator KPIEleHea(
    use_reaInp=true,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true) "Electric heater KPIs"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Modelica.Blocks.Sources.RealExpression reaExpTOut(y=hea.vol.T)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,70})));
equation
  connect(dummyZero.y,switch1. u3)
    annotation (Line(points={{29,4},{38,4},{38,-4}},    color={0,0,127}));
  connect(dummyMassFlow.y,switch1. u1)
    annotation (Line(points={{63,4},{54,4},{54,-4}}, color={0,0,127}));

  connect(hea.Pel, outBusGen.PelHR) annotation (Line(points={{-41.6,27.6},{-41.6,
          49.6},{-72,49.6},{-72,-100},{0,-100}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_in[1], pump.port_a) annotation (Line(points={{100,-2},{80,-2},
          {80,-48},{58,-48}}, color={0,127,255}));
  connect(pump.port_a, bou1.ports[1])
    annotation (Line(points={{58,-48},{62,-48},{62,-64}}, color={0,127,255}));
  connect(switch1.y, pump.y) annotation (Line(points={{46,-27},{46,-31.5},{48,-31.5},
          {48,-36}}, color={0,0,127}));
  connect(isOnHR.y, switch1.u2)
    annotation (Line(points={{46,7.4},{46,-4}}, color={255,0,255}));
  connect(hea.port_a, pump.port_b) annotation (Line(points={{-32,-6},{-34,-6},{
          -34,-48},{38,-48}}, color={0,127,255}));
  connect(isOnHR.u, sigBusGen.uEleHea) annotation (Line(points={{46,21.2},{48,21.2},
          {48,46},{2,46},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{52.2,-97.8},{52.2,-96},{58,-96},{58,-86},{72,-86},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(realToElecCon.PEleLoa, hea.Pel) annotation (Line(points={{30,-94},{
          -80,-94},{-80,28},{-60,28},{-60,27.6},{-41.6,27.6}},
                                             color={0,0,127}));
  connect(KPIQEleHea.KPI, outBusGen.QEleHea_flow) annotation (Line(points={{-17.8,-70},
          {0,-70},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIEleHea.KPI, outBusGen.eleHea) annotation (Line(points={{-37.8,-90},{-14,
          -90},{-14,-86},{0,-86},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIEleHea.uRea, sigBusGen.uEleHea) annotation (Line(points={{-62.2,-90},{-76,
          -90},{-76,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hea.u, sigBusGen.uEleHea) annotation (Line(points={{-41.6,-9.2},{
          -41.6,-14},{-54,-14},{-54,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpTOut.y, sigBusGen.TGenOutMea) annotation (Line(points={{-19,70},{
          2,70},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hea.port_b, portGen_out[1]) annotation (Line(points={{-32,26},{-32,40},
          {20,40},{20,80},{100,80}}, color={0,127,255}));
end ElectricalHeater;
