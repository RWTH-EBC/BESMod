within BESMod.Systems.Hydraulical.Distribution.Tests;
model CombiStorage
  extends BaseClasses.PartialTest(
                      redeclare
      BESMod.Systems.Hydraulical.Distribution.CombiStorage
      distribution(redeclare
        BESMod.Examples.SolarThermalSystem.CombiStorage
        parSto(
        use_HC1=true,
        dTLoadingHC1=5,
        use_HC2=true,
        dTLoadingHC2=5)), fixTSup(T={distribution.TSup_nominal[1],70 + 273.15}));
  extends Modelica.Icons.Example;
equation
  connect(booleanConstant.y, sigBusDistr.pumGenOn) annotation (Line(points={{-59,
          50},{-40,50},{-40,79},{0,79}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(booleanConstant.y, sigBusDistr.pumGenOnSec) annotation (Line(points={{
          -59,50},{-40,50},{-40,79},{0,79}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Distribution/Tests/CombiStorage.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.CombiStorage\">BESMod.Systems.Hydraulical.Distribution.CombiStorage</a>.
</p>
<p>
The tests show how all mass flow rates always are met even though 
the three way valve is switching. Furthermore, the building supply tempereature 
decreases over time as the storage gets colder due to switching to DHW mode.
At the start, no temperature difference is present, as the setting reflects direct loading.
The second generation supply temperature is set higher to show how the storage
temeperature increases. The slight osciallation occurs due to the DHW mass flow rate.
</p>  
</html>"));
end CombiStorage;
