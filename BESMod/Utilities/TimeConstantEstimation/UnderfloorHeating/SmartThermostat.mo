within BESMod.Utilities.TimeConstantEstimation.UnderfloorHeating;
model SmartThermostat "Smart thermotat PI control estimation"
  extends Partial(hydraulic(control(redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.SingleZonePID
          supTSet(parPID=parPID))));
  replaceable parameter BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
    parPID(
    yMax=273.15 + 45,
    yOff=293.15,
    y_start=293.15,
    yMin=293.15,
    P=P,
    timeInt=timeInt)
           "PID parameters for smart thermostat"
    annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Time timeInt=1200
    "Time constant of Integrator block" annotation (Dialog(tab="Advanced"));
  parameter Real P=0.3 "Gain of PID-controller"
    annotation (Dialog(tab="Advanced"));
end SmartThermostat;
