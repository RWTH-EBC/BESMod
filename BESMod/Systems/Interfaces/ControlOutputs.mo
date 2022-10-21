within BESMod.Systems.Interfaces;
expandable connector ControlOutputs
  "Bus with ouputs of the control system"
  extends BESMod.Systems.Interfaces.KPIBus;

  annotation (
  defaultComponentName = "outBusCtrl",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end ControlOutputs;
