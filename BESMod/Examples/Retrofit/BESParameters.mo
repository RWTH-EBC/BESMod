within BESMod.Examples.Retrofit;
record BESParameters
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/WeatherData/TRY2015_522361130393_Jahr_City_Potsdam.mos"),
    use_elecHeating=false,
    final TAmbVen=min(TSetZone_nominal),
    final TAmbHyd=min(TSetZone_nominal),
    final TDHWWaterCold=283.15,
    final TSetDHW=328.15,
    final TVenSup_nominal=TSetZone_nominal,
    final TSetZone_nominal=fill(293.15, nZones),
    final nZones=1,
    final use_ventilation=false);

  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>
Record for Building Energy System (BES) parameters used in retrofit examples.
</p>
</html>"));
end BESParameters;
