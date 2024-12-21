within BESMod.Systems.Hydraulical.Distribution.Tests;
model SimpleTwoStorageParallel
  extends BaseClasses.PartialTest(
                      redeclare
      BESMod.Systems.Hydraulical.Distribution.SimpleTwoStorageParallel
      distribution(                redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
        parStoDHW(dTLoadingHC1=5),
      redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayVal,
      redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPumTra,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
        parStoBuf(dTLoadingHC1=0)));
  extends Modelica.Icons.Example;

equation
  connect(pulse.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-59,80},{4.5,
          80},{4.5,79},{0,79}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(booleanConstant.y, sigBusDistr.pumGenOn) annotation (Line(points={{
          -59,50},{0,50},{0,79}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Distribution/Tests/SimpleTwoStorageParallel.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.SimpleTwoStorageParallel\">BESMod.Systems.Hydraulical.Distribution.SimpleTwoStorageParallel</a>.
</p>
<p>
The tests show how all mass flow rates always are met even though 
the three way valve is switching. Furthermore, the building supply tempereature 
decreases over time as the storage gets colder due to switching to DHW mode.
At the start, no temperature difference is present, as the setting reflect direct loading.

</p>  
</html>"));
end SimpleTwoStorageParallel;
