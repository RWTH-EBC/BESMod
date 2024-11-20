within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestOnlyDHW
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.DHWOnly
      distribution(nParallelDem=1));
  extends Modelica.Icons.Example;

  annotation (Documentation(info="<html>
<p>Test model for a domestic hot water only hydraulic distribution system. 
The model tests <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.DHWOnly\">DHWOnly</a> as the distribution system.</p>
</html>"));
end TestOnlyDHW;
