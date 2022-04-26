within BESMod.Examples.UseCaseAachenTimeBased;
record ParametersToChange "parameter study BA Andre Liang"
  extends Systems.RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition;
  // 1. Add parameters like this (WITH Evaluate=false)!
  // parameter Modelica.SIunits.Volume V=0.5 annotation(Evaluate=false);
  // 2. Overwrite the default parameter in the system simulation
  // via the graphical interface, resulting in e.g.
  // Distribution.parameters.V = parameterStudy.V

  parameter Modelica.SIunits.Time dt_hrDHW=60*30 annotation(Evaluate=false);
  parameter Modelica.SIunits.Time dt_hrBuf=60*30 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference dTHysDHW=10 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference dTHysBuf=10 annotation(Evaluate=false);
end ParametersToChange;
