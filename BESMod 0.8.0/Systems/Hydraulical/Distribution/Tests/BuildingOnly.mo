within BESMod.Systems.Hydraulical.Distribution.Tests;
model BuildingOnly
  extends BaseClasses.PartialTest(
                      redeclare
      BESMod.Systems.Hydraulical.Distribution.BuildingOnly
      distribution(redeclare BESMod.Systems.RecordsCollection.Movers.DPVar
        parPum));
  extends Modelica.Icons.Example;

annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Distribution/Tests/BuildingOnly.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.BuildingOnly\">BESMod.Systems.Hydraulical.Distribution.BuildingOnly</a>.
</p>
</html>"));
end BuildingOnly;
