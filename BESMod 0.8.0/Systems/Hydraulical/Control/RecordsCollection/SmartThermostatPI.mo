within BESMod.Systems.Hydraulical.Control.RecordsCollection;
record SmartThermostatPI
  "Typically good PI values for a smart thermostat"
  extends PIDBaseDataDefinition(
    timeInt=500,
    P=1,
    yMax=273.15 + 55,
    final yOff=293.15,
    final y_start=yMax,
    final yMin=293.15,
    final timeDer=0,
    final Nd=10);
end SmartThermostatPI;
