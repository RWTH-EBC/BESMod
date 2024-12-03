within BESMod.Systems.Hydraulical.Control.Components.SummerMode;
model DateBased "Date based summer mode"
  extends BaseClasses.PartialSummerMode;

  parameter Integer sumTimSta= (31+28+31+30) * 86400 "Summer start time, default 01.05";
  parameter Integer sumTimEnd= (31+28+31+30+31+30+31+31+30) * 86400 "Summer end time, default 01.10";
protected
  parameter Integer oneYear = 365*86400 "One year in seconds";

equation
  if (mod(time, oneYear) >= sumTimSta and mod(time, oneYear) < sumTimEnd) then
   sumMod = true; //winter mode
  else //summer mode constraint
   sumMod = false;
  end if;

  annotation (Documentation(info="<html>
<p>Model for summer/winter mode control based on calendar dates. 
Summer mode is activated between the configurable start and end time 
during the year. 
Default values are May 1st (start) and October 1st (end). 
The model uses UNIX timestamps in seconds for date comparison, 
with start of the year (January 1st) as reference point.</p>
</html>"));
end DateBased;
