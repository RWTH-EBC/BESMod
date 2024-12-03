within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record SteelRadiatorStandardPressureLossData
  "Steel radiator and 100 Pa/m pressure loss"
  extends TransferDataBaseDefinition(
    valveAutho=fill(0.5, nZones),
    perPreLosRad=0.05,
    pressureDropPerLen=100,
    typeOfHydRes=BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.FittingAndThermostatAndCheckValve,
    traType=BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.SteelRadiator);

  annotation (Documentation(info="<html>
<p>
Record defining parameters for a steel radiator heating system 
with standard pressure losses of 100 Pa/m.
</p>

<h4>Important Parameters</h4>
<ul>
<li><code>valveAutho</code>: Valve authority, set to 0.5 for all zones</li>
<li><code>perPreLosRad</code>: Pressure loss coefficient for radiator set to 0.05</li>
<li><code>pressureDropPerLen</code>: Pressure drop per length of pipe set to 100 Pa/m</li>
<li><code>typeOfHydRes</code>: Hydraulic resistance type set to FittingAndThermostatAndCheckValve</li>
<li><code>traType</code>: Heat transfer system type set to SteelRadiator</li>
</ul>
</html>"));
end SteelRadiatorStandardPressureLossData;
