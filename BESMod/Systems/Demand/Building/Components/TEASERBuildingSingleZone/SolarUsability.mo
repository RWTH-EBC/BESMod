within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
model SolarUsability "Calculate the usable"
  // Calibration parameters
  parameter Real alpha1 =  Modelica.Constants.inf "Sensitivity to ΔT";
  parameter Real alpha2 =  0 "Sensitivity to irradiance";
  parameter Real I_nom =   1000 "Normalization irradiance [W/m2]";



  Modelica.Blocks.Interfaces.RealInput TDryBul
    annotation (Placement(transformation(extent={{-126,40},{-86,80}})));
  Modelica.Blocks.Interfaces.RealInput TZoneSet
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Interfaces.RealInput HDirNor
    annotation (Placement(transformation(extent={{-126,-80},{-86,-40}})));
  Modelica.Blocks.Interfaces.RealOutput solarGainFactor
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
equation
  solarGainFactor = (1 - Modelica.Math.exp(-alpha1*(TZoneSet - TDryBul)))
    * Modelica.Math.exp(-alpha2*(HDirNor / I_nom));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SolarUsability;
