within BESMod.Systems.Ventilation.Interfaces;
expandable connector GenerationControlBus
  "data bus with control signals for generation model"
  extends BESMod.Utilities.Icons.ControlBus;

  annotation (
  defaultComponentName = "sigBusGen",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end GenerationControlBus;
