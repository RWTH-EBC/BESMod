within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestPressureBasedSystemWithReliefValve
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(redeclare
      BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
      transfer(use_preRelVal=true, redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        parRad));
  extends Modelica.Icons.Example;
  annotation (experiment(StopTime=12000, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Transfer/Tests/TestPressureBasedSystemWithReliefValve.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBasedOpenModelica\">BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased</a>.
  with pressure relief valve.
</p>
</html>"));
end TestPressureBasedSystemWithReliefValve;
