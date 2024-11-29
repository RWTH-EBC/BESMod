within BESMod.Systems.Hydraulical.Generation;
model SimpleSolarThermalWithHeatPump
  "Simple solar thermal model with monoenergetic heat pump"
  extends HeatPumpAndElectricHeater(
    m_flow_nominal={Q_flow_nominal[1]*f_design[1]/dTTra_nominal[1]/4184,parSolThe.m_flow_nominal},
    dTTra_nominal={if TDem_nominal[1] > 273.15 + 55 then 10 elseif TDem_nominal[1] >
        44.9 then 8 else 5,parSolThe.dTMax},
    final nParallelDem=2,
    final dp_nominal={heatPump.dpCon_nominal +dpEleHea_nominal, dpST_nominal});

  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.Generic
    parSolThe constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.Generic(
      final c_p=cp) "Parameters for solar thermal system" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-86,-62},{-66,-42}})));
  AixLib.Fluid.Solar.Thermal.SolarThermal solThe(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=parSolThe.m_flow_nominal,
    final m_flow_small=1E-4*abs(parSolThe.m_flow_nominal),
    final show_T=false,
    final tau=parTemSen.tau,
    final initType=parTemSen.initType,
    final T_start=T_start,
    final transferHeat=parTemSen.transferHeat,
    final TAmb=parTemSen.TAmb,
    final tauHeaTra=parTemSen.tauHeaTra,
    dp_start=solThe.pressureDropCoeff*(solThe.m_flow_start/solThe.Medium.density(
        solThe.Medium.setState_pTX(
        solThe.p_start,
        solThe.T_start,
        solThe.Medium.reference_X)))^2,
    final p_start=p_start,
    final dp_nominal=dpST_nominal,
    final rho_default=rho,
    final a=solThe.pressureDropCoeff,
    final A=parSolThe.A,
    final volPip=parSolThe.volPip,
    final pressureDropCoeff=parSolThe.pressureDropCoeff,
    final Collector=AixLib.DataBase.SolarThermal.SimpleAbsorber(
        eta_zero=parSolThe.eta_zero,
        c1=parSolThe.c1,
        c2=parSolThe.c2),
    vol(final energyDynamics=energyDynamics)) "Solar thermal collector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-148})));

  Utilities.KPIs.EnergyKPICalculator KPIWel1(use_inpCon=false, y=-solThe.heater.port.Q_flow)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Modelica.Blocks.Sources.RealExpression reaExpSolTheTCol(y=solThe.senTCold.T)
    annotation (Placement(transformation(extent={{-100,-146},{-80,-126}})));
  Modelica.Blocks.Sources.RealExpression reaExpSolTheTHot(y=solThe.senTHot.T)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

protected
  parameter Modelica.Units.SI.PressureDifference dpST_nominal=parSolThe.m_flow_nominal
      ^2*parSolThe.pressureDropCoeff/(rho^2)
    "Pressure drop at nominal mass flow rate";
equation

  connect(solThe.port_b, portGen_out[2]) annotation (Line(points={{-40,-148},{-202,
          -148},{-202,124},{106,124},{106,82},{108,82},{108,82.5},{100,82.5}},
        color={0,127,255}));
  connect(reaExpSolTheTCol.y, outBusGen.TSolCol_in) annotation (Line(points={{-79,
          -136},{-68,-136},{-68,-124},{0,-124},{0,-100}},     color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaExpSolTheTHot.y, outBusGen.TSolCol_out) annotation (Line(points={{
          -79,-90},{-66,-90},{-66,-108},{-16,-108},{-16,-116},{0,-116},{0,-100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(solThe.T_air, weaBus.TDryBul) annotation (Line(points={{-24,-158},{-24,-178},
          {-194,-178},{-194,80.11},{-100.895,80.11}},
                                            color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(solThe.Irradiation, weaBus.HGloHor) annotation (Line(points={{-30,-158},
          {-30,-182},{-198,-182},{-198,80.11},{-100.895,80.11}},
                                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIWel1.KPI, outBusGen.QSolThe_flow) annotation (Line(points={{-37.8,
          -90},{-24,-90},{-24,-88},{0,-88},{0,-100}}, color={135,135,135}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_in[2], solThe.port_a) annotation (Line(points={{100,0.5},{96,
          0.5},{96,-148},{-20,-148}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-200,-180},{100,100}}),
        graphics={Rectangle(
          extent={{100,-180},{-200,-118}},
          lineColor={0,0,0},
          lineThickness=1), Text(
          extent={{-188,-122},{-124,-140}},
          textColor={0,0,0},
          textString="Solar Thermal")}));
end SimpleSolarThermalWithHeatPump;
