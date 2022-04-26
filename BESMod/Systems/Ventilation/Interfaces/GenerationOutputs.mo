within BESMod.Systems.Ventilation.Interfaces;
expandable connector GenerationOutputs
  "Bus with ouputs of the generation system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusGen",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end GenerationOutputs;
