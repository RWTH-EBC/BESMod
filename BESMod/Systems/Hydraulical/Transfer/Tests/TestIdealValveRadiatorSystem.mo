within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestIdealValveRadiatorSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator
      transfer(redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        parRad,
      redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPum,
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
        parTra));
  extends Modelica.Icons.Example;

end TestIdealValveRadiatorSystem;
