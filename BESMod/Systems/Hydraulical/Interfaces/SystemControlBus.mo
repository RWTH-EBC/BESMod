within BESMod.Systems.Hydraulical.Interfaces;
expandable connector SystemControlBus
  "Home energy management control bus to hydraulic subsystem"
  extends BESMod.Utilities.Icons.ControlBus;
  annotation (
  defaultComponentName = "sigBusHyd",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end SystemControlBus;
