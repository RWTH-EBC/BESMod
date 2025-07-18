within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
partial model PartialSolarUsability
  "Reduce the the solar gians to the usable amount for heating"
  parameter Real I_nom =   1000 "Normalization irradiance [W/m2]";
  parameter Integer nOrientations = 1;

  Modelica.Blocks.Interfaces.RealInput TDryBul
    annotation (Placement(transformation(extent={{-126,40},{-86,80}})));
  Modelica.Blocks.Interfaces.RealInput TZoneSet
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Interfaces.RealInput IOrientations[nOrientations]
    annotation (Placement(transformation(extent={{-126,-80},{-86,-40}})));
  Modelica.Blocks.Interfaces.RealOutput solarGainFactor[nOrientations]
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSolarUsability;
