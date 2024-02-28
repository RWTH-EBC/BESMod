within BESMod.Systems.Interfaces;
expandable connector VentilationOutputs
  "Bus with ouputs of the ventilation system"
  extends BESMod.Utilities.Icons.OutputsBus;

  annotation (
  defaultComponentName = "outBusVen",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end VentilationOutputs;
