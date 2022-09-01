within BESMod.Examples.UseCaseHOM;
record HOMSystem
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    use_elecHeating=false,
    nZones=10,
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/WeatherData/TRY2015_507931060546_Jahr_City_Aachen_Normal.mos"),
    use_ventilation=false,
    QBui_flow_nominal={1124.867,569.6307,53.59064,679.86365,809.8547,786.87427,552.7661,0,666.1303,635.3303},
    THydSup_nominal=fill(328.15,nZones),
    TOda_nominal=265.35);

end HOMSystem;
