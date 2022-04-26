within BESMod.Systems.Interfaces;
expandable connector ElectricalOutputs
  "Bus with ouputs of the electrical system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusHyd",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end ElectricalOutputs;
