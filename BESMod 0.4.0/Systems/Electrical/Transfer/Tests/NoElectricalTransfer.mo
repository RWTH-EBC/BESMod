within BESMod.Systems.Electrical.Transfer.Tests;
model NoElectricalTransfer
  extends PartialTest(redeclare
      BESMod.Systems.Electrical.Transfer.NoElectricalTransfer transfer(
        nParallelDem=1));
  extends Modelica.Icons.Example;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=true,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end NoElectricalTransfer;
