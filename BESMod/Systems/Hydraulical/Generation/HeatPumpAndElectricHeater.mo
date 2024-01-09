within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndElectricHeater "Heat pump with an electric heater in series"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump(
  dp_nominal={heatPump.dpCon_nominal +dpEleHea_nominal},
  multiSum(nu=if use_eleHea then 3 else 2));

  parameter Boolean use_eleHea=true "=false to disable the electric heater"
   annotation(Dialog(group="Component choices"));

  AixLib.Fluid.HeatExchangers.HeatingRod eleHea(
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
    final Q_flow_nominal=parHeaPum.QSec_flow_nominal,
    final V=parEleHea.V_hr,
    final eta=parEleHea.eta_hr,
    use_countNumSwi=false) if use_eleHea "Electric heater"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  AixLib.Fluid.Interfaces.PassThroughMedium pasThrMedEleHea(redeclare package
      Medium = Medium, allowFlowReversal=allowFlowReversal) if not use_eleHea
    "Pass through if heating rod is not used"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  replaceable parameter RecordsCollection.EletricHeaterBaseDataDefinition parEleHea
    "Electric heater parameters"
                             annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{24,64},{36,76}})));
  Utilities.KPIs.DeviceKPICalculator KPIEleHea(
    use_reaInp=true,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true) if use_eleHea "Electric heater KPIs"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Utilities.KPIs.EnergyKPICalculator KPIQEleHea_flow(use_inpCon=false, y=eleHea.vol.heatPort.Q_flow)
    if use_eleHea "Electric heater heat flow rate"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Utilities.KPIs.EnergyKPICalculator KPIPEleEleHea(use_inpCon=false, y=eleHea.Pel)
    if use_eleHea "Electric heater heat flow rate"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
protected
  parameter Modelica.Units.SI.PressureDifference dpEleHea_nominal=if use_eleHea
       then parEleHea.dp_nominal else 0
    "Possible electric heater nominal pressure drop";

equation
  connect(heatPump.port_a1, pump.port_b) annotation (Line(points={{-30.5,-7},{
          -30.5,-70},{1.77636e-15,-70}}, color={0,127,255}));
  connect(pasThrMedEleHea.port_b, senTGenOut.port_a) annotation (Line(points={{40,30},
          {54,30},{54,80},{60,80}},     color={0,127,255}));
  connect(eleHea.port_b, senTGenOut.port_a) annotation (Line(points={{40,50},{54,50},
          {54,80},{60,80}}, color={0,127,255}));
  connect(pasThrMedEleHea.port_a, heatPump.port_b1) annotation (Line(points={{20,30},
          {10,30},{10,50},{-30,50},{-30,38},{-30.5,38},{-30.5,37}},     color={0,
          127,255}));
  connect(heatPump.port_b1, eleHea.port_a) annotation (Line(points={{-30.5,37},{-30.5,
          36},{-30,36},{-30,50},{20,50}}, color={0,127,255}));
  connect(eleHea.u, sigBusGen.uEleHea) annotation (Line(points={{18,56},{2,56},{2,
          98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiSum.u[3], eleHea.Pel) annotation (Line(points={{136,-82},{140,-82},
          {140,56},{41,56}}, color={0,0,127}));
  connect(KPIQEleHea_flow.KPI, outBusGen.QEleHea_flow) annotation (Line(points={{
          -117.8,-130},{0,-130},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(eleHea.Pel, KPIEleHea.uRea) annotation (Line(points={{41,56},{42,56},{42,
          -38},{-10,-38},{-10,-66},{92,-66},{92,-154},{-130,-154},{-130,-110},{-122.2,
          -110}}, color={0,0,127}));
  connect(KPIPEleEleHea.KPI, outBusGen.PEleEleHea) annotation (Line(points={{
          -117.8,-90},{-68,-90},{-68,-92},{0,-92},{0,-100}}, color={135,135,135}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIEleHea.KPI, outBusGen.eleHea) annotation (Line(points={{-97.8,-110},{
          -56,-110},{-56,-100},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end HeatPumpAndElectricHeater;
