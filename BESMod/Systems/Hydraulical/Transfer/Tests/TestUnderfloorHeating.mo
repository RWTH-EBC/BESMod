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

  annotation (Documentation(info="<html>
<p>
Test model for underfloor heating system <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.UFHTransferSystem\">BESMod.Systems.Hydraulical.Transfer.UFHTransferSystem</a> 
model with default parameters for:
</p>
<ul>
  <li>Underfloor heating (<a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData\">BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData</a>)</li>
  <li>Pump (<a href=\"modelica://BESMod.Systems.RecordsCollection.Movers.DefaultMover\">BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultMover</a>)</li>
  <li>Pressure loss (<a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData\">BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData</a>)</li>
</ul>
</html>"));
end TestUnderfloorHeating;
