within BESMod.Systems.RecordsCollection;
record ExampleSystemParameters
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    filNamWea=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/WeatherData/TRY2015_522361130393_Jahr_City_Potsdam.mos"),
    THydSup_nominal={328.15},
    QBui_flow_nominal={10632.414942943078},
    use_ventilation=true,
    TOda_nominal=261.15);

end ExampleSystemParameters;
