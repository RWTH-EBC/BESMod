within BESMod.Systems.Hydraulical.Generation;
model DetailedSolarThermalWithHeatPump
  "Detailed solar thermal model with monoenergetic heat pump"
  extends HeatPumpAndElectricHeater(
    m_flow_nominal={Q_flow_nominal[1]*f_design[1]/dTTra_nominal[1]/4184,
        solarThermalParas.m_flow_nominal},
    redeclare package Medium = IBPSA.Media.Water,
                                dTTra_nominal={if TDem_nominal[1] > 273.15 + 55
         then 10 elseif TDem_nominal[1] > 44.9 then 8 else 5,solarThermalParas.dTMax},
         final nParallelDem=2,
         final dp_nominal={heatPump.dpCon_nominal +dpEleHea_nominal,  dpST_nominal});
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.Generic
    solarThermalParas constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.Generic(
      final c_p=cp) annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-86,-62},{-66,-42}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPumSolThe
    "Parameters for solar thermal pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-80,-158},{-66,-144}})));
  Buildings.Fluid.SolarCollectors.EN12975 solCol(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=true,
    final m_flow_small=1E-4*abs(solarThermalParas.m_flow_nominal),
    final show_T=false,
    final T_start=T_start,
    final p_start=p_start,
    nSeg=5,
    azi=0,
    til=0.5235987755983,
    rho=0.2,
    use_shaCoe_in=false,
    shaCoe=0,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    totalArea=solarThermalParas.A,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector(
        ATyp=Buildings.Fluid.SolarCollectors.Types.Area.Aperture,
        A=4.302,
        mDry=484,
        V=4.4/1000,
        dp_nominal=100,
        mperA_flow_nominal=solarThermalParas.m_flow_nominal/solarThermalParas.A,
        B0=0,
        B1=0,
        y_intercept=solarThermalParas.eta_zero,
        slope=0,
        IAMDiff=0.133,
        C1=solarThermalParas.c1,
        C2=solarThermalParas.c2,
        G_nominal=solarThermalParas.GMax,
        dT_nominal=solarThermalParas.dTMax))                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-170})));

  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pumpSolThe(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_nominal=solarThermalParas.m_flow_nominal,
    final dp_nominal=dpST_nominal + dpDem_nominal[2],
      final addPowerToMedium=parPumSolThe.addPowerToMedium,
    final tau=parPumSolThe.tau,
    final use_riseTime=parPumSolThe.use_riseTime,
    final riseTime=parPumSolThe.riseTimeInpFilter,
    final y_start=1) "Solar thermal pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-170})));

  IBPSA.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,              nPorts=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-170})));
  Modelica.Blocks.Sources.Constant AirOrSoil1(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,-150})));

  Utilities.KPIs.EnergyKPICalculator KPIQSol(use_inpCon=false, y=sum(solCol.vol.heatPort.Q_flow))
    "Solar thermal KPI"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));

  Modelica.Blocks.Logical.Switch switch3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-158,-170})));
  Modelica.Blocks.Sources.Constant AirOrSoil2(k=0)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,-190})));
  Modelica.Blocks.Logical.Hysteresis       isOnHR1(uLow=10, uHigh=100)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-210,-170})));
protected
  parameter Modelica.Units.SI.PressureDifference dpST_nominal=solarThermalParas.m_flow_nominal
      ^2*solarThermalParas.pressureDropCoeff/(rho^2)
    "Pressure drop at nominal mass flow rate";
equation

  connect(pumpSolThe.port_a, bou.ports[1])
    annotation (Line(points={{40,-170},{60,-170}}, color={0,127,255}));
  connect(pumpSolThe.port_b, solCol.port_a)
    annotation (Line(points={{20,-170},{-20,-170}}, color={0,127,255}));
  connect(solCol.port_b, portGen_out[2]) annotation (Line(points={{-40,-170},{
          -40,-124},{-232,-124},{-232,126},{116,126},{116,78},{106,78},{106,
          82.5},{100,82.5}},                     color={0,127,255}));
  connect(portGen_in[2], pumpSolThe.port_a) annotation (Line(points={{100,0.5},{
          102,0.5},{102,-156},{44,-156},{44,-170},{40,-170}}, color={0,127,255}));
  connect(pumpSolThe.P, outBusGen.PelPumpST) annotation (Line(points={{19,-179},{
          0,-179},{0,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(weaBus, solCol.weaBus) annotation (Line(
      points={{-101,80},{-101,-6},{-104,-6},{-104,-108},{-108,-108},{-108,-184},
          {-20,-184},{-20,-179.6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(switch3.y, pumpSolThe.y) annotation (Line(points={{-147,-170},{-130,-170},
          {-130,-186},{30,-186},{30,-182}}, color={0,0,127}));
  connect(AirOrSoil2.y, switch3.u3) annotation (Line(points={{-179,-190},{-179,
          -186},{-170,-186},{-170,-178}},
                                        color={0,0,127}));
  connect(switch3.u2, isOnHR1.y) annotation (Line(points={{-170,-170},{-199,
          -170}},                                             color={255,0,255}));
  connect(isOnHR1.u, weaBus.HDirNor) annotation (Line(points={{-222,-170},{-228,-170},
          {-228,28},{-100.895,28},{-100.895,80.11}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(AirOrSoil1.y, switch3.u1) annotation (Line(points={{-179,-150},{-170,
          -150},{-170,-162}}, color={0,0,127}));
  connect(KPIQSol.KPI, outBusGen.QSolThe_flow) annotation (Line(points={{-37.8,
          -110},{0,-110},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Diagram(coordinateSystem(extent={{-220,-200},{100,100}}),
        graphics={Text(
          extent={{-216,-122},{-152,-140}},
          textColor={0,0,0},
          textString="Solar Thermal"), Rectangle(
          extent={{94,-198},{-218,-136}},
          lineColor={0,0,0},
          lineThickness=1)}));
end DetailedSolarThermalWithHeatPump;
