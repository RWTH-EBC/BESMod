within BESMod.Systems.Electrical.Transfer.Tests;
model NoElectricalTransfer
  extends PartialTest(redeclare
      BESMod.Systems.Electrical.Transfer.NoElectricalTransfer transfer(
        nParallelDem=1));
  extends Modelica.Icons.Example;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>Test model for the <a href=\"modelica://BESMod.Systems.Electrical.Transfer.NoElectricalTransfer\">BESMod.Systems.Electrical.Transfer.NoElectricalTransfer</a> component. 
<\p>
</html>"));
end NoElectricalTransfer;
