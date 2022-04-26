within BESMod.Systems.Electrical.Generation.Tests;
model PVSystemMultiSub
  extends Modelica.Icons.Example;
  BESMod.Systems.Electrical.Generation.PVSystemMultiSub
    pVSystemMultiSub(
    redeclare model CellTemperature =
        AixLib.Electrical.PVSystem.BaseClasses.CellTemperatureOpenRack,
    redeclare AixLib.DataBase.SolarElectric.SchuecoSPV170SME1 pVParameters,
    lat=weaDat.lat,
    lon=weaDat.lon,
    alt=1,
    timZon=weaDat.timZon,
    ARoof=50) annotation (Placement(transformation(extent={{-42,-36},{42,44}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://BESMod/Resources/TRY2015_522361130393_Jahr_City_Potsdam.mos"))
    annotation (Placement(transformation(extent={{-100,58},{-62,100}})));
  Utilities.Electrical.ElecConToReal elecConToReal
    annotation (Placement(transformation(extent={{56,54},{92,98}})));
equation
  connect(weaDat.weaBus, pVSystemMultiSub.weaBus) annotation (Line(
      points={{-62,79},{-58,79},{-58,34.4},{-42,34.4}},
      color={255,204,51},
      thickness=0.5));
  connect(pVSystemMultiSub.internalElectricalPin, elecConToReal.internalElectricalPin)
    annotation (Line(
      points={{21,43.2},{21,76.44},{56.36,76.44}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
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
end PVSystemMultiSub;
