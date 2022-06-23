within BESMod.Examples.UseCaseHOM;
record HOMSystem
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    use_elecHeating=false,
    nZones=11,
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/WeatherData/TRY2015_507931060546_Jahr_City_Aachen_Normal.mos"),
    use_ventilation=false,
    THydSup_nominal={328.15},
    TOda_nominal=265.35);

end HOMSystem;
