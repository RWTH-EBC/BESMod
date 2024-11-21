within BESMod.Systems.Hydraulical.Distribution.Types;
type HeaterType = enumeration(
    No
     "No heater",
    ElectricHeater
             "Use an electric heater",
    Boiler
         "Use a boiler")
  "Select between boiler, electric heater or no additional heater"
  annotation (Documentation(info="<html>
<p>Enumeration type to select between different types of additional heaters in distribution systems:</p>
<p><ul>
  <li><code>No</code>: No additional heater</li>
  <li><code>ElectricHeater</code>: Additional electric heater</li> 
  <li><code>Boiler</code>: Additional boiler as backup heater</li>
</ul></p>
</html>"));
