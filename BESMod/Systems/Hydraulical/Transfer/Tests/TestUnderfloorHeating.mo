within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestUnderfloorHeating
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.UFHTransferSystem
      transfer(redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData
        UFHParameters,
      redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPum));
  extends Modelica.Icons.Example;
  annotation (experiment(StopTime=36000, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Transfer/Tests/TestUnderfloorHeating.mos"
          "Simulate and plot"));
end TestUnderfloorHeating;
