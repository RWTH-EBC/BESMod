within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestCombiStorage
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.CombiStorage
      distribution(redeclare
        BESMod.Examples.SolarThermalSystem.CombiStorage
        parameters(
        use_HC1=true,
        dTLoadingHC1=5,
        use_HC2=true,
        dTLoadingHC2=5)));
  extends Modelica.Icons.Example;

  annotation (Documentation(info="<html>
<p>Test model for a combined storage tank system 
(<a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.CombiStorage\">BESMod.Systems.Hydraulical.Distribution.CombiStorage</a>).</p>
<p>The model extends the partial test model and configures a 
combined storage system with two heating circuits. 
Both heating circuits are activated and use a temperature 
difference of 5K for loading.</p>

</html>"));
end TestCombiStorage;
