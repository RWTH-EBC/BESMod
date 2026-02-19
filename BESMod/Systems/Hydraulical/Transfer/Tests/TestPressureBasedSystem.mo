within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestPressureBasedSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(redeclare
      BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
      transfer(redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        parRad), pumDis(each ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar));
  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=12000, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Transfer/Tests/TestPressureBasedSystem.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBasedOpenModelica\">BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased</a>.
</p>
</html>"));
end TestPressureBasedSystem;
