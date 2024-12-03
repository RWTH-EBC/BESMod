within BESMod.Examples.ModelicaConferencePaper;
record BESModSystemParas "Case studies system parameters"
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    nZones=1,
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/WeatherData/TRY2015_507931060546_Jahr_City_Aachen_Normal.mos"),
    QBui_flow_nominal={10632.414942943078},
    use_ventilation=true,
    THydSup_nominal={328.15},
    TOda_nominal=265.35);

  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>BESModSystemParas is a record containing system parameters for building energy system case studies.</p>

</html>"));
end BESModSystemParas;
