within BESMod.Systems.Electrical.Transfer.Tests;
partial model PartialTest
  extends Modelica.Icons.Example;
  replaceable
  BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer
    transfer constrainedby BaseClasses.PartialTransfer(nParallelDem=1)
    annotation (Placement(transformation(extent={{-44,-32},{48,52}})),
      choicesAllMatching=true);
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[1](each T=
        293.15) annotation (Placement(transformation(extent={{88,-18},{68,2}})));
equation
  connect(fixedTemperature.port, transfer.heatPortRad) annotation (
      Line(points={{68,-8},{60,-8},{60,6.64},{48,6.64}}, color={191,0,0}));
  connect(fixedTemperature.port, transfer.heatPortCon) annotation (Line(points=
          {{68,-8},{60,-8},{60,26.8},{48,26.8}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
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
end PartialTest;
