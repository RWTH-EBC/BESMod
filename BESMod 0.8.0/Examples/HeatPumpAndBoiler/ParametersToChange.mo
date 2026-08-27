within BESMod.Examples.HeatPumpAndBoiler;
record ParametersToChange
  extends Systems.RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition;
  // 1. Add parameters like this (WITH Evaluate=false)!
  // parameter Modelica.SIunits.Volume V=0.5 annotation(Evaluate=false);
  // 2. Overwrite the default parameter in the system simulation
  // via the graphical interface, resulting in e.g.
  // Distribution.parameters.V = parameterStudy.V

  parameter Modelica.Units.SI.Temperature TCutOff=263.15 "Cut off temperature"
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.Temperature TBiv=268.15 "Bivalence temperature"
    annotation (Evaluate=false);
  parameter Real VPerQFlow=23.5 "Litre of storage volume per kilowatt thermal power demand" annotation(Evaluate=false);
  parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff=3000
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.HeatFlowRate QHP_flow_biv=4000
    annotation (Evaluate=false);
end ParametersToChange;
