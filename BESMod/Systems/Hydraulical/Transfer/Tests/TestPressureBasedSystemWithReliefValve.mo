within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestPressureBasedSystemWithReliefValve
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
      transfer(
      use_preRelVal=true,
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
Test model to validate a pressure-based heating system with a relief valve. 
Tests  <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased\">BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased</a> 
transfer system with a relief valve enabled.
</p>
Key settings:
<ul>
<li>use_preRelVal = true (Relief valve enabled)</li>
</ul>
</p>
</html>"));
end TestPressureBasedSystemWithReliefValve;
