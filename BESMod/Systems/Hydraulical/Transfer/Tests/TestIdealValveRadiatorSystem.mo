within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestIdealValveRadiatorSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator
      transfer(redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        parRad,
      redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPum));
  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=12000, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Transfer/Tests/TestIdealValveRadiatorSystem.mos"
          "Simulate and plot"));
end TestIdealValveRadiatorSystem;
