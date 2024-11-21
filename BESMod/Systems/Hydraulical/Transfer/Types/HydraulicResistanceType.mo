within BESMod.Systems.Hydraulical.Transfer.Types;
type HydraulicResistanceType = enumeration(
    Fittings "Fittings only",
    Thermostat "Thermostatic valve",
    CheckValve "Check valve / gravity brake / mixing valve",
    FittingAndThermostat "Fittings + Thermostatic valve",
    FittingAndThermostatAndCheckValve "Fittings + Thermostatic valve + Check valve")
  annotation (Documentation(info="<html>
<p>Enumeration defining different types of hydraulic resistances 
that can be present in hydronic systems.</p>

<h4>Important Parameters</h4>
<ul>
<li><code>Fittings</code>: Only considers pipe fittings resistance</li>
<li><code>Thermostat</code>: Only considers thermostatic valve resistance</li>
<li><code>CheckValve</code>: Only considers check valve, gravity brake or mixing valve resistance</li>
<li><code>FittingAndThermostat</code>: Combines resistance of fittings and thermostatic valve</li>
<li><code>FittingAndThermostatAndCheckValve</code>: Combines resistance of fittings, thermostatic valve and check valve</li>
</ul>
</html>"));