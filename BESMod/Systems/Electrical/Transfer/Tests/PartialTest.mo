within BESMod.Systems.Electrical.Transfer.Tests;
partial model PartialTest
  replaceable
  BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer
    transfer constrainedby BaseClasses.PartialTransfer
    annotation (Placement(transformation(extent={{-44,-32},{48,52}})),
      choicesAllMatching=true);
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureRad[transfer.nParallelDem](
     each T=293.15)
    annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureCon[transfer.nParallelDem](
     each T=293.15)
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
equation
  connect(fixedTemperatureRad.port, transfer.heatPortRad) annotation (Line(
        points={{80,-10},{58,-10},{58,6.64},{48,6.64}}, color={191,0,0}));
  connect(fixedTemperatureCon.port, transfer.heatPortCon) annotation (Line(
        points={{80,30},{58,30},{58,26.8},{48,26.8}}, color={191,0,0}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
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
