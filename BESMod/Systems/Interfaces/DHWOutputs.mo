within BESMod.Systems.Interfaces;
expandable connector DHWOutputs "Bus with ouputs of the DHW system"
  extends BESMod.Utilities.Icons.KPIBus;
  annotation (
  defaultComponentName = "outBusDem",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end DHWOutputs;
