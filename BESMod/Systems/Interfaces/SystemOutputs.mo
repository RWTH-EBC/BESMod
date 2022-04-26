within BESMod.Systems.Interfaces;
expandable connector SystemOutputs "Bus with ouputs of the overall system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusGen",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end SystemOutputs;
