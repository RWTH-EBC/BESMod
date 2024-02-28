within BESMod.Systems.Electrical.Generation.Tests;
partial model PartialTest
  replaceable
  BESMod.Systems.Electrical.Generation.BaseClasses.PartialGeneration
    generation constrainedby BaseClasses.PartialGeneration(ARoo=50)
              annotation (Placement(transformation(extent={{-42,-36},{42,44}})),
      choicesAllMatching=true);
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://BESMod/Resources/TRY2015_522361130393_Jahr_City_Potsdam.mos"))
    annotation (Placement(transformation(extent={{-100,58},{-62,100}})));
  BESMod.Utilities.Electrical.ElecConToReal elecConToReal
    annotation (Placement(transformation(extent={{56,54},{92,98}})));
equation
  connect(weaDat.weaBus, generation.weaBus) annotation (Line(
      points={{-62,79},{-58,79},{-58,34.4},{-42,34.4}},
      color={255,204,51},
      thickness=0.5));
  connect(generation.internalElectricalPin, elecConToReal.internalElectricalPin)
    annotation (Line(
      points={{21,43.2},{21,76.44},{56.36,76.44}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
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
