within BESMod.Systems.Interfaces;
expandable connector DemandOutputs "Bus with ouputs of the demand system"
  extends BESMod.Systems.Interfaces.KPIBus;

  annotation (
  defaultComponentName = "outBusDem",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end DemandOutputs;
