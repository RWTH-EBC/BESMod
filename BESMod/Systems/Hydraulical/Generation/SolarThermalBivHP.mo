within BESMod.Systems.Hydraulical.Generation;
model SolarThermalBivHP
  "Solar thermal assistet monoenergetic heat pump with heating rod"
  extends HeatPumpAndHeatingRod(dTTra_nominal={if TDem_nominal[1] > 273.15 + 55
         then 10 elseif TDem_nominal[1] > 44.9 then 8 else 5,solarThermalParas.dTMax},
         final nParallelDem=2,
         final dp_nominal={heatPump.dpCon_nominal + dpHeaRod_nominal, dpST_nominal});
  replaceable parameter BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermalBaseDataDefinition
    solarThermalParas constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermalBaseDataDefinition(final c_p=cp)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-86,-62},
            {-66,-42}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpSTData
    annotation (choicesAllMatching=true, Placement(transformation(extent={{4,-152},{18,-138}})));
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
        rotation=90,
        origin={-32,-84})));

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
        origin={28,-104})));

  IBPSA.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,              nPorts=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={54,-128})));
  Modelica.Blocks.Sources.Constant AirOrSoil1(k=1)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={14,-126})));

  Utilities.KPIs.InternalKPICalculator
                                    KPIWel1(
    unit="W",
    integralUnit="J",
    calc_singleOnTime=true,
    calc_integral=true,
    calc_movAve=false,
    y=-solarThermal.heater.port.Q_flow)
    annotation (Placement(transformation(extent={{-104,-134},{-92,-112}})));

    Modelica.Blocks.Sources.RealExpression realExpression(y=solarThermal.senTCold.T)
      annotation (Placement(transformation(extent={{-112,-118},{-92,-98}})));
    Modelica.Blocks.Sources.RealExpression realExpression1(y=solarThermal.senTHot.T)
      annotation (Placement(transformation(extent={{-102,-156},{-82,-136}})));

protected
  parameter Modelica.Units.SI.PressureDifference dpST_nominal=solarThermalParas.m_flow_nominal
      ^2*solarThermalParas.pressureDropCoeff/(rho^2)
    "Pressure drop at nominal mass flow rate";
equation

  connect(pumpST.port_a, bou.ports[1]) annotation (Line(points={{38,-104},{54,-104},
          {54,-118}}, color={0,127,255}));
  connect(pumpST.port_b, solarThermal.port_a) annotation (Line(points={{18,-104},
          {-32,-104},{-32,-94}}, color={0,127,255}));
  connect(solarThermal.port_b, portGen_out[2]) annotation (Line(points={{-32,-74},
          {-32,-62},{132,-62},{132,82.5},{100,82.5}},
                                                  color={0,127,255}));
  connect(portGen_in[2], pumpST.port_a) annotation (Line(points={{100,0.5},{102,
          0.5},{102,-104},{38,-104}},
                                 color={0,127,255}));
  connect(pumpST.P, outBusGen.PelPumpST) annotation (Line(points={{17,-113},{0,
          -113},{0,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(AirOrSoil1.y, pumpST.y) annotation (Line(points={{20.6,-126},{28,
          -126},{28,-116}},
                      color={0,0,127}));
  connect(KPIWel1.KPIBus, outBusGen.QST_flow) annotation (Line(
      points={{-91.88,-123},{-91.88,-120},{-88,-120},{-88,-70},{0,-70},{0,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realExpression.y, outBusGen.TSolCol_in) annotation (Line(points={{-91,
          -108},{-88,-108},{-88,-88},{-90,-88},{-90,-66},{-28,-66},{-28,-64},{0,
          -64},{0,-100}},                 color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
  connect(realExpression1.y, outBusGen.TSolCol_out) annotation (Line(points={{-81,
          -146},{-81,-110},{-86,-110},{-86,-68},{-28,-68},{-28,-66},{0,-66},{0,-100}},
                                                                 color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

  connect(solarThermal.T_air, weaBus.TDryBul) annotation (Line(points={{-42,-90},
          {-101,-90},{-101,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(solarThermal.Irradiation, weaBus.HGloHor) annotation (Line(points={{
          -42,-84},{-66,-84},{-66,-80},{-101,-80},{-101,80}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end SolarThermalBivHP;
