within BESMod.Systems.Electrical.Interfaces;
expandable connector ControlOutputs "Control bus for controller outputs"
  extends BESMod.Utilities.Icons.OutputsBus;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ControlOutputs;
