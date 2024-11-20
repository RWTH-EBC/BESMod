within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestOnlyBuilding
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.BuildingOnly
      distribution(nParallelDem=1));
  extends Modelica.Icons.Example;

  annotation (Documentation(info="<html>
<p>
Test case for a hydraulic distribution system containing only building distribution 
without any storages. The test is for <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.BuildingOnly\">BuildingOnly</a> 
distribution model with a single parallel demand circuit (nParallelDem=1).
</p>
</html>"));
end TestOnlyBuilding;
