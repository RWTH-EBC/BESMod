within BESMod.Systems.Electrical.Generation.Tests;
model PVSystemMultiSub
  extends PartialTest(redeclare
      BESMod.Systems.Electrical.Generation.PVSystemMultiSub generation(
      redeclare model CellTemperature =
          AixLib.Electrical.PVSystem.BaseClasses.CellTemperatureOpenRack,
      redeclare AixLib.DataBase.SolarElectric.SchuecoSPV170SME1 pVParameters,
      lat=weaDat.lat,
      lon=weaDat.lon,
      alt=1,
      timZon=weaDat.timZon));
  extends Modelica.Icons.Example;

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
end PVSystemMultiSub;
