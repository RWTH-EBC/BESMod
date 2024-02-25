within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
partial record EletricHeaterBaseDataDefinition
  extends Modelica.Icons.Record;
  // Generation: electric heater
  parameter Real eta "Electric heater efficiency";
  parameter Modelica.Units.SI.Volume V_hr
    "Volume to model thermal inertia of water";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Pressure difference";

  parameter Integer discretizationSteps(min=0) "Number of steps to dicretize. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1";

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end EletricHeaterBaseDataDefinition;
