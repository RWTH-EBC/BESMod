within BESMod.Systems.Hydraulical.Interfaces;
expandable connector TransferControlBus
  "data bus with control signals for generation model"
  extends BESMod.Utilities.Icons.ControlBus;

annotation (
  defaultComponentName = "traControlBus",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end TransferControlBus;
