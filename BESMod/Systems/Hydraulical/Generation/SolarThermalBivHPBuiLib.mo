within BESMod.Systems.Hydraulical.Generation;
model SolarThermalBivHPBuiLib
  "Solar thermal assistet monoenergetic heat pump with heating rod"
  extends HeatPumpAndHeatingRod(dTTra_nominal={if TDem_nominal[1] > 273.15 + 55
         then 10 elseif TDem_nominal[1] > 44.9 then 8 else 5,solarThermalParas.dTMax},
         final nParallelDem=2,
         final dp_nominal={heatPump.dpCon_nominal + dpHeaRod_nominal, dpST_nominal});
  replaceable parameter BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermalBaseDataDefinition
    solarThermalParas constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermalBaseDataDefinition( final c_p=cp)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-86,-62},
            {-66,-42}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpSTData
    annotation (choicesAllMatching=true, Placement(transformation(extent={{4,-152},{18,-138}})));
  Buildings.Fluid.SolarCollectors.EN12975 solCol(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_small=1E-4*abs(solarThermalParas.m_flow_nominal),
    final show_T=false,
    final T_start=T_start,
    final p_start=p_start,
    nSeg=5,
    lat=0.88619695781269,
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
        rotation=90,
        origin={-32,-84})));

  IBPSA.Fluid.Movers.SpeedControlled_y pumpST(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
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
        origin={-56,-150})));

  Utilities.KPIs.InternalKPICalculator KPIWel1(
    calc_singleOnTime=true,
    calc_integral=true,
    calc_movAve=false,
    y=sum(solCol.vol.heatPort.Q_flow))
    annotation (Placement(transformation(extent={{-104,-134},{-92,-112}})));

  Modelica.Blocks.Logical.Switch switch3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-26,-162})));
  Modelica.Blocks.Sources.Constant AirOrSoil2(k=0)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-58,-178})));
  Modelica.Blocks.Logical.Hysteresis       isOnHR1(uLow=10, uHigh=100)
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-111,-151})));
protected
  parameter Modelica.SIunits.PressureDifference dpST_nominal=solarThermalParas.m_flow_nominal
      ^2*solarThermalParas.pressureDropCoeff/(rho^2)
    "Pressure drop at nominal mass flow rate";
equation

  connect(pumpST.port_a, bou.ports[1]) annotation (Line(points={{38,-104},{54,-104},
          {54,-118}}, color={0,127,255}));
  connect(pumpST.port_b, solCol.port_a) annotation (Line(points={{18,-104},{-32,
          -104},{-32,-94}}, color={0,127,255}));
  connect(solCol.port_b, portGen_out[2]) annotation (Line(points={{-32,-74},{-32,
          -62},{132,-62},{132,82.5},{100,82.5}}, color={0,127,255}));
  connect(portGen_in[2], pumpST.port_a) annotation (Line(points={{100,0.5},{102,
          0.5},{102,-104},{38,-104}},
                                 color={0,127,255}));
  connect(pumpST.P, outBusGen.PelPumpST) annotation (Line(points={{17,-113},{0,
          -113},{0,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIWel1.KPIBus, outBusGen.QST_flow) annotation (Line(
      points={{-91.88,-123},{-91.88,-120},{-88,-120},{-88,-70},{0,-70},{0,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(weaBus, solCol.weaBus) annotation (Line(
      points={{-101,80},{-106,80},{-106,-94},{-41.6,-94}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(switch3.y, pumpST.y) annotation (Line(points={{-15,-162},{6,-162},{6,
          -160},{28,-160},{28,-116}}, color={0,0,127}));
  connect(switch3.u1, AirOrSoil1.y) annotation (Line(points={{-38,-154},{-44,
          -154},{-44,-150},{-49.4,-150}}, color={0,0,127}));
  connect(AirOrSoil2.y, switch3.u3) annotation (Line(points={{-51.4,-178},{-46,
          -178},{-46,-170},{-38,-170}}, color={0,0,127}));
  connect(switch3.u2, isOnHR1.y) annotation (Line(points={{-38,-162},{-38,-176},
          {-34,-176},{-34,-158},{-105.5,-158},{-105.5,-151}}, color={255,0,255}));
  connect(isOnHR1.u, weaBus.HDirNor) annotation (Line(points={{-117,-151},{-117,
          -6},{-94,-6},{-94,38},{-76,38},{-76,44},{-74,44},{-74,80},{-101,80}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end SolarThermalBivHPBuiLib;
