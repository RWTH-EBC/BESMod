within BESMod.Systems.Hydraulical.Generation;
model GasBoiler "Just a gas boiler"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialAggregatedPressureLoss(
    resGenApp(final dp_nominal=dpBoi_nominal + resGen.dp_nominal),
    Q_flow_design = {if use_old_design then QOld_flow_design[1] else Q_flow_nominal[1]},
    dTTra_design={if use_old_design then dTTraOld_design[1] else dTTra_nominal[1]},
    final nParallelDem=1);
  parameter Modelica.Units.SI.Length lengthPip=4 "Length of all pipes"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoe=4*facPerBend
    "Factor to take into account resistance of bendsm, fittings etc."
    annotation (Dialog(tab="Pressure losses"));
  parameter Boolean use_old_design=false
    "If true, design parameters of the building with no retrofit (old state) are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Real etaTem[:,2]=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.;
      373.15,0.99] "Temperature based efficiency"
        annotation(Dialog(group="Component data"));
  parameter Modelica.Units.SI.PressureDifference dpBoi_nominal=boi.a*(m_flow_design[1]/boi.rho_default)^boi.n "Boiler pressure drop";

  /* 
  Boiler record needs nominal firing power which is estimated 
  with the nominal boiler efficiency without temperatur based 
  efficiency which is near 1 at high temperatures
  */
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
    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{-98,-16},{-80,-2}})));
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
    dp_nominal=0,
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

  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{26,-108},{46,-88}})));
  Utilities.KPIs.DeviceKPICalculator KPIBoi(
    use_reaInp=true,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true) "Boiler KPIs"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Components.ResistanceCoefficientHydraulicDiameterDPFixed
                                            resGen(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPip_design[1],
    final length=lengthPip,
    final ReC=ReC,
    final v_nominal=v_design[1],
    final roughness=roughness,
    final resCoe=resCoe)          "Pressure drop model depending on the configuration"
    annotation (Placement(transformation(extent={{20,-40},{0,-20}})));
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
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{46,-98},{60,-98},{60,-100},{72,-100}},
      color={0,0,0},
      thickness=1));
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
  connect(resGen.port_a, portGen_in[1]) annotation (Line(points={{20,-30},{52,
          -30},{52,-2},{100,-2}}, color={0,127,255}));
  connect(resGen.port_b, boi.port_a)
    annotation (Line(points={{0,-30},{-66,-30},{-66,10}}, color={0,127,255}));
end GasBoiler;
