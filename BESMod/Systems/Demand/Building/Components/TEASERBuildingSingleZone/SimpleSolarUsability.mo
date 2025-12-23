within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
model SimpleSolarUsability "single constant reduction factor"
  extends PartialSolarUsability;
  parameter Real constSolGainFac = 1;

equation
  for i in 1:nOrientations loop
    solarGainFactor[i] = constSolGainFac;
  end for;
end SimpleSolarUsability;
