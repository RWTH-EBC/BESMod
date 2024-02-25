within BESMod.Utilities.TimeConstantEstimation.UnderfloorHeating;
model SmartThermostat "Smart thermotat PI control estimation"
  extends Partial(hydraulic(control(redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.SingleZonePID
          supTSet(redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.SmartThermostatPI
            parPID(
            yMax=273.15 + 45,
            P=P,
            timeInt=timeInt)))), systemParameters(QBui_flow_nominal={11000}));
  parameter Modelica.Units.SI.Time timeInt=1200
    "Time constant of Integrator block";
  parameter Real P=0.3 "Gain of PID-controller";
end SmartThermostat;
