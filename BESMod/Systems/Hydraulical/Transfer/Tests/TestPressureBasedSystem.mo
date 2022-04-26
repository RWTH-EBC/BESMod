within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestPressureBasedSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
      transfer(
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
        transferDataBaseDefinition,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData,
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        radParameters));

end TestPressureBasedSystem;
