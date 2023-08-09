within BESMod.Systems.Hydraulical.Control.RecordsCollection;
partial record BivalentHeatPumpControlDataDefinition
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.TemperatureDifference dTHysBui
    "Hysteresis for building demand control"
    annotation (Dialog(group="General"));
  parameter Modelica.Units.SI.TemperatureDifference dTHysDHW
    "Hysteresis for DHW demand control" annotation (Dialog(group="General"));
  parameter Real k "Proportional gain of Primary PID Controller"
    annotation(Dialog(group="Primary PID Control"));
  parameter Modelica.Units.SI.Time T_I
    "Time constant of Integrator block of PI control" annotation (Dialog(group=
    "Primary PID Control"));

  parameter Modelica.Units.SI.Time Ni "Anti wind up constant of PID control"
    annotation (Dialog(group="Primary PID Control"));
  parameter Real nMin
    "Minimum relative input signal of primary device PID control"
    annotation (Dialog(group="Primary PID Control"));

end BivalentHeatPumpControlDataDefinition;
