within BESMod.Systems.Interfaces;
expandable connector HydraulicOutputs
  "Bus with ouputs of the hydraulic system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusHyd",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end HydraulicOutputs;
