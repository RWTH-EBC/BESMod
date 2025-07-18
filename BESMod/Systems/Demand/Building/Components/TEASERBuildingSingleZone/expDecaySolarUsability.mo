within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
model expDecaySolarUsability "Calculate the usable"
  extends BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone.PartialSolarUsability;
  // Calibration parameters
  parameter Real alpha1 =  Modelica.Constants.inf "Sensitivity to ΔT";
  parameter Real alpha2 =  0 "Sensitivity to irradiance";


equation
  for i in 1:nOrientations loop
    solarGainFactor[i] = (1 - Modelica.Math.exp(-alpha1*(TZoneSet - TDryBul)))
      * Modelica.Math.exp(-alpha2*(IOrientations[i] / I_nom));
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end expDecaySolarUsability;
