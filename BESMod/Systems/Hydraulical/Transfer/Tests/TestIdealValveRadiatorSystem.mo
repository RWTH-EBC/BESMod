within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestIdealValveRadiatorSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator
      transfer(redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        radParameters, redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData));
  extends Modelica.Icons.Example;

end TestIdealValveRadiatorSystem;
