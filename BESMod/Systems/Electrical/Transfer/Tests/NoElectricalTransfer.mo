within BESMod.Systems.Electrical.Transfer.Tests;
model NoElectricalTransfer
  extends Modelica.Icons.Example;
  BESMod.Systems.Electrical.Transfer.NoElectricalTransfer
    noElectricalTransfer(nParallelDem=1)
    annotation (Placement(transformation(extent={{-44,-32},{48,52}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[1](T=
        293.15) annotation (Placement(transformation(extent={{88,-18},{68,2}})));
equation
  connect(fixedTemperature.port, noElectricalTransfer.heatPortRad) annotation (
      Line(points={{68,-8},{60,-8},{60,6.64},{48,6.64}}, color={191,0,0}));
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
end NoElectricalTransfer;
