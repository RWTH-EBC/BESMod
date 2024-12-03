within BESMod.Examples.BAUSimStudy;
record BESParameters
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    use_elecHeating=false,
    final filNamWea=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/WeatherData/TRY2015_522361130393_Jahr_City_Potsdam.mos"),
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
<p>This record contains basic parameters for building energy system simulations in the BauSIM case study.</p>
</html>"));
end BESParameters;
