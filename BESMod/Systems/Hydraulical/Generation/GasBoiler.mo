within BESMod.Systems.Hydraulical.Generation;
model GasBoiler "Just a gas boiler"
  extends BaseClasses.PartialGeneration(dp_nominal={boi.dp_nominal},
      Q_flow_design = {if use_old_design then QOld_flow_design[1] else Q_flow_nominal[1]},
    dTTra_design={if use_old_design then dTTraOld_design[1] else dTTra_nominal[1]},
    final nParallelDem=1);

  parameter Boolean use_old_design=false
    "If true, design parameters of the building with no retrofit (old state) are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Real etaTem[:,2]=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.;
      373.15,0.99] "Temperature based efficiency"
        annotation(Dialog(group="Component data"));

  replaceable parameter BESMod.Systems.Hydraulical.Generation.RecordsCollection.AutoparameterBoiler
    parBoi constrainedby
    AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition(
      Q_nom=max(11000, Q_flow_design[1]/parBoi.eta[2,2]))
    "Parameters for Boiler"
    annotation(Placement(transformation(extent={{-58,44},{-42,60}})),
      choicesAllMatching=true, Dialog(group="Component data"));

  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    parTemSen
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{-98,-16},{-80,-2}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    parPum annotation (Dialog(group="Component data"),
      choicesAllMatching=true, Placement(transformation(extent={{64,-76},{78,-64}})));
  AixLib.Fluid.BoilerCHP.BoilerNoControl boi(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final m_flow_small=1E-4*abs(m_flow_design[1]),
    final show_T=show_T,
    final tau=parTemSen.tau,
    final initType=parTemSen.initType,
    final transferHeat=parTemSen.transferHeat,
    final TAmb=parTemSen.TAmb,
    final tauHeaTra=parTemSen.tauHeaTra,
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    paramBoiler=parBoi,
    etaTempBased=etaTem,
    T_out(unit="K", displayUnit="degC"),
    T_in(unit="K", displayUnit="degC"))
                         "Boiler with external control"
    annotation (Placement(transformation(extent={{-66,-6},{-34,26}})));


  Utilities.KPIs.EnergyKPICalculator KPIQBoi(use_inpCon=false, y=boi.QflowCalculation.y)
    "Boiler heat flow rate"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final addPowerToMedium=parPum.addPowerToMedium,
    final tau=parPum.tau,
    final use_inputFilter=parPum.use_inputFilter,
    final riseTime=parPum.riseTimeInpFilter,
    final y_start=1,
    final m_flow_nominal=m_flow_design[1],
    final dp_nominal=dpDem_nominal[1] + dp_nominal[1])
                     annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={30,-50})));

  IBPSA.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    p=p_start,
    T=T_start,
    nPorts=1)                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={66,-26})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{26,-108},{46,-88}})));
  Utilities.KPIs.DeviceKPICalculator KPIBoi(
    use_reaInp=true,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true) "Boiler KPIs"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

initial algorithm
  assert(parBoi.Q_nom >= Q_flow_nominal[1], "Nominal heat flow rate
  of boiler is smaller than nominal heat demand", AssertionLevel.warning);

equation

  connect(boi.port_b, portGen_out[1]) annotation (Line(points={{-34,10},{-20,10},{
          -20,80},{100,80}}, color={0,127,255}));
  connect(boi.T_in, sigBusGen.TBoiIn) annotation (Line(points={{-38.48,19.28},{2,19.28},
          {2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boi.T_out, sigBusGen.TBoiOut) annotation (Line(points={{-38.48,15.12},{2,
          15.12},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boi.u_rel, sigBusGen.uBoiSet) annotation (Line(points={{-61.2,21.2},{-68,
          21.2},{-68,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_in[1], pump.port_a) annotation (Line(points={{100,-2},{94,-2},{94,
          -6},{86,-6},{86,-50},{40,-50}},     color={0,127,255}));
  connect(boi.port_a, pump.port_b) annotation (Line(points={{-66,10},{-68,10},{-68,
          -50},{20,-50}},          color={0,127,255}));
  connect(bou1.ports[1], pump.port_a)
    annotation (Line(points={{66,-36},{66,-50},{40,-50}}, color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{46,-98},{60,-98},{60,-100},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(pump.y, sigBusGen.uPump) annotation (Line(points={{30,-38},{30,14},{2,14},
          {2,98}},               color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIQBoi.KPI, outBusGen.QBoi_flow) annotation (Line(points={{-17.8,-90},
          {-10,-90},{-10,-88},{0,-88},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIBoi.KPI, outBusGen.boi) annotation (Line(points={{-37.8,-70},{0,-70},
          {0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIBoi.uRea, sigBusGen.uBoiSet) annotation (Line(points={{-62.2,-70},{-74,
          -70},{-74,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end GasBoiler;
