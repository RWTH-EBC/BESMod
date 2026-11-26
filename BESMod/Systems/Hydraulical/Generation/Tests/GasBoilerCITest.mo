within BESMod.Systems.Hydraulical.Generation.Tests;
model GasBoilerCITest
  extends GasBoiler(generation(dTTra_nominal={15}));
  annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Generation/Tests/GasBoilerCITest.mos"
          "Simulate and plot"));
end GasBoilerCITest;
