within BESMod.Systems.Interfaces;
expandable connector UseProBus "Data bus with user profiles"
  extends BESMod.Utilities.Icons.UseProBus;
annotation (
  defaultComponentName = "useProBus",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));
end UseProBus;
