within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
partial record HeatingRodBaseDataDefinition
  extends Modelica.Icons.Record;
  // Generation: Heating Rod
  parameter Real eta_hr "Heating rod efficiency";
  parameter Modelica.SIunits.Volume V_hr
    "Volume to model thermal inertia of water";
    parameter Modelica.SIunits.PressureDifference dp_nominal
    "Pressure difference";

  parameter Integer discretizationSteps(min=0) "Number of steps to dicretize. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatingRodBaseDataDefinition;
