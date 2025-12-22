within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestOnlyBuilding
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.BuildingOnly
      distribution(nParallelDem=1));
  extends Modelica.Icons.Example;

end TestOnlyBuilding;
