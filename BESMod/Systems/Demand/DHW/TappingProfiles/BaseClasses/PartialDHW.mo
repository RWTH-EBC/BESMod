within BESMod.Systems.Demand.DHW.TappingProfiles.BaseClasses;
partial model PartialDHW
  extends BESMod.Utilities.Icons.DHWIcon;
  parameter Modelica.Units.SI.Temperature TCold=283.15 "Cold water temperature";
  parameter Modelica.Units.SI.Density dWater=1000 "Density of water";
  parameter Modelica.Units.SI.SpecificHeatCapacityAtConstantPressure c_p_water=
      4184 "Heat capacity of water";
  parameter Real TSetDHW "Set temperature of DHW";

  Modelica.Blocks.Interfaces.RealInput m_flow_in
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_out
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TSet "Set temperature of DHW"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput TIs "Actual DHW temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

equation
  assert(TSet>=TCold, "Set temperature has to be higher than cold water temperature", AssertionLevel.error);
  // assert(TIs>TCold, "Actual temperature has to be higher than cold water temperature", AssertionLevel.error);

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>Partial model that serves as a base class for domestic hot water (DHW) 
tapping profile models. 
Contains basic parameters and interfaces for DHW systems.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>TCold</code> (K): Cold water temperature, default 283.15 K</li>
  <li><code>dWater</code> (kg/m^3): Density of water, default 1000 kg/m^3</li>
  <li><code>c_p_water</code> (J/(kg * K)): Specific heat capacity of water, default 4184 J/(kg * K)</li>
  <li><code>TSetDHW</code> (K): Set temperature of DHW</li>
</ul>
</html>"));
end PartialDHW;
