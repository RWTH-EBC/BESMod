within BESMod.Systems.Ventilation.Interfaces;
expandable connector SystemControlBus
  "Home energy management control bus to ventilation subsystem"
  extends BESMod.Utilities.Icons.ControlBus;
  annotation (
  defaultComponentName = "sigBusVen",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end SystemControlBus;
