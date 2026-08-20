within BESMod.Systems.Demand.Building.Components.SpawnV62OFD;
model GroundFloor "Spawn ground floor (EG) of the Viebrockhaus V62"
  replaceable package Medium = IBPSA.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Volume VZones[5] = {91.48,28.47,15.1,13.84,16.38} "Volume of the zones";
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-70,78},{-28,122}}),
        iconTransformation(extent={{-68,92},{-48,112}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.ThermalZone zoneWohnenKochen1(
    zoneName="EG_WohnenKochen",
    redeclare package Medium = Medium,
    nPorts=4) "Kochen/Essen/Wohnen"
    annotation (Placement(transformation(extent={{-96,76},{-68,104}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    m_flow=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-120,86},{-110,96}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc1(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-98,60},{-110,72}})));
  Buildings.Fluid.Sources.Boundary_pT pAtm1(
    redeclare package Medium = Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-134,61},{-124,71}})));
  Modelica.Blocks.Math.Product calcMassFlow1
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{-136,96},{-126,106}})));
  Modelica.Blocks.Sources.RealExpression airDensity1(y=rho) "Air density"
    annotation (Placement(transformation(extent={{-154,94},{-146,102}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.ThermalZone zoneDiele2(
    zoneName="EG_Diele",
    redeclare package Medium = Medium,
    nPorts=4) "Diele mit Treppe"
    annotation (Placement(transformation(extent={{4,76},{32,104}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    m_flow=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-20,86},{-10,96}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc2(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{2,60},{-10,72}})));
  Buildings.Fluid.Sources.Boundary_pT pAtm2(
    redeclare package Medium = Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-34,61},{-24,71}})));
  Modelica.Blocks.Math.Product calcMassFlow2
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{-36,96},{-26,106}})));
  Modelica.Blocks.Sources.RealExpression airDensity2(y=rho) "Air density"
    annotation (Placement(transformation(extent={{-54,94},{-46,102}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.ThermalZone zoneHomeOffice3(
    zoneName="EG_HomeOffice",
    redeclare package Medium = Medium,
    nPorts=4) "Home-Office"
    annotation (Placement(transformation(extent={{104,76},{132,104}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir3(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    m_flow=1) "Boundary condition"
    annotation (Placement(transformation(extent={{80,86},{90,96}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc3(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{102,60},{90,72}})));
  Buildings.Fluid.Sources.Boundary_pT pAtm3(
    redeclare package Medium = Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{66,61},{76,71}})));
  Modelica.Blocks.Math.Product calcMassFlow3
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{64,96},{74,106}})));
  Modelica.Blocks.Sources.RealExpression airDensity3(y=rho) "Air density"
    annotation (Placement(transformation(extent={{46,94},{54,102}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.ThermalZone zoneDuscheWC4(
    zoneName="EG_DuscheWC",
    redeclare package Medium = Medium,
    nPorts=4) "Dusche/WC"
    annotation (Placement(transformation(extent={{-96,-4},{-68,24}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir4(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    m_flow=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-120,6},{-110,16}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc4(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-98,-20},{-110,-8}})));
  Buildings.Fluid.Sources.Boundary_pT pAtm4(
    redeclare package Medium = Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-134,-19},{-124,-9}})));
  Modelica.Blocks.Math.Product calcMassFlow4
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{-136,16},{-126,26}})));
  Modelica.Blocks.Sources.RealExpression airDensity4(y=rho) "Air density"
    annotation (Placement(transformation(extent={{-154,14},{-146,22}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.ThermalZone zoneHTR5(
    zoneName="EG_HTR",
    redeclare package Medium = Medium,
    nPorts=4) "Hausanschlussraum"
    annotation (Placement(transformation(extent={{4,-4},{32,24}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir5(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    m_flow=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-20,6},{-10,16}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc5(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=1)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{2,-20},{-10,-8}})));
  Buildings.Fluid.Sources.Boundary_pT pAtm5(
    redeclare package Medium = Medium, nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{-34,-19},{-24,-9}})));
  Modelica.Blocks.Math.Product calcMassFlow5
    "calculate mass flow from volume flow and density"
    annotation (Placement(transformation(extent={{-36,16},{-26,26}})));
  Modelica.Blocks.Sources.RealExpression airDensity5(y=rho) "Air density"
    annotation (Placement(transformation(extent={{-54,14},{-46,22}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon[5]
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{-152,54},{-132,74}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad[5]
    "Heat port to radiative temperature and radiative energy balance"
    annotation (Placement(transformation(extent={{-152,-60},{-132,-40}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneMea[5](each final unit="K",
      each final displayUnit="degC") "Measured room air temperature"
    annotation (Placement(transformation(extent={{170,60},{190,80}}),
        iconTransformation(extent={{90,62},{120,92}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneOpeMea[5](each final unit="K",
      each final displayUnit="degC") "Measured room operative temperature"
    annotation (Placement(transformation(extent={{170,-20},{190,0}}),
        iconTransformation(extent={{92,-38},{122,-8}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneRadMea[5](each final unit="K",
      each final displayUnit="degC") "Measured room radiative temperature"
    annotation (Placement(transformation(extent={{170,-60},{190,-40}}),
        iconTransformation(extent={{92,-74},{122,-44}})));
  Modelica.Fluid.Interfaces.FluidPort_a portVent_in[5](redeclare final package
      Medium = Medium) "Inlet for the demand of ventilation"
    annotation (Placement(transformation(extent={{170,20},{190,40}}),
        iconTransformation(extent={{90,34},{110,54}})));
  Modelica.Fluid.Interfaces.FluidPort_b portVent_out[5](redeclare final package
      Medium = Medium) "Outlet of the demand of ventilation"
    annotation (Placement(transformation(extent={{170,-100},{190,-80}}),
        iconTransformation(extent={{90,-2},{110,18}})));
  Modelica.Blocks.Interfaces.RealInput AirExchangePort[5]
    "1: Kochen/Essen/Wohnen, 2: Diele, 3: Home-Office, 4: Dusche/WC, 5: HTR"
    annotation (Placement(transformation(extent={{-158,78},{-128,108}})));
  Modelica.Blocks.Interfaces.RealInput IntGainsRad[5]
    "1: Kochen/Essen/Wohnen, 2: Diele, 3: Home-Office, 4: Dusche/WC, 5: HTR"
    annotation (Placement(transformation(extent={{-160,-40},{-130,-10}})));
  Modelica.Blocks.Interfaces.RealInput IntGainsConv[5]
    "1: Kochen/Essen/Wohnen, 2: Diele, 3: Home-Office, 4: Dusche/WC, 5: HTR"
    annotation (Placement(transformation(extent={{-162,4},{-132,34}})));
  Modelica.Blocks.Math.Gain volumeFlow[5](k=VZones ./ 3600)
    "Convert air exchange into volume flow for each zone"
    annotation (Placement(transformation(extent={{-122,88},{-114,96}})));
  Modelica.Blocks.Sources.Constant qGainFlowLatent(k=0) "No latent gains"
    annotation (Placement(transformation(extent={{-130,2},{-120,12}})));
  Modelica.Blocks.Math.Add calcTZoneOpeMea[5](each k1=0.5, each k2=0.5)
    "Calculate room operative temperature"
    annotation (Placement(transformation(extent={{140,-26},{154,-12}})));
protected
  Modelica.Blocks.Interfaces.RealOutput TDryBul(final unit="K", displayUnit="degC")
    "Needed to calculate density";
  Modelica.Blocks.Interfaces.RealOutput pAtm(final unit="Pa")
    "Needed to calculate density";
  Real X[Medium.nX] = ones(Medium.nX);
  Modelica.Units.SI.Density rho
    "Density of fresh air. Needed to calculate mass flow from ACH";
equation
  connect(weaBus.pAtm, pAtm);
  connect(weaBus.TDryBul, TDryBul);
  rho = Medium.density(Medium.setState_pTX(pAtm, TDryBul, X));
  connect(AirExchangePort, volumeFlow.u);
  connect(calcTZoneOpeMea.y, TZoneOpeMea);
  // ---- Kochen/Essen/Wohnen (EG_WohnenKochen) ----
  connect(heatPortCon[1], zoneWohnenKochen1.heaPorAir);
  connect(heatPortRad[1], zoneWohnenKochen1.heaPorRad);
  connect(zoneWohnenKochen1.TAir, TZoneMea[1]);
  connect(zoneWohnenKochen1.TRad, TZoneRadMea[1]);
  connect(zoneWohnenKochen1.TAir, calcTZoneOpeMea[1].u1);
  connect(zoneWohnenKochen1.TRad, calcTZoneOpeMea[1].u2);
  connect(IntGainsRad[1], zoneWohnenKochen1.qGai_flow[1]);
  connect(IntGainsConv[1], zoneWohnenKochen1.qGai_flow[2]);
  connect(qGainFlowLatent.y, zoneWohnenKochen1.qGai_flow[3]);
  connect(volumeFlow[1].y, calcMassFlow1.u1);
  connect(airDensity1.y, calcMassFlow1.u2);
  connect(calcMassFlow1.y, freshAir1.m_flow_in);
  connect(weaBus, freshAir1.weaBus);
  connect(freshAir1.ports[1], zoneWohnenKochen1.ports[1]);
  connect(zoneWohnenKochen1.ports[2], duc1.port_a);
  connect(duc1.port_b, pAtm1.ports[1]);
  connect(portVent_in[1], zoneWohnenKochen1.ports[3]);
  connect(portVent_out[1], zoneWohnenKochen1.ports[4]);
  // ---- Diele mit Treppe (EG_Diele) ----
  connect(heatPortCon[2], zoneDiele2.heaPorAir);
  connect(heatPortRad[2], zoneDiele2.heaPorRad);
  connect(zoneDiele2.TAir, TZoneMea[2]);
  connect(zoneDiele2.TRad, TZoneRadMea[2]);
  connect(zoneDiele2.TAir, calcTZoneOpeMea[2].u1);
  connect(zoneDiele2.TRad, calcTZoneOpeMea[2].u2);
  connect(IntGainsRad[2], zoneDiele2.qGai_flow[1]);
  connect(IntGainsConv[2], zoneDiele2.qGai_flow[2]);
  connect(qGainFlowLatent.y, zoneDiele2.qGai_flow[3]);
  connect(volumeFlow[2].y, calcMassFlow2.u1);
  connect(airDensity2.y, calcMassFlow2.u2);
  connect(calcMassFlow2.y, freshAir2.m_flow_in);
  connect(weaBus, freshAir2.weaBus);
  connect(freshAir2.ports[1], zoneDiele2.ports[1]);
  connect(zoneDiele2.ports[2], duc2.port_a);
  connect(duc2.port_b, pAtm2.ports[1]);
  connect(portVent_in[2], zoneDiele2.ports[3]);
  connect(portVent_out[2], zoneDiele2.ports[4]);
  // ---- Home-Office (EG_HomeOffice) ----
  connect(heatPortCon[3], zoneHomeOffice3.heaPorAir);
  connect(heatPortRad[3], zoneHomeOffice3.heaPorRad);
  connect(zoneHomeOffice3.TAir, TZoneMea[3]);
  connect(zoneHomeOffice3.TRad, TZoneRadMea[3]);
  connect(zoneHomeOffice3.TAir, calcTZoneOpeMea[3].u1);
  connect(zoneHomeOffice3.TRad, calcTZoneOpeMea[3].u2);
  connect(IntGainsRad[3], zoneHomeOffice3.qGai_flow[1]);
  connect(IntGainsConv[3], zoneHomeOffice3.qGai_flow[2]);
  connect(qGainFlowLatent.y, zoneHomeOffice3.qGai_flow[3]);
  connect(volumeFlow[3].y, calcMassFlow3.u1);
  connect(airDensity3.y, calcMassFlow3.u2);
  connect(calcMassFlow3.y, freshAir3.m_flow_in);
  connect(weaBus, freshAir3.weaBus);
  connect(freshAir3.ports[1], zoneHomeOffice3.ports[1]);
  connect(zoneHomeOffice3.ports[2], duc3.port_a);
  connect(duc3.port_b, pAtm3.ports[1]);
  connect(portVent_in[3], zoneHomeOffice3.ports[3]);
  connect(portVent_out[3], zoneHomeOffice3.ports[4]);
  // ---- Dusche/WC (EG_DuscheWC) ----
  connect(heatPortCon[4], zoneDuscheWC4.heaPorAir);
  connect(heatPortRad[4], zoneDuscheWC4.heaPorRad);
  connect(zoneDuscheWC4.TAir, TZoneMea[4]);
  connect(zoneDuscheWC4.TRad, TZoneRadMea[4]);
  connect(zoneDuscheWC4.TAir, calcTZoneOpeMea[4].u1);
  connect(zoneDuscheWC4.TRad, calcTZoneOpeMea[4].u2);
  connect(IntGainsRad[4], zoneDuscheWC4.qGai_flow[1]);
  connect(IntGainsConv[4], zoneDuscheWC4.qGai_flow[2]);
  connect(qGainFlowLatent.y, zoneDuscheWC4.qGai_flow[3]);
  connect(volumeFlow[4].y, calcMassFlow4.u1);
  connect(airDensity4.y, calcMassFlow4.u2);
  connect(calcMassFlow4.y, freshAir4.m_flow_in);
  connect(weaBus, freshAir4.weaBus);
  connect(freshAir4.ports[1], zoneDuscheWC4.ports[1]);
  connect(zoneDuscheWC4.ports[2], duc4.port_a);
  connect(duc4.port_b, pAtm4.ports[1]);
  connect(portVent_in[4], zoneDuscheWC4.ports[3]);
  connect(portVent_out[4], zoneDuscheWC4.ports[4]);
  // ---- Hausanschlussraum (EG_HTR) ----
  connect(heatPortCon[5], zoneHTR5.heaPorAir);
  connect(heatPortRad[5], zoneHTR5.heaPorRad);
  connect(zoneHTR5.TAir, TZoneMea[5]);
  connect(zoneHTR5.TRad, TZoneRadMea[5]);
  connect(zoneHTR5.TAir, calcTZoneOpeMea[5].u1);
  connect(zoneHTR5.TRad, calcTZoneOpeMea[5].u2);
  connect(IntGainsRad[5], zoneHTR5.qGai_flow[1]);
  connect(IntGainsConv[5], zoneHTR5.qGai_flow[2]);
  connect(qGainFlowLatent.y, zoneHTR5.qGai_flow[3]);
  connect(volumeFlow[5].y, calcMassFlow5.u1);
  connect(airDensity5.y, calcMassFlow5.u2);
  connect(calcMassFlow5.y, freshAir5.m_flow_in);
  connect(weaBus, freshAir5.weaBus);
  connect(freshAir5.ports[1], zoneHTR5.ports[1]);
  connect(zoneHTR5.ports[2], duc5.port_a);
  connect(duc5.port_b, pAtm5.ports[1]);
  connect(portVent_in[5], zoneHTR5.ports[3]);
  connect(portVent_out[5], zoneHTR5.ports[4]);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(extent={{-90,90},{90,-90}}, lineColor={0,0,0},
          fillColor={245,245,245}, fillPattern=FillPattern.Solid),
        Text(extent={{-84,70},{84,52}}, lineColor={0,0,0}, textString="1: Kochen/Essen/Wohnen"),
        Text(extent={{-84,44},{84,26}}, lineColor={0,0,0}, textString="2: Diele mit Treppe"),
        Text(extent={{-84,18},{84,0}}, lineColor={0,0,0}, textString="3: Home-Office"),
        Text(extent={{-84,-8},{84,-26}}, lineColor={0,0,0}, textString="4: Dusche/WC"),
        Text(extent={{-84,-34},{84,-52}}, lineColor={0,0,0}, textString="5: Hausanschlussraum")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-160,-140},{200,140}})));
end GroundFloor;
