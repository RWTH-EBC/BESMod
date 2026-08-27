within BESMod.Systems.Interfaces;
expandable connector DHWOutputs "Bus with ouputs of the DHW system"
  extends BESMod.Utilities.Icons.OutputsBus;
  annotation (
  defaultComponentName = "outBusDem",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end DHWOutputs;
