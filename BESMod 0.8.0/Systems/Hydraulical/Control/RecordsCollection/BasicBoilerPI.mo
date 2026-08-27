within BESMod.Systems.Hydraulical.Control.RecordsCollection;
record BasicBoilerPI "Currently used PI values for a boiler"
  extends PIDBaseDataDefinition(
    Nd=10,
    timeDer=0,
    Ni=0.9,
    timeInt=600,
    P=2,
    y_start=0,
    yOff=0,
    yMax=1,
    yMin=0.3);
end BasicBoilerPI;
