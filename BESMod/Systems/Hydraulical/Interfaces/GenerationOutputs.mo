within BESMod.Systems.Hydraulical.Interfaces;
expandable connector GenerationOutputs
  "Bus with ouputs of the generation system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusGen",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end GenerationOutputs;
