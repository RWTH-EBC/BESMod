within BESMod.Systems.Demand.Building.Components.SpawnHighOrderOFD;
model Attic "Spawn Attic of the AixLib High Order OFD"
  replaceable package Medium = IBPSA.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Volume VZone = 199.99 "Volume of the zone";
  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-70,78},
            {-28,122}}),         iconTransformation(extent={{-68,92},{-48,112}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zoneAttic(
    zoneName="IfKJfrdT40ehbMFAOP2OHQ",
    redeclare package Medium = Medium,
    nPorts=2) annotation (Placement(transformation(extent={{-6,-6},{22,22}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneMea(each final unit="K", each final
            displayUnit="degC") "Measured room air temperature" annotation (
      Placement(transformation(extent={{96,66},{134,104}}), iconTransformation(
          extent={{90,50},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneOpeMea(each final unit="K", each final
            displayUnit="degC") "Measured room operative temperature"
                                                                annotation (
      Placement(transformation(extent={{96,2},{134,40}}),   iconTransformation(
          extent={{90,-6},{120,24}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneRadMea(each final unit="K", each final
            displayUnit="degC") "Measured room radiative temperature" annotation (
      Placement(transformation(extent={{94,-100},{132,-62}}),
        iconTransformation(extent={{90,-64},{120,-34}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAirAttic(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    m_flow=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-46,-26},{-30,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop ducAttic(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1) "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-10,-50},{-26,-32}})));
  Buildings.Fluid.Sources.Boundary_pT pAtmAttic(redeclare package Medium =
        Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-64,-50},{-48,-34}})));
  Modelica.Blocks.Interfaces.RealInput AirExchangePort "Attic air exchange"
    annotation (Placement(transformation(extent={{-122,-8},{-92,22}})));
  Modelica.Blocks.Math.Gain volumeFlow(k=VZone/3600)
    "Convert air exchange into volume flow"
    annotation (Placement(transformation(extent={{-82,2},{-74,10}})));
  Modelica.Blocks.Math.Product calcMassFlow_attic
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{-70,-16},{-60,-6}})));
  Modelica.Blocks.Sources.RealExpression airDensity(y=rho)
    annotation (Placement(transformation(extent={{-98,-22},{-80,-6}})));
  Modelica.Blocks.Sources.Constant qGain[3](k={0,0,0}) "No internal gains "
    annotation (Placement(transformation(extent={{-36,26},{-22,40}})));
  Modelica.Blocks.Math.Add calcTZoneOpeMea(k1=0.5, k2=0.5)
    "Calculate room operative temperature"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
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
  connect(zoneAttic.TAir, TZoneMea) annotation (Line(points={{22.7,20.6},{32,
          20.6},{32,85},{115,85}}, color={0,0,127}));
  connect(zoneAttic.TRad, TZoneRadMea) annotation (Line(points={{22.7,17.8},{
          22.7,18},{32,18},{32,-81},{113,-81}}, color={0,0,127}));
  connect(AirExchangePort, volumeFlow.u) annotation (Line(points={{-107,7},{-94.9,
          7},{-94.9,6},{-82.8,6}}, color={0,0,127}));
  connect(airDensity.y, calcMassFlow_attic.u2)
    annotation (Line(points={{-79.1,-14},{-71,-14}}, color={0,0,127}));
  connect(volumeFlow.y, calcMassFlow_attic.u1)
    annotation (Line(points={{-73.6,6},{-73.6,-8},{-71,-8}}, color={0,0,127}));
  connect(calcMassFlow_attic.y, freshAirAttic.m_flow_in) annotation (Line(
        points={{-59.5,-11},{-59.5,-11.6},{-46,-11.6}}, color={0,0,127}));
  connect(freshAirAttic.ports[1], zoneAttic.ports[1]) annotation (Line(points={
          {-30,-18},{7.3,-18},{7.3,-5.37}}, color={0,127,255}));
  connect(zoneAttic.ports[2], ducAttic.port_a) annotation (Line(points={{8.7,-5.37},
          {6,-5.37},{6,-41},{-10,-41}}, color={0,127,255}));
  connect(ducAttic.port_b, pAtmAttic.ports[1]) annotation (Line(points={{-26,-41},
          {-28,-41},{-28,-42},{-48,-42}}, color={0,127,255}));
  connect(weaBus, freshAirAttic.weaBus) annotation (Line(
      points={{-49,100},{-49,96},{-52,96},{-52,-17.84},{-46,-17.84}},
      color={255,204,51},
      thickness=0.5));
  connect(qGain.y, zoneAttic.qGai_flow) annotation (Line(points={{-21.3,33},{-12,
          33},{-12,15},{-7.4,15}}, color={0,0,127}));
  connect(calcTZoneOpeMea.y, TZoneOpeMea)
    annotation (Line(points={{81,20},{81,21},{115,21}}, color={0,0,127}));
  connect(zoneAttic.TAir, calcTZoneOpeMea.u1) annotation (Line(points={{22.7,
          20.6},{32,20.6},{32,26},{58,26}}, color={0,0,127}));
  connect(zoneAttic.TRad, calcTZoneOpeMea.u2) annotation (Line(points={{22.7,
          17.8},{22.7,18},{32,18},{32,14},{58,14}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Polygon(
          points={{-96,-52},{0,88},{96,-52},{82,-52},{0,68},{-82,-52},{-96,
              -52}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          extent={{-36,12},{36,2}},
          lineColor={0,0,0},
          textString="Attic"),
        Text(
          extent={{-36,-18},{36,-28}},
          lineColor={0,0,0},
          textString="(11)")}));
end Attic;
