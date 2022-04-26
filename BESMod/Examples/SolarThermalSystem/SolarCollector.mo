within BESMod.Examples.SolarThermalSystem;
record SolarCollector "For BA"
  extends
    Systems.Hydraulical.Generation.RecordsCollection.SolarThermalBaseDataDefinition(
    GMax=1000,
    dTMax=30,
    spacing(displayUnit="mm") = 0.02,
    dPipe(displayUnit="mm") = 0.012);

end SolarCollector;
