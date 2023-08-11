within BESMod.Systems.Hydraulical.Control.RecordsCollection;
record BasicHeatPumpPI "Typically good PI values for a heat pump"
  extends PIDBaseDataDefinition(
    y_start=0,
    yOff=0,
    yMax=1,
    yMin=0.3);
end BasicHeatPumpPI;
