within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
model PowerLawSolarUsability "Power law korrelation"
  extends PartialSolarUsability;
  parameter Real IrrSolGainFac = 1;
  parameter Real IrrSolGainExp = 0;

equation
  for i in 1:nOrientations loop
    solarGainFactor[i] = IrrSolGainFac*IOrientation[i]^IrrSolGainExp;
  end for;
end PowerLawSolarUsability;
