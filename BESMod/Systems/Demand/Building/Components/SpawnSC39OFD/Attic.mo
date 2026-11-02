within BESMod.Systems.Demand.Building.Components.SpawnSC39OFD;
model Attic "Spawn Spitzboden (unbeheizt) of the Smart City Haus 39"
  replaceable package Medium = IBPSA.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Volume VZone = 60.38 "Volume of the zone";
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-70,78},{-28,122}}),
        iconTransformation(extent={{-68,92},{-48,112}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.ThermalZone zoneAttic(
    zoneName="DA_Spitzboden",
    redeclare package Medium = Medium,
    nPorts=2) "Unbeheizter Spitzboden ueber der Kehlbalkenlage"
    annotation (Placement(transformation(extent={{-6,-6},{22,22}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneMea(final unit="K", final
      displayUnit="degC") "Measured room air temperature" annotation (Placement(
        transformation(extent={{96,66},{134,104}}), iconTransformation(extent={{
            90,50},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneOpeMea(final unit="K", final
      displayUnit="degC") "Measured room operative temperature" annotation (
      Placement(transformation(extent={{96,2},{134,40}}), iconTransformation(
          extent={{90,-6},{120,24}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneRadMea(final unit="K", final
      displayUnit="degC") "Measured room radiative temperature" annotation (
      Placement(transformation(extent={{94,-100},{132,-62}}), iconTransformation(
          extent={{90,-64},{120,-34}})));
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
  Modelica.Blocks.Sources.RealExpression airDensity(y=rho) "Air density"
    annotation (Placement(transformation(extent={{-98,-22},{-80,-6}})));
  Modelica.Blocks.Sources.Constant qGain[3](k={0,0,0}) "No internal gains"
    annotation (Placement(transformation(extent={{-36,26},{-22,40}})));
  Modelica.Blocks.Math.Add calcTZoneOpeMea(k1=0.5, k2=0.5)
    "Calculate room operative temperature"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
protected
  Modelica.Blocks.Interfaces.RealOutput TDryBul(final unit="K", displayUnit=
        "degC") "Needed to calculate density";
  Modelica.Blocks.Interfaces.RealOutput pAtm(final unit="Pa")
    "Needed to calculate density";
  Real X[Medium.nX] = ones(Medium.nX);
  Modelica.Units.SI.Density rho
    "Density of fresh air. Needed to calculate mass flow from ACH";
equation
  connect(weaBus.pAtm, pAtm);
  connect(weaBus.TDryBul, TDryBul);
  rho = Medium.density(Medium.setState_pTX(pAtm, TDryBul, X));
  connect(zoneAttic.TAir, TZoneMea);
  connect(zoneAttic.TRad, TZoneRadMea);
  connect(AirExchangePort, volumeFlow.u);
  connect(airDensity.y, calcMassFlow_attic.u2);
  connect(volumeFlow.y, calcMassFlow_attic.u1);
  connect(calcMassFlow_attic.y, freshAirAttic.m_flow_in);
  connect(freshAirAttic.ports[1], zoneAttic.ports[1]);
  connect(zoneAttic.ports[2], ducAttic.port_a);
  connect(ducAttic.port_b, pAtmAttic.ports[1]);
  connect(weaBus, freshAirAttic.weaBus);
  connect(qGain.y, zoneAttic.qGai_flow);
  connect(calcTZoneOpeMea.y, TZoneOpeMea);
  connect(zoneAttic.TAir, calcTZoneOpeMea.u1);
  connect(zoneAttic.TRad, calcTZoneOpeMea.u2);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Polygon(
          points={{-96,-52},{0,88},{96,-52},{82,-52},{0,68},{-82,-52},{-96,-52}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(extent={{-46,12},{46,2}}, lineColor={0,0,0}, textString="Spitzboden"),
        Text(extent={{-36,-18},{36,-28}}, lineColor={0,0,0}, textString="(12)")}),
    Documentation(info="<html><p>
  Unbeheizter Spitzboden ueber der Kehlbalkenlage des Smart City Hauses 39.
  Zonenname <code>DA_Spitzboden</code> im IDF, Volumen 60,38 m&sup3;.
</p></html>"));
end Attic;
