within BESMod.Systems.Hydraulical.Control.RecordsCollection;
record SmartThermostatPI
  "Typically good PI values for a smart thermostat"
  extends PIDBaseDataDefinition(
    timeInt=500,
    P=1,
    yMax=273.15 + 55,
    final yOff=293.15,
    final y_start=yMax,
    final yMin=293.15,
    final timeDer=0,
    final Nd=10);
  annotation (Documentation(info="<html>
<p>This record contains typical PI controller values for a 
smart thermostat. 
It pre-configures the parameters for stable room temperature control.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>timeInt = 500</code>: Integration time constant [s]</li>
  <li><code>P = 1</code>: Proportional gain [-]</li>
  <li><code>yMax = 328.15</code>: Maximum output temperature (55 degC) [K]</li>
  <li><code>yOff = 293.15</code>: Output offset (20 degC) [K]</li>
  <li><code>yMin = 293.15</code>: Minimum output temperature (20 degC) [K]</li>
</ul>
</html>"));
end SmartThermostatPI;
