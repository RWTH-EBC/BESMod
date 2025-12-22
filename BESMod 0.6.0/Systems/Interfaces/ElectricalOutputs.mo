within BESMod.Systems.Interfaces;
expandable connector ElectricalOutputs
  "Bus with ouputs of the electrical system"
  extends BESMod.Utilities.Icons.OutputsBus;

  annotation (
  defaultComponentName = "outBusHyd",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end ElectricalOutputs;
