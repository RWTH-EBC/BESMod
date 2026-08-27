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

end DateBased;
