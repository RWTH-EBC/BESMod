within BESMod.Systems.Ventilation.Interfaces;
expandable connector GenerationControlBus
  "data bus with control signals for generation model"
  extends BESMod.Utilities.Icons.ControlBus;

  annotation (
  defaultComponentName = "sigBusGen",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end GenerationControlBus;
