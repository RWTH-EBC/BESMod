within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestPressureBasedSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
      transfer(
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
        parTra,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        parPum,
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        parRad));
  extends Modelica.Icons.Example;

  annotation (Documentation(info="<html>
<p>
This model tests the <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased\">BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased</a> 
transfer model with standard steel radiator parameters.
</p>
</html>"));
end TestPressureBasedSystem;
