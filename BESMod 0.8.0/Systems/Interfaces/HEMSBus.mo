within BESMod.Systems.Interfaces;
expandable connector HEMSBus "Home energy management bus"
  extends BESMod.Utilities.Icons.ControlBus;
  annotation (
  defaultComponentName = "buiMeaBus",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end HEMSBus;
