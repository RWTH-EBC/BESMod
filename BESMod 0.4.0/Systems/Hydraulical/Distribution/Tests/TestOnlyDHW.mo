within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestOnlyDHW
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.DHWOnly
      distribution(nParallelDem=1));
  extends Modelica.Icons.Example;

end TestOnlyDHW;
