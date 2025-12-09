within BESMod.Systems.Hydraulical.Distribution.RecordsCollection;
function GetDailyStorageLossesForLabel
  "Get daily storage losses for energy label"
  input Modelica.Units.SI.Volume V "Storage volume";
  input Types.EnergyLabel energyLabel "Energy label";
  output Real QLosPerDay "Storage loss per day in kWh/d";

algorithm
  if energyLabel == Types.EnergyLabel.APlus then
    QLosPerDay:= (5.5+3.16*(V*1000)^(0.4))*0.024;
  elseif energyLabel == Types.EnergyLabel.A then
    QLosPerDay:= (7+ 3.705*(V*1000)^(0.4))*0.024;
  elseif energyLabel == Types.EnergyLabel.B then
    QLosPerDay:=(10.25 + 5.09*(V*1000)^(0.4))*0.024;
  elseif energyLabel == Types.EnergyLabel.C then
    QLosPerDay:=(14.33+ 7.13 *(V*1000)^(0.4))*0.024;
  elseif energyLabel == Types.EnergyLabel.D then
    QLosPerDay:=(18.83 + 9.33*(V*1000)^(0.4))*0.024;
  elseif energyLabel == Types.EnergyLabel.E then
    QLosPerDay:=(23.5 + 11.995*(V*1000)^(0.4))*0.024;
  elseif energyLabel == Types.EnergyLabel.F then
    QLosPerDay:=(28.5+ 15.16*(V*1000)^(0.4))*0.024;
  elseif energyLabel == Types.EnergyLabel.G then
    QLosPerDay:=(31 + 16.66*(V*1000)^(0.4))*0.024;
  else
    QLosPerDay:= 0;
  end if;
end GetDailyStorageLossesForLabel;
