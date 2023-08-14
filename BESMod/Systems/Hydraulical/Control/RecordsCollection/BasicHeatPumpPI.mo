within BESMod.Systems.Hydraulical.Control.RecordsCollection;
record BasicHeatPumpPI "Typically good PI values for a heat pump"
  extends PIDBaseDataDefinition(
    timeDer=0,
    timeInt=1200,
    P=0.3,
    y_start=0,
    yOff=0,
    yMax=1,
    yMin=0.3);
end BasicHeatPumpPI;
