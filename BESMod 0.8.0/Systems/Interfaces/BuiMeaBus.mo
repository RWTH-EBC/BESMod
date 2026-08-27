within BESMod.Systems.Interfaces;
expandable connector BuiMeaBus "data bus with user profiles"
  extends BESMod.Utilities.Icons.BuiMeaBus;
  annotation (
  defaultComponentName = "buiMeaBus",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end BuiMeaBus;
