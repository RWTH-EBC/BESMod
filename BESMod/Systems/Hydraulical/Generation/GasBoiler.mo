within BESMod.Systems.Hydraulical.Generation;
model GasBoiler "Just a gas boiler"
  extends BaseClasses.PartialGeneration(
    dTTra_nominal=fill(20, nParallelDem),
    dp_nominal={boilerNoControl.dp_nominal},
    final nParallelDem=1);
  replaceable parameter AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition
    paramBoiler "Parameters for Boiler" annotation(Dialog(group="Component data"),
    choicesAllMatching=true);
  parameter Real etaTempBased[:,2]=[293.15,1.09; 303.15,1.08; 313.15,1.05;
      323.15,1.; 373.15,0.99] "Table matrix for temperature based efficiency"
        annotation(Dialog(group="Component data"));
  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    temperatureSensorData
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{-98,-16},{-78,4}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (Dialog(group="Component data"),
      choicesAllMatching=true, Placement(transformation(extent={{54,-80},
            {68,-68}})));
  AixLib.Fluid.BoilerCHP.BoilerNoControl boilerNoControl(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final tau=temperatureSensorData.tau,
    final initType=temperatureSensorData.initType,
    final transferHeat=temperatureSensorData.transferHeat,
    final TAmb=temperatureSensorData.TAmb,
    final tauHeaTra=temperatureSensorData.tauHeaTra,
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    paramBoiler=paramBoiler,
    etaTempBased=etaTempBased)
    annotation (Placement(transformation(extent={{-66,-6},{-34,26}})));


  Utilities.KPIs.EnergyKPICalculator KPIQHR(use_inpCon=false, y=boilerNoControl.QflowCalculation.y)
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  IBPSA.Fluid.Movers.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData
      per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal[1],
      final dp_nominal=dpDem_nominal[1] + dp_nominal[1],
      final rho=rho,
      final V_flowCurve=pumpData.V_flowCurve,
      final dpCurve=pumpData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=pumpData.addPowerToMedium,
    final tau=pumpData.tau,
    final use_inputFilter=pumpData.use_inputFilter,
    final riseTime=pumpData.riseTimeInpFilter,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={46,-50})));

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
  Utilities.KPIs.DeviceKPICalculator KPIHeaRod1(
    use_reaInp=true,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

initial equation
  assert(paramBoiler.Q_nom >= Q_flow_nominal[1], "Nominal heat flow rate
  of boiler is smaller than nominal heat demand", AssertionLevel.warning);

equation

  connect(boilerNoControl.port_b, portGen_out[1]) annotation (Line(points={{-34,
          10},{-20,10},{-20,80},{100,80}}, color={0,127,255}));
  connect(boilerNoControl.T_in, sigBusGen.TBoiIn) annotation (Line(points={{-38.48,
          19.28},{2,19.28},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boilerNoControl.T_out, sigBusGen.TBoiOut) annotation (Line(points={{-38.48,
          15.12},{2,15.12},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boilerNoControl.u_rel, sigBusGen.uBoiSet) annotation (Line(points={{-61.2,
          21.2},{-68,21.2},{-68,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_in[1], pump.port_a) annotation (Line(points={{100,-2},{94,-2},
          {94,-6},{86,-6},{86,-50},{56,-50}}, color={0,127,255}));
  connect(boilerNoControl.port_a, pump.port_b) annotation (Line(points={{-66,10},
          {-68,10},{-68,-50},{36,-50},{36,-50}}, color={0,127,255}));
  connect(bou1.ports[1], pump.port_a)
    annotation (Line(points={{66,-36},{66,-50},{56,-50}}, color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{46,-98},{60,-98},{60,-100},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(pump.y, sigBusGen.uPump) annotation (Line(points={{46,-38},{48,-38},{
          48,14},{2,14},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIQHR.KPI, outBusGen.QBoi_flow) annotation (Line(points={{-17.8,-90},
          {-10,-90},{-10,-88},{0,-88},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod1.KPI, outBusGen.boi) annotation (Line(points={{-37.8,-70},{
          0,-70},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod1.uRea, sigBusGen.uBoiSet) annotation (Line(points={{-62.2,
          -70},{-74,-70},{-74,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<h4>Bottom-up parameters</h4>
<p><br>The value for dTTra_nominal is based on EN 303-1:2017, which requires a temperature spread between 10 and 20 K. </p>
<p>20 K is used for most applications, as for example stated in the datasheet of the Vitocrossal Typ CU3A.</p>
</html>"));
end GasBoiler;
