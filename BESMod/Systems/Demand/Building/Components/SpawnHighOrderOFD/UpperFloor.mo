within BESMod.Systems.Demand.Building.Components.SpawnHighOrderOFD;
model UpperFloor "Spawn Groundfloor of the AixLib High Order OFD"
  replaceable package Medium = IBPSA.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Volume VZones[5] = {59.98,33.63,39.9,33.63,48.67} "Volume of the zones";
  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-70,78},
            {-28,122}}),         iconTransformation(extent={{-68,92},{-48,112}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zoneBedroom6(
    zoneName="JIlBdoXH9kyILsDvu4wx8A",
    redeclare package Medium = Medium,
    nPorts=4) annotation (Placement(transformation(extent={{-54,50},{-26,78}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zoneChildren7(
    zoneName="BGVPLnC4OUeqffvCvT6TTQ",
    redeclare package Medium = Medium,
    nPorts=4) annotation (Placement(transformation(extent={{44,50},{72,78}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zoneChildren10(
    zoneName="uFb0fbIbnUCa0AXLT56UfA",
    redeclare package Medium = Medium,
    nPorts=4)
    annotation (Placement(transformation(extent={{-54,-54},{-26,-26}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zoneCorridor8(
    zoneName="amiO3KhG402UMEU7Fs9xaA",
    redeclare package Medium = Medium,
    nPorts=4) annotation (Placement(transformation(extent={{44,-2},{72,26}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zoneBath9(
    zoneName="E4XJpmy03kW3qfdfjVrPLA",
    redeclare package Medium = Medium,
    nPorts=4) annotation (Placement(transformation(extent={{44,-54},{72,-26}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon[5]
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{-112,54},{-92,74}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad[5]
    "Heat port to radiative temperature and radiative energy balance"
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneMea[5](each final unit="K",
      each final displayUnit="degC") "Measured room air temperature"
    annotation (Placement(transformation(extent={{96,66},{134,104}}),
        iconTransformation(extent={{90,56},{120,86}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneOpeMea[5](each final unit="K",
      each final displayUnit="degC") "Measured room operative temperature"
    annotation (Placement(transformation(extent={{94,-68},{132,-30}}),
        iconTransformation(extent={{92,-38},{122,-8}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneRadMea[5](each final unit="K",
      each final displayUnit="degC") "Measured room radiative temperature"
    annotation (Placement(transformation(extent={{94,-100},{132,-62}}),
        iconTransformation(extent={{92,-78},{122,-48}})));
  Modelica.Fluid.Interfaces.FluidPort_a portVent_in[5](redeclare final package
              Medium = Medium)
    "Inlet for the demand of ventilation"
    annotation (Placement(transformation(extent={{90,30},{110,50}}),
        iconTransformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b portVent_out[5](redeclare final package
              Medium = Medium)
    "Outlet of the demand of Ventilation"
    annotation (Placement(transformation(extent={{92,-24},{112,-4}}),
        iconTransformation(extent={{90,-4},{110,16}})));
  Modelica.Blocks.Sources.Constant qGainFlowLatent(k=0) "No latent gains"
    annotation (Placement(transformation(extent={{-90,2},{-80,12}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAirBedroom6(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    m_flow=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-56,36},{-46,46}})));
  Buildings.Fluid.FixedResistances.PressureDrop ducBedroom6(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-44,24},{-56,36}})));
  Buildings.Fluid.Sources.Boundary_pT pAtmBedroom6(redeclare package Medium =
        Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-90,24},{-80,34}})));
  Modelica.Blocks.Interfaces.RealInput AirExchangePort[5]
    "1: Bedroom_UF, 2: Children1_UF, 3: Corridor_UF, 4: Bath_UF, 5: Children2_UF"
    annotation (Placement(transformation(extent={{-118,78},{-88,108}})));
  Modelica.Blocks.Math.Gain volumeFlow[5](k=VZones ./ 3600)
    "Convert air exchange into volume flow for each zone"
    annotation (Placement(transformation(extent={{-82,88},{-74,96}})));
  Modelica.Blocks.Math.Product calcMassFlowBedroom6
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{-84,44},{-74,54}})));
  Modelica.Blocks.Sources.RealExpression
                                   airDensity(y=rho)
    annotation (Placement(transformation(extent={{-100,42},{-92,50}})));
  Modelica.Blocks.Interfaces.RealInput IntGainsRad[5]
    "1: Bedroom_UF, 2: Children1_UF, 3: Corridor_UF, 4: Bath_UF, 5: Children2_UF"
    annotation (Placement(transformation(extent={{-120,-40},{-90,-10}})));
  Modelica.Blocks.Interfaces.RealInput IntGainsConv[5]
    "1: Bedroom_UF, 2: Children1_UF, 3: Corridor_UF, 4: Bath_UF, 5: Children2_UF"
    annotation (Placement(transformation(extent={{-122,4},{-92,34}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAirChildren7(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=1,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{44,40},{54,50}})));
  Buildings.Fluid.FixedResistances.PressureDrop ducChildren7(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1) "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{58,28},{46,40}})));
  Buildings.Fluid.Sources.Boundary_pT pAtmChildren7(redeclare package Medium =
        Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{12,26},{22,36}})));
  Modelica.Blocks.Math.Product calcMassFlowChildren7
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{18,46},{28,56}})));
  Modelica.Blocks.Sources.RealExpression
                                   airDensity1(y=rho)
    annotation (Placement(transformation(extent={{0,44},{8,52}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAirCorridor8(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=1,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{42,-14},{52,-4}})));
  Modelica.Blocks.Math.Product calcMassFlowCorridor8
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{16,-8},{26,2}})));
  Modelica.Blocks.Sources.RealExpression
                                   airDensity2(y=rho)
    annotation (Placement(transformation(extent={{-2,-10},{6,-2}})));
  Buildings.Fluid.FixedResistances.PressureDrop ducCorridor8(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{56,-26},{44,-14}})));
  Buildings.Fluid.Sources.Boundary_pT pAtmCorridor8(redeclare package Medium =
        Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{16,-22},{26,-12}})));
  Modelica.Blocks.Sources.RealExpression
                                   airDensity3(y=rho)
    annotation (Placement(transformation(extent={{-2,-60},{6,-52}})));
  Modelica.Blocks.Math.Product calcMassFlowBath9
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{16,-58},{26,-48}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAirBath9(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=1,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{42,-64},{52,-54}})));
  Buildings.Fluid.FixedResistances.PressureDrop ducBath9(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1) "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{56,-76},{44,-64}})));
  Buildings.Fluid.Sources.Boundary_pT pAtmBath9(redeclare package Medium =
        Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{10,-78},{20,-68}})));
  Modelica.Blocks.Sources.RealExpression
                                   airDensity4(y=rho)
    annotation (Placement(transformation(extent={{-98,-70},{-90,-62}})));
  Modelica.Blocks.Math.Product calcMassFlowChildren10
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{-80,-68},{-70,-58}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAirChildren10(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=1,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-54,-74},{-44,-64}})));
  Buildings.Fluid.FixedResistances.PressureDrop ducChildren10(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1) "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-40,-86},{-52,-74}})));
  Buildings.Fluid.Sources.Boundary_pT pAtmChildren10(redeclare package
      Medium =
        Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-86,-88},{-76,-78}})));
  Modelica.Blocks.Math.Add calcTZoneOpeMea[5](each k1=0.5, each k2=0.5)
    "Calculate room operative temperature"
    annotation (Placement(transformation(extent={{96,6},{110,20}})));
