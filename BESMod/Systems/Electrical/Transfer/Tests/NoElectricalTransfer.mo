within BESMod.Systems.Electrical.Transfer.Tests;
model NoElectricalTransfer
  extends Modelica.Icons.Example;
  BESMod.Systems.Electrical.Transfer.NoElectricalTransfer
    noElectricalTransfer(nParallelDem=1)
    annotation (Placement(transformation(extent={{-44,-32},{48,52}})));

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
