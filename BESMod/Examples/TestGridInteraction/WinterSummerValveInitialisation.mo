within BESMod.Examples.TestGridInteraction;
block WinterSummerValveInitialisation
    extends Modelica.Blocks.Interfaces.partialBooleanSI3SO;
    parameter Real delay_time = 259200; // delay time of 3 days to start with winter mode
equation
  if (time <= delay_time) then
    y = u1; //start the first 3 days with winter mode
  else
    y = if u2 then u1 else u3;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WinterSummerValveInitialisation;
