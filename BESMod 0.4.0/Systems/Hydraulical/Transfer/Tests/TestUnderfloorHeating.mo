within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestUnderfloorHeating
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.UFHTransferSystem
      transfer(redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData
        UFHParameters, redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        parPum,
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
        parTra));
  extends Modelica.Icons.Example;

end TestUnderfloorHeating;
