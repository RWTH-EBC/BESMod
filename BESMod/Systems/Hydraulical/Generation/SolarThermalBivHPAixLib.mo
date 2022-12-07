within BESMod.Systems.Hydraulical.Generation;
model SolarThermalBivHPAixLib
  "Solar thermal assistet monoenergetic heat pump with heating rod using AixLibs ST model"
  extends HeatPumpAndHeatingRod(
    m_flow_nominal={Q_flow_nominal[1]*f_design[1]/dTTra_nominal[1]/4184,
        solarThermalParas.m_flow_nominal},
                                dTTra_nominal={if TDem_nominal[1] > 273.15 + 55
         then 10 elseif TDem_nominal[1] > 44.9 then 8 else 5,solarThermalParas.dTMax},
         final nParallelDem=2,
         final dp_nominal={heatPump.dpCon_nominal + dpHeaRod_nominal, dpST_nominal});
  replaceable parameter BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermalBaseDataDefinition
    solarThermalParas constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermalBaseDataDefinition(final c_p=cp)
    annotation (Dialog(group="Component data"), choicesAllMatching=true, Placement(transformation(extent={{-86,-62},
            {-66,-42}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpSTData
    annotation (Dialog(group="Component data"), choicesAllMatching=true, Placement(transformation(extent={{-98,
            -176},{-84,-162}})));
  AixLib.Fluid.Solar.Thermal.SolarThermal solarThermal(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=solarThermalParas.m_flow_nominal,
    final m_flow_small=1E-4*abs(solarThermalParas.m_flow_nominal),
    final show_T=false,
    final tau=1,
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final T_start=T_start,
    final transferHeat=false,
    final TAmb=Medium.T_default,
    final tauHeaTra=1200,
    final p_start=p_start,
    final dp_nominal=dpST_nominal,
    final rho_default=rho,
    final a=solarThermal.pressureDropCoeff,
    final A=solarThermalParas.A,
    final volPip=solarThermalParas.volPip,
    final pressureDropCoeff=solarThermalParas.pressureDropCoeff,
    final Collector=AixLib.DataBase.SolarThermal.SimpleAbsorber(
          eta_zero=solarThermalParas.eta_zero,
          c1=solarThermalParas.c1,
          c2=solarThermalParas.c2),
    vol(final energyDynamics=energyDynamics))                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-148})));

  IBPSA.Fluid.Movers.SpeedControlled_y pumpST(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    redeclare BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      final speed_rpm_nominal=pumpSTData.speed_rpm_nominal,
      final m_flow_nominal=solarThermalParas.m_flow_nominal,
      final dp_nominal=dpST_nominal+ dpDem_nominal[2],
      final rho=rho,
      final V_flowCurve=pumpSTData.V_flowCurve,
      final dpCurve=pumpSTData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=pumpSTData.addPowerToMedium,
    final tau=pumpSTData.tau,
    final use_inputFilter=pumpSTData.use_inputFilter,
    final riseTime=pumpSTData.riseTimeInpFilter,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-150})));

  IBPSA.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,              nPorts=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-150})));
  Modelica.Blocks.Sources.Constant uPumSolTheAlwOn(k=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-170})));

  Utilities.KPIs.EnergyKPICalculator KPIWel1(use_inpCon=false, y=-solarThermal.heater.port.Q_flow)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

    Modelica.Blocks.Sources.RealExpression reaExpSolTheTCol(y=solarThermal.senTCold.T)
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
    Modelica.Blocks.Sources.RealExpression reaExpSolTheTHot(y=solarThermal.senTHot.T)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

protected
  parameter Modelica.Units.SI.PressureDifference dpST_nominal=solarThermalParas.m_flow_nominal
      ^2*solarThermalParas.pressureDropCoeff/(rho^2)
    "Pressure drop at nominal mass flow rate";
equation

  connect(pumpST.port_a, bou.ports[1]) annotation (Line(points={{20,-150},{20,
          -136},{60,-136},{60,-150}},
                      color={0,127,255}));
  connect(pumpST.port_b, solarThermal.port_a) annotation (Line(points={{
          -1.77636e-15,-150},{-1.77636e-15,-148},{-20,-148}},
                                 color={0,127,255}));
  connect(solarThermal.port_b, portGen_out[2]) annotation (Line(points={{-40,
          -148},{-202,-148},{-202,124},{106,124},{106,82},{108,82},{108,82.5},{
          100,82.5}},                             color={0,127,255}));
  connect(portGen_in[2], pumpST.port_a) annotation (Line(points={{100,0.5},{102,
          0.5},{102,-6},{100,-6},{100,-48},{162,-48},{162,-136},{20,-136},{20,
          -150}},                color={0,127,255}));
  connect(pumpST.P, outBusGen.PelPumpST) annotation (Line(points={{-1,-159},{-6,
          -159},{-6,-132},{0,-132},{0,-100}},
                           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpSolTheTCol.y, outBusGen.TSolCol_in) annotation (Line(points={{
          -79,-110},{-62,-110},{-62,-126},{0,-126},{0,-100}}, color={0,0,127}),
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

  connect(solarThermal.T_air, weaBus.TDryBul) annotation (Line(points={{-24,
          -158},{-24,-178},{-194,-178},{-194,80},{-101,80}},
                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(solarThermal.Irradiation, weaBus.HGloHor) annotation (Line(points={{-30,
          -158},{-30,-182},{-198,-182},{-198,80},{-101,80}},  color={0,0,127}),
      Text(
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
  connect(uPumSolTheAlwOn.y, pumpST.y)
    annotation (Line(points={{39,-170},{10,-170},{10,-162}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-200,-180},{100,100}}),
        graphics={Rectangle(
          extent={{100,-180},{-200,-118}},
          lineColor={0,0,0},
          lineThickness=1), Text(
          extent={{-188,-122},{-124,-140}},
          textColor={0,0,0},
          textString="Solar Thermal")}));
end SolarThermalBivHPAixLib;
