within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestIdealValveRadiatorSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator transfer(redeclare BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData parRad, use_oldRad_design = {false}, TTra_design = {333.15}, Q_flow_design = transfer.Q_flow_nominal, redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPum), pumDis(each externalCtrlTyp = BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.speed, each y = 1));
  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=12000, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Transfer/Tests/TestIdealValveRadiatorSystem.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator\">BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator</a>.
</p>
</html>"));
end TestIdealValveRadiatorSystem;
