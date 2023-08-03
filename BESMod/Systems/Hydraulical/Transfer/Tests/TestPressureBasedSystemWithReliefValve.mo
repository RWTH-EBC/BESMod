within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestPressureBasedSystemWithReliefValve
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
      transfer(
      use_preRelVal=true,
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
        transferDataBaseDefinition,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        parPum,
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        radParameters));
  extends Modelica.Icons.Example;

end TestPressureBasedSystemWithReliefValve;
