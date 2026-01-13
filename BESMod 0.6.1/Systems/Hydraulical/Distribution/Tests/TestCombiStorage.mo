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

end TestCombiStorage;
