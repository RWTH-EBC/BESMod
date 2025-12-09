within BESMod.BESRules.DesignOptimization;
record DesignOptimizationVariables
  "Parameters which are used as optimization variables"
  extends
    BESMod.Systems.RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition;
  // 1. Add parameters like this (WITH Evaluate=false)!
  // parameter Modelica.SIunits.Volume V=0.5 annotation(Evaluate=false);
  // 2. Overwrite the default parameter in the system simulation
  // via the graphical interface, resulting in e.g.
  // Distribution.parameters.V = parameterStudy.V
  parameter Modelica.Units.SI.Temperature TCutOff=263.15 "Cut off temperature" annotation (Evaluate=false);
  parameter Modelica.Units.SI.Temperature TBiv=268.15 "Bivalence temperature" annotation (Evaluate=false);
  parameter Real VPerQFlow=23.5 "Litre of storage volume per kilowatt thermal power demand" annotation (Evaluate=false);
  parameter Modelica.Units.SI.Temperature THeaThr=293.15 "Heating threshold temperature" annotation (Evaluate=false);
end DesignOptimizationVariables;
