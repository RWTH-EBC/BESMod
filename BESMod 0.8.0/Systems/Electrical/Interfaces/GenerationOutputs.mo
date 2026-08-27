within BESMod.Systems.Electrical.Interfaces;
expandable connector GenerationOutputs "Bus for outputs of electrical generation models"
  extends BESMod.Utilities.Icons.OutputsBus;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end GenerationOutputs;
