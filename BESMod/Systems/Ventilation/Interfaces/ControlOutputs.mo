within BESMod.Systems.Ventilation.Interfaces;
expandable connector ControlOutputs "Bus with ouputs of the control system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusCtrl",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end ControlOutputs;
