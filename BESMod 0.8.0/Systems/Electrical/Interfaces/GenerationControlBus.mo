within BESMod.Systems.Electrical.Interfaces;
expandable connector GenerationControlBus
  "Control bus for inputs to electrical generation models"
  extends BESMod.Utilities.Icons.ControlBus;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end GenerationControlBus;
