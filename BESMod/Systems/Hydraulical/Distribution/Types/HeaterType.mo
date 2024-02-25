within BESMod.Systems.Hydraulical.Distribution.Types;
type HeaterType = enumeration(
    No
     "No heater",
    ElectricHeater
             "Use an electric heater",
    Boiler
         "Use a boiler")
  "Select between boiler, electric heater or no additional heater";
