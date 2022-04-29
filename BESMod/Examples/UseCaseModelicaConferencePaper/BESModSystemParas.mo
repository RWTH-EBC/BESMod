within BESMod.Examples.UseCaseModelicaConferencePaper;
record BESModSystemParas "Case studies system parameters"
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    nZones=1,
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/WeatherData/TRY2015_507931060546_Jahr_City_Aachen_Normal.mos"),
    QBui_flow_nominal={10632.414942943078},
    use_ventilation=true,
    THydSup_nominal={328.15},
    TOda_nominal=265.35);

end BESModSystemParas;
