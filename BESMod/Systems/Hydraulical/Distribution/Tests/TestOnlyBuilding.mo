within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestOnlyBuilding
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.BuildingOnly
      distribution(redeclare BESMod.Systems.RecordsCollection.Movers.DPVar
        parPum));
  extends Modelica.Icons.Example;

end TestOnlyBuilding;
