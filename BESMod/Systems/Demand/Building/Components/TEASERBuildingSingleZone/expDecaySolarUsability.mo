within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
model expDecaySolarUsability "Calculate the usable"
  extends BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone.PartialSolarUsability;
  // Calibration parameters
  parameter Real alpha1 =  0 "Sensitivity to ΔT";
  parameter Real alpha11 = 1;
  parameter Real alpha2 =  0 "Sensitivity to irradiance";
  parameter Real alpha21 = 1;


equation
  for i in 1:nOrientations loop
    solarGainFactor[i] = (Modelica.Math.exp(-alpha1*(TDryBul/TZoneSet)^alpha11))
      * Modelica.Math.exp(-alpha2*(IOrientations[i] / I_nom)^alpha21);
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end expDecaySolarUsability;
