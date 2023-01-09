within BESMod.Examples.TestGridInteraction;
block GreaterThresholdInit
    "Output y is true, if input u is greater than threshold (for the first three days output is also true)"
  extends Modelica.Blocks.Interfaces.partialBooleanThresholdComparison;
  parameter Real delay_time = 259200; // delay time of 3 days to start with winter mode

equation
  if (time < 10368000 or time >= 23587200) then // winter mode constraint (between 1.05 (10368000 s) and 01.10 (23587200 s) is summer mode)
   y = true; //winter mode
  else //summer mode constraint
     if (time <= delay_time) then
     y = true; //start the first 3 days with winter mode
     else
     y = u > threshold;
     end if;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GreaterThresholdInit;
