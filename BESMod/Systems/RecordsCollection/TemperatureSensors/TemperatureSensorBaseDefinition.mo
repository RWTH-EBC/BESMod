within BESMod.Systems.RecordsCollection.TemperatureSensors;
partial record TemperatureSensorBaseDefinition
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Time tau
    "Time constant at nominal flow rate (use tau=0 for steady-state sensor, but see user guide for potential problems)";
  parameter Modelica.Blocks.Types.Init initType
    "Type of initialization (InitialState and InitialOutput are identical)";
  parameter Boolean transferHeat
    "if true, temperature T converges towards TAmb when no flow";

  parameter Modelica.Units.SI.Time tauHeaTra
    "Time constant for heat transfer, default 20 minutes";
  parameter Modelica.Units.SI.Temperature TAmb
    "Fixed ambient temperature for heat transfer";

annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
end TemperatureSensorBaseDefinition;
