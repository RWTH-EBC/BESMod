within BESMod.Systems.Hydraulical.Control.Components.SummerMode.BaseClasses;
block SummerTimeConstraint
  "Output is true if summer mode is activated"
  extends Modelica.Blocks.Interfaces.partialBooleanThresholdComparison(final
      threshold=delTim);
  parameter Integer sumTimSta= (31+28+31+30) * 86400 "Summer start time, default 01.05";
  parameter Integer sumTimEnd= (31+28+31+30+31+30+31+31+30) * 86400 "Summer end time, default 01.10";

  parameter Modelica.Units.SI.Time delTim(displayUnit="h")=10800
                                                  "Delay time to start winter mode";
equation
  if (time < sumTimSta or time >= sumTimEnd) then
   y = true; //winter mode
  else //summer mode constraint
   y = u > threshold;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SummerTimeConstraint;
