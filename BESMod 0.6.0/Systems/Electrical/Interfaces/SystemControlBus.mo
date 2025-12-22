within BESMod.Systems.Electrical.Interfaces;
expandable connector SystemControlBus
  "System control bus for inputs to electrical models"
  extends BESMod.Utilities.Icons.ControlBus;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end SystemControlBus;
