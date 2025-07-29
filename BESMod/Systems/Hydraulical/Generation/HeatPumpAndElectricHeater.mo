within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndElectricHeater "Heat pump with an electric heater in series"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump(
    genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel,
  multiSum(nu=if use_eleHea then 2 else 1),
    resGen(
      final length=lengthPip,
      final resCoe=resCoe),
    resGenApp(final dp_nominal=parHeaPum.dpCon_nominal + dpEleHea_nominal +
          resGen.dp_nominal));
  parameter Modelica.Units.SI.Length lengthPip=8 "Length of all pipes"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoe=4*facPerBend
    "Factor to take into account resistance of bends, fittings etc."
    annotation (Dialog(tab="Pressure losses"));
  parameter Boolean use_eleHea=true "=false to disable the electric heater"
   annotation(Dialog(group="Component choices"));

  replaceable parameter RecordsCollection.ElectricHeater.Generic parEleHea
    "Electric heater parameters" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{24,64},{36,76}})));

  AixLib.Fluid.HeatExchangers.HeatingRod eleHea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final m_flow_small=1E-4*abs(m_flow_design[1]),
    final show_T=show_T,
    final dp_nominal=0,
    final tau=30,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=QSec_flow_nominal,
    final V=parEleHea.V_hr,
    final eta=parEleHea.eta,
    use_countNumSwi=false) if use_eleHea "Electric heater"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  AixLib.Fluid.Interfaces.PassThroughMedium pasThrMedEleHea(redeclare package
      Medium = Medium, allowFlowReversal=allowFlowReversal) if not use_eleHea
    "Pass through if electric heater is not used"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

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
  connect(pasThrMedEleHea.port_b, senTGenOut.port_a) annotation (Line(points={{40,30},
          {54,30},{54,80},{60,80}},     color={0,127,255}));
  connect(eleHea.port_b, senTGenOut.port_a) annotation (Line(points={{40,50},{54,50},
          {54,80},{60,80}}, color={0,127,255}));
  connect(pasThrMedEleHea.port_a, heatPump.port_b1) annotation (Line(points={{20,30},
          {10,30},{10,44},{-30,44},{-30,35}},                           color={0,
          127,255}));
  connect(heatPump.port_b1, eleHea.port_a) annotation (Line(points={{-30,35},{
          -30,44},{10,44},{10,50},{20,50}},
                                          color={0,127,255}));
  connect(eleHea.u, sigBusGen.uEleHea) annotation (Line(points={{18,56},{2,56},{2,
          98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiSum.u[2], eleHea.Pel) annotation (Line(points={{136,-82},{140,-82},
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
  connect(resGen.port_a, heatPump.port_a1) annotation (Line(points={{50,-20},{30,
          -20},{30,-18},{-30,-18},{-30,0}},color={0,127,255}));
end HeatPumpAndElectricHeater;
