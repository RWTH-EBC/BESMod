within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestOnlyDHW
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.DHWOnly
      distribution(nParallelDem=1, redeclare
        BESMod.Systems.RecordsCollection.Movers.DPVar parPum));
  extends Modelica.Icons.Example;

end TestOnlyDHW;
