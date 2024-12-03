within BESMod.Examples.DesignOptimization;
record AachenSystem
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    use_elecHeating=false,
    nZones=1,
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/WeatherData/TRY2015_507931060546_Jahr_City_Aachen_Normal.mos"),
    QBui_flow_nominal={10632.414942943078},
    use_ventilation=false,
    THydSup_nominal={328.15},
    TOda_nominal=265.35);

  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>This record extends <a href=\"modelica://BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition\">BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition</a> and defines parameters for a building energy system in Aachen, Germany. The model represents a single-zone building without ventilation and electric heating.</p>
</html>"));
end AachenSystem;
