within BESMod.Systems.Hydraulical.Control.RecordsCollection;
record BasicHeatPumpPI "Typically good PI values for a heat pump"
  extends PIDBaseDataDefinition(
    timeDer=0,
    timeInt=4000,
    P=0.3,
    y_start=0,
    yOff=0,
    yMax=1,
    yMin=0.3);
  annotation (Documentation(info="<html>
<p>Record containing typical PI parameter values for heat pump control. 
</p>
</html>"));
end BasicHeatPumpPI;
