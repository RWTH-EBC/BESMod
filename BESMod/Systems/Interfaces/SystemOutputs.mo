within BESMod.Systems.Interfaces;
expandable connector SystemOutputs "Bus with ouputs of the overall system"
  extends BESMod.Systems.Interfaces.KPIBus;

  annotation (
  defaultComponentName = "outBusGen",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));
end SystemOutputs;
