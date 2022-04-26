within BESMod.Systems.RecordsCollection.ParameterStudy;
partial record ParameterStudyBaseDefinition
  "Partial record for all parameters which may be changed during an analysis or optimization"
  extends Modelica.Icons.Record;
  // Important: Add annotation(Evaluate=false) to all parameter defined in here!
  annotation (Evaluate=false, defaultComponentName = "baseParameterAssumptions", Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Important:&nbsp;Add&nbsp;annotation(Evaluate=false)&nbsp;to&nbsp;all&nbsp;parameter&nbsp;defined&nbsp;in&nbsp;here!</span></p>
</html>"));
end ParameterStudyBaseDefinition;
