within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestIdealValveRadiatorSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator
      transfer(redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        parRad, redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        parPum,
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
        parTra));
  extends Modelica.Icons.Example;

  annotation (Documentation(info="<html>
<p>A test model for a radiator heating system with ideal valve control.</p>
<p>The tested system is an <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator\">BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator</a>.</p>
</html>"));
end TestIdealValveRadiatorSystem;
