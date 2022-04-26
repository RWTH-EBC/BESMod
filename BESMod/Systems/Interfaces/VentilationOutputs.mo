within BESMod.Systems.Interfaces;
expandable connector VentilationOutputs
  "Bus with ouputs of the ventilation system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusVen",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end VentilationOutputs;