protected
  Modelica.Blocks.Interfaces.RealOutput TDryBul(
    final unit="K",
    displayUnit="degC")
    "Needed to calculate density";
  Modelica.Blocks.Interfaces.RealOutput pAtm(
    final unit="Pa")
    "Needed to calculate density";
  Real X[Medium.nX] = ones(Medium.nX);
  Modelica.Units.SI.Density rho "Density of fresh air. Needed to calculate mass flow from ACH";
equation
  connect(weaBus.pAtm, pAtm);
  connect(weaBus.TDryBul, TDryBul);
  rho = Medium.density(Medium.setState_pTX(
    pAtm, TDryBul, X));
  connect(heatPortRad[1], zoneBedroom6.heaPorRad) annotation (Line(points={{-100,
          -54},{-62,-54},{-62,-66},{-20,-66},{-20,59.8},{-40,59.8}}, color={191,
          0,0}));
  connect(heatPortRad[2], zoneChildren7.heaPorRad) annotation (Line(points={{-100,
          -52},{-62,-52},{-62,-66},{78,-66},{78,59.8},{58,59.8}}, color={191,0,0}));
  connect(heatPortRad[3], zoneCorridor8.heaPorRad) annotation (Line(points={{-100,
          -50},{-62,-50},{-62,-66},{78,-66},{78,7.8},{58,7.8}}, color={191,0,0}));
  connect(heatPortRad[4], zoneBath9.heaPorRad) annotation (Line(points={{-100,-48},
          {-62,-48},{-62,-66},{78,-66},{78,-44.2},{58,-44.2}}, color={191,0,0}));
  connect(heatPortRad[5], zoneChildren10.heaPorRad) annotation (Line(points={{-100,
          -46},{-62,-46},{-62,-66},{-20,-66},{-20,-44.2},{-40,-44.2}}, color={191,
          0,0}));
  connect(heatPortCon[1], zoneBedroom6.heaPorAir) annotation (Line(points={{-102,
          60},{-72,60},{-72,64},{-40,64}}, color={191,0,0}));
  connect(heatPortCon[2], zoneChildren7.heaPorAir) annotation (Line(points={{-102,
          62},{-72,62},{-72,86},{34,86},{34,64},{58,64}}, color={191,0,0}));
  connect(heatPortCon[3], zoneCorridor8.heaPorAir) annotation (Line(points={{-102,
          64},{-72,64},{-72,86},{34,86},{34,12},{58,12}}, color={191,0,0}));
  connect(heatPortCon[4], zoneBath9.heaPorAir) annotation (Line(points={{-102,66},
          {-72,66},{-72,86},{34,86},{34,-40},{58,-40}}, color={191,0,0}));
  connect(heatPortCon[5], zoneChildren10.heaPorAir) annotation (Line(points={{-102,
          68},{-72,68},{-72,-40},{-40,-40}}, color={191,0,0}));
  connect(zoneBedroom6.TAir, TZoneMea[1]) annotation (Line(points={{-25.3,76.6},
          {-4,76.6},{-4,96},{90,96},{90,77.4},{115,77.4}}, color={0,0,127}));
  connect(zoneChildren7.TAir, TZoneMea[2]) annotation (Line(points={{72.7,76.6},
          {90,76.6},{90,81.2},{115,81.2}}, color={0,0,127}));
  connect(zoneCorridor8.TAir, TZoneMea[3]) annotation (Line(points={{72.7,24.6},
          {90,24.6},{90,85},{115,85}}, color={0,0,127}));
  connect(zoneBath9.TAir, TZoneMea[4]) annotation (Line(points={{72.7,-27.4},{72.7,
          -28},{90,-28},{90,88.8},{115,88.8}}, color={0,0,127}));
  connect(zoneChildren10.TAir, TZoneMea[5]) annotation (Line(points={{-25.3,-27.4},
          {-4,-27.4},{-4,96},{90,96},{90,92.6},{115,92.6}}, color={0,0,127}));
  connect(zoneBedroom6.TRad, TZoneRadMea[1]) annotation (Line(points={{-25.3,73.8},
          {-12,73.8},{-12,-88.6},{113,-88.6}}, color={0,0,127}));
  connect(zoneChildren7.TRad, TZoneRadMea[2]) annotation (Line(points={{72.7,73.8},
          {72.7,74},{86,74},{86,-84.8},{113,-84.8}}, color={0,0,127}));
  connect(zoneCorridor8.TRad, TZoneRadMea[3]) annotation (Line(points={{72.7,21.8},
          {72.7,22},{86,22},{86,-81},{113,-81}}, color={0,0,127}));
  connect(zoneBath9.TRad, TZoneRadMea[4]) annotation (Line(points={{72.7,-30.2},
          {86,-30.2},{86,-77.2},{113,-77.2}}, color={0,0,127}));
  connect(zoneChildren10.TRad, TZoneRadMea[5]) annotation (Line(points={{-25.3,-30.2},
          {-18,-30.2},{-18,-30},{-12,-30},{-12,-88},{86,-88},{86,-73.4},{113,-73.4}},
        color={0,0,127}));
  connect(qGainFlowLatent.y, zoneBedroom6.qGai_flow[3]) annotation (Line(points={{-79.5,7},
          {-60,7},{-60,71.4667},{-55.4,71.4667}},           color={0,0,127}));
  connect(qGainFlowLatent.y, zoneChildren7.qGai_flow[3]) annotation (Line(
        points={{-79.5,7},{36,7},{36,71.4667},{42.6,71.4667}}, color={0,0,127}));
  connect(qGainFlowLatent.y, zoneCorridor8.qGai_flow[3]) annotation (Line(
        points={{-79.5,7},{36,7},{36,19.4667},{42.6,19.4667}}, color={0,0,127}));
  connect(qGainFlowLatent.y, zoneBath9.qGai_flow[3]) annotation (Line(points={{-79.5,7},
          {36,7},{36,-32.5333},{42.6,-32.5333}},    color={0,0,127}));
  connect(qGainFlowLatent.y, zoneChildren10.qGai_flow[3]) annotation (Line(
        points={{-79.5,7},{-60,7},{-60,-32.5333},{-55.4,-32.5333}}, color={0,0,127}));
  connect(AirExchangePort, volumeFlow.u) annotation (Line(points={{-103,93},{-102,
          93},{-102,92},{-82.8,92}}, color={0,0,127}));
  connect(airDensity.y, calcMassFlowBedroom6.u2)
    annotation (Line(points={{-91.6,46},{-85,46}}, color={0,0,127}));
  connect(volumeFlow[1].y, calcMassFlowBedroom6.u1) annotation (Line(points={{-73.6,
          92},{-68,92},{-68,100},{-94,100},{-94,52},{-85,52}}, color={0,0,127}));
  connect(calcMassFlowBedroom6.y, freshAirBedroom6.m_flow_in) annotation (
      Line(points={{-73.5,49},{-64,49},{-64,45},{-56,45}}, color={0,0,127}));
  connect(freshAirBedroom6.ports[1], zoneBedroom6.ports[1]) annotation (Line(
        points={{-46,41},{-44,41},{-44,50.63},{-41.05,50.63}}, color={0,127,255}));
  connect(zoneBedroom6.ports[2], ducBedroom6.port_a) annotation (Line(points={{
          -40.35,50.63},{-40.35,34},{-38,34},{-38,30},{-44,30}}, color={0,127,255}));
  connect(ducBedroom6.port_b, pAtmBedroom6.ports[1]) annotation (Line(points={
          {-56,30},{-68,30},{-68,29},{-80,29}}, color={0,127,255}));
  connect(weaBus, freshAirBedroom6.weaBus) annotation (Line(
      points={{-49,100},{-50,100},{-50,84},{-66,84},{-66,41.1},{-56,41.1}},
      color={255,204,51},
      thickness=0.5));
  connect(portVent_in[1], zoneBedroom6.ports[3]) annotation (Line(points={{100,36},
          {-39.65,36},{-39.65,50.63}}, color={0,127,255}));
  connect(portVent_out[1], zoneBedroom6.ports[4]) annotation (Line(points={{102,
          -18},{-24,-18},{-24,44},{-38.95,44},{-38.95,50.63}}, color={0,127,255}));
  connect(IntGainsRad[1], zoneBedroom6.qGai_flow[1]) annotation (Line(points={{-105,
          -31},{-62,-31},{-62,70.5333},{-55.4,70.5333}}, color={0,0,127}));
  connect(IntGainsRad[2], zoneChildren7.qGai_flow[1]) annotation (Line(points={{-105,
          -28},{32,-28},{32,70.5333},{42.6,70.5333}},      color={0,0,127}));
  connect(IntGainsRad[3], zoneCorridor8.qGai_flow[1]) annotation (Line(points={{-105,
          -25},{32,-25},{32,18.5333},{42.6,18.5333}},      color={0,0,127}));
  connect(IntGainsRad[4], zoneBath9.qGai_flow[1]) annotation (Line(points={{-105,
          -22},{32,-22},{32,-33.4667},{42.6,-33.4667}}, color={0,0,127}));
  connect(IntGainsRad[5], zoneChildren10.qGai_flow[1]) annotation (Line(points={{-105,
          -19},{-62,-19},{-62,-33.4667},{-55.4,-33.4667}},       color={0,0,127}));
  connect(IntGainsConv[1], zoneBedroom6.qGai_flow[2]) annotation (Line(points={{
          -107,13},{-64,13},{-64,71},{-55.4,71}}, color={0,0,127}));
  connect(IntGainsConv[2], zoneChildren7.qGai_flow[2]) annotation (Line(points={
          {-107,16},{30,16},{30,71},{42.6,71}}, color={0,0,127}));
  connect(IntGainsConv[3], zoneCorridor8.qGai_flow[2]) annotation (Line(points={
          {-107,19},{-74,19},{-74,18},{30,18},{30,19},{42.6,19}}, color={0,0,127}));
  connect(IntGainsConv[4], zoneBath9.qGai_flow[2]) annotation (Line(points={{-107,
          22},{-64,22},{-64,14},{28,14},{28,-33},{42.6,-33}}, color={0,0,127}));
  connect(IntGainsConv[5], zoneChildren10.qGai_flow[2]) annotation (Line(points=
         {{-107,25},{-64,25},{-64,-33},{-55.4,-33}}, color={0,0,127}));
  connect(volumeFlow[2].y, calcMassFlowChildren7.u1) annotation (Line(points={{
          -73.6,92},{10,92},{10,54},{17,54}}, color={0,0,127}));
  connect(airDensity1.y, calcMassFlowChildren7.u2)
    annotation (Line(points={{8.4,48},{17,48}}, color={0,0,127}));
  connect(calcMassFlowChildren7.y, freshAirChildren7.m_flow_in) annotation (
      Line(points={{28.5,51},{28.5,50},{38,50},{38,49},{44,49}}, color={0,0,127}));
  connect(freshAirChildren7.ports[1], zoneChildren7.ports[1]) annotation (Line(
        points={{54,45},{56.95,45},{56.95,50.63}}, color={0,127,255}));
  connect(zoneChildren7.ports[2], ducChildren7.port_a) annotation (Line(points=
         {{57.65,50.63},{57.65,42},{58,42},{58,34}}, color={0,127,255}));
  connect(ducChildren7.port_b, pAtmChildren7.ports[1]) annotation (Line(
        points={{46,34},{34,34},{34,31},{22,31}}, color={0,127,255}));
  connect(weaBus, freshAirChildren7.weaBus) annotation (Line(
      points={{-49,100},{-49,82},{38,82},{38,45.1},{44,45.1}},
      color={255,204,51},
      thickness=0.5));
  connect(portVent_in[2], zoneChildren7.ports[3]) annotation (Line(points={{100,
          38},{58.35,38},{58.35,50.63}}, color={0,127,255}));
  connect(portVent_out[2], zoneChildren7.ports[4]) annotation (Line(points={{102,
          -16},{80,-16},{80,40},{59.05,40},{59.05,50.63}}, color={0,127,255}));
  connect(volumeFlow[3].y, calcMassFlowCorridor8.u1) annotation (Line(points={{
          -73.6,92},{10,92},{10,0},{15,0}}, color={0,0,127}));
  connect(airDensity2.y,calcMassFlowCorridor8. u2)
    annotation (Line(points={{6.4,-6},{15,-6}}, color={0,0,127}));
  connect(calcMassFlowCorridor8.y,freshAirCorridor8. m_flow_in)
    annotation (Line(points={{26.5,-3},{26.5,-5},{42,-5}}, color={0,0,127}));
  connect(freshAirCorridor8.ports[1], zoneCorridor8.ports[1]) annotation (Line(
        points={{52,-9},{56.95,-9},{56.95,-1.37}}, color={0,127,255}));
  connect(zoneCorridor8.ports[2], ducCorridor8.port_a) annotation (Line(points=
         {{57.65,-1.37},{56,-1.37},{56,-20}}, color={0,127,255}));
  connect(ducCorridor8.port_b,pAtmCorridor8. ports[1])
    annotation (Line(points={{44,-20},{44,-17},{26,-17}}, color={0,127,255}));
  connect(portVent_in[3], zoneCorridor8.ports[3]) annotation (Line(points={{100,
          40},{76,40},{76,-6},{58.35,-6},{58.35,-1.37}}, color={0,127,255}));
  connect(portVent_out[3], zoneCorridor8.ports[4]) annotation (Line(points={{102,
          -14},{59.05,-14},{59.05,-1.37}}, color={0,127,255}));
  connect(weaBus,freshAirCorridor8. weaBus) annotation (Line(
      points={{-49,100},{-48,100},{-48,82},{38,82},{38,-8.9},{42,-8.9}},
      color={255,204,51},
      thickness=0.5));
  connect(volumeFlow[4].y, calcMassFlowBath9.u1) annotation (Line(points={{-73.6,
          92},{10,92},{10,-50},{15,-50}}, color={0,0,127}));
  connect(airDensity3.y, calcMassFlowBath9.u2)
    annotation (Line(points={{6.4,-56},{15,-56}}, color={0,0,127}));
  connect(calcMassFlowBath9.y, freshAirBath9.m_flow_in) annotation (Line(
        points={{26.5,-53},{26.5,-55},{42,-55}}, color={0,0,127}));
  connect(freshAirBath9.ports[1], zoneBath9.ports[1]) annotation (Line(points={
          {52,-59},{54,-59},{54,-53.37},{56.95,-53.37}}, color={0,127,255}));
  connect(zoneBath9.ports[2], ducBath9.port_a) annotation (Line(points={{57.65,
          -53.37},{57.65,-62},{56,-62},{56,-70}}, color={0,127,255}));
  connect(ducBath9.port_b, pAtmBath9.ports[1]) annotation (Line(points={{44,-70},
          {42,-70},{42,-73},{20,-73}}, color={0,127,255}));
  connect(portVent_in[4], zoneBath9.ports[3]) annotation (Line(points={{100,42},
          {76,42},{76,-12},{80,-12},{80,-52},{76,-52},{76,-56},{58.35,-56},{58.35,
          -53.37}}, color={0,127,255}));
  connect(portVent_out[4], zoneBath9.ports[4]) annotation (Line(points={{102,-12},
          {80,-12},{80,-54},{76,-54},{76,-58},{59.05,-58},{59.05,-53.37}},
        color={0,127,255}));
  connect(weaBus, freshAirBath9.weaBus) annotation (Line(
      points={{-49,100},{-49,82},{38,82},{38,-58.9},{42,-58.9}},
      color={255,204,51},
      thickness=0.5));
  connect(airDensity4.y, calcMassFlowChildren10.u2)
    annotation (Line(points={{-89.6,-66},{-81,-66}}, color={0,0,127}));
  connect(volumeFlow[5].y, calcMassFlowChildren10.u1) annotation (Line(points={
          {-73.6,92},{-68,92},{-68,100},{-94,100},{-94,-60},{-81,-60}}, color={0,
          0,127}));
  connect(calcMassFlowChildren10.y, freshAirChildren10.m_flow_in) annotation (
     Line(points={{-69.5,-63},{-69.5,-65},{-54,-65}}, color={0,0,127}));
  connect(freshAirChildren10.ports[1], zoneChildren10.ports[1]) annotation (
      Line(points={{-44,-69},{-44,-60},{-41.05,-60},{-41.05,-53.37}}, color={0,127,
          255}));
  connect(zoneChildren10.ports[2], ducChildren10.port_a) annotation (Line(
        points={{-40.35,-53.37},{-40.35,-68},{-32,-68},{-32,-80},{-40,-80}},
        color={0,127,255}));
  connect(ducChildren10.port_b, pAtmChildren10.ports[1]) annotation (Line(
        points={{-52,-80},{-54,-80},{-54,-83},{-76,-83}}, color={0,127,255}));
  connect(portVent_in[5], zoneChildren10.ports[3]) annotation (Line(points={{100,
          44},{76,44},{76,-12},{80,-12},{80,-52},{82,-52},{82,-90},{-30,-90},{-30,
          -80},{-32,-80},{-32,-68},{-39.65,-68},{-39.65,-53.37}}, color={0,127,255}));
  connect(portVent_out[5], zoneChildren10.ports[4]) annotation (Line(points={{102,
          -10},{80,-10},{80,-54},{82,-54},{82,-90},{-30,-90},{-30,-80},{-32,-80},
          {-32,-68},{-38.95,-68},{-38.95,-53.37}}, color={0,127,255}));
  connect(weaBus, freshAirChildren10.weaBus) annotation (Line(
      points={{-49,100},{-49,84},{-66,84},{-66,-68.9},{-54,-68.9}},
      color={255,204,51},
      thickness=0.5));
  connect(zoneBedroom6.TAir, calcTZoneOpeMea[1].u1) annotation (Line(points={{-25.3,
          76.6},{-4,76.6},{-4,96},{90,96},{90,17.2},{94.6,17.2}}, color={0,0,127}));
  connect(zoneBedroom6.TRad, calcTZoneOpeMea[1].u2) annotation (Line(points={{-25.3,
          73.8},{-12,73.8},{-12,-88},{86,-88},{86,8},{90,8},{90,8.8},{94.6,8.8}},
        color={0,0,127}));
  connect(zoneChildren7.TAir, calcTZoneOpeMea[2].u1) annotation (Line(points={{72.7,
          76.6},{88,76.6},{88,17.2},{94.6,17.2}}, color={0,0,127}));
  connect(zoneChildren7.TRad, calcTZoneOpeMea[2].u2) annotation (Line(points={{72.7,
          73.8},{72.7,74},{86,74},{86,8.8},{94.6,8.8}}, color={0,0,127}));
  connect(zoneCorridor8.TAir, calcTZoneOpeMea[3].u1) annotation (Line(points={{72.7,
          24.6},{72.7,24},{88,24},{88,17.2},{94.6,17.2}}, color={0,0,127}));
  connect(zoneCorridor8.TRad, calcTZoneOpeMea[3].u2) annotation (Line(points={{72.7,
          21.8},{86,21.8},{86,8.8},{94.6,8.8}}, color={0,0,127}));
  connect(zoneBath9.TAir, calcTZoneOpeMea[4].u1) annotation (Line(points={{72.7,
          -27.4},{72.7,-28},{88,-28},{88,17.2},{94.6,17.2}}, color={0,0,127}));
  connect(zoneBath9.TRad, calcTZoneOpeMea[4].u2) annotation (Line(points={{72.7,
          -30.2},{86,-30.2},{86,8.8},{94.6,8.8}}, color={0,0,127}));
  connect(zoneChildren10.TAir, calcTZoneOpeMea[5].u1) annotation (Line(points={{
          -25.3,-27.4},{-4,-27.4},{-4,96},{90,96},{90,86},{88,86},{88,17.2},{94.6,
          17.2}}, color={0,0,127}));
  connect(zoneChildren10.TRad, calcTZoneOpeMea[5].u2) annotation (Line(points={{
          -25.3,-30.2},{-12,-30.2},{-12,-88},{86,-88},{86,8.8},{94.6,8.8}},
        color={0,0,127}));
  connect(calcTZoneOpeMea.y, TZoneOpeMea) annotation (Line(points={{110.7,13},{118,
          13},{118,-26},{92,-26},{92,-49},{113,-49}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://BESMod/Resources/Images/Buildings/HOM_OFD/Upperfloor_plan.png"),
        Text(
          extent={{-68,68},{4,58}},
          lineColor={0,0,0},
          textString="Bedroom"),
        Text(
          extent={{-70,38},{2,28}},
          lineColor={0,0,0},
          textString="(6)"),
        Text(
          extent={{10,78},{56,66}},
          lineColor={0,0,0},
          textString="Children"),
        Text(
          extent={{10,60},{56,48}},
          lineColor={0,0,0},
          textString="(7)"),
        Text(
          extent={{10,28},{58,0}},
          lineColor={0,0,0},
          textString="Corridor"),
        Text(
          extent={{10,4},{58,-24}},
          lineColor={0,0,0},
          textString="(8)"),
        Text(
          extent={{10,-44},{60,-56}},
          lineColor={0,0,0},
          textString="Bath"),
        Text(
          extent={{10,-64},{60,-76}},
          lineColor={0,0,0},
          textString="(9)"),
        Text(
          extent={{-56,-30},{-12,-44}},
          lineColor={0,0,0},
          textString="Children"),
        Text(
          extent={{-56,-52},{-12,-66}},
          lineColor={0,0,0},
          textString="(10)")}));
end UpperFloor;
