within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
partial record SolarThermalBaseDataDefinition
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Efficiency eta_zero=0.75   "Conversion factor/Efficiency at Q = 0";
  parameter Real c1=2                   "Loss coefficient c1";
  parameter Real c2=0.005                 "Loss coefficient c2";
  parameter Modelica.SIunits.Area A=2 "Area of solar thermal collector";

  parameter Modelica.SIunits.Diameter dPipe "Diameter of the pip";
  parameter Modelica.SIunits.Length spacing "Spacing of pipes / distance betwenn two pipes";
  parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure c_p=4184
    "Heat capacity of water";
  parameter Modelica.SIunits.TemperatureDifference dTMax    "Maximal temperature difference";
  parameter Modelica.SIunits.Irradiance GMax "Maximal heat flow rate per area due to radation";

  parameter Real pressureDropCoeff=2500/(A*2.5e-5)^2
    "Pressure drop coefficient, delta_p[Pa] = PD * Q_flow[m^3/s]^2";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=GMax * A / (c_p * dTMax)
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Volume volPip=dPipe^2*Modelica.Constants.pi/4*A/spacing  "Water volume of piping";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SolarThermalBaseDataDefinition;
