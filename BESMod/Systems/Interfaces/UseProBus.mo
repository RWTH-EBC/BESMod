within BESMod.Systems.Interfaces;
expandable connector UseProBus "Data bus with user profiles"
  extends BESMod.Utilities.Icons.UseProBus;

  // Required for OpenModelica to run. However, does not match for
  // each building approach, e.g. HOM from AixLib for multiple zones.
  // Real intGains[3];

annotation (
  defaultComponentName = "useProBus",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));
end UseProBus;
