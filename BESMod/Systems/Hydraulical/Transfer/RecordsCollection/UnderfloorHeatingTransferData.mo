within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record UnderfloorHeatingTransferData
  "Underfloor heating volume and 100 Pa/m pressure loss"
  extends TransferDataBaseDefinition(
    valveAutho=fill(0.5, nZones),
    perPreLosRad=0.05,
    pressureDropPerLen=100,
    typeOfHydRes=BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.FittingAndThermostatAndCheckValve,
    traType=BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.FloorHeating);

annotation (Documentation(info="<html>
<p>Record for underfloor heating with the following fixed parameters:</p>
<ul>
<li>Valve authority: 0.5 for all zones</li> 
<li>Relative pressure loss through radiator: 5%</li>
<li>Pressure drop per length: 100 Pa/m</li>
<li>Hydraulic resistance type: Fitting, thermostat and check valve</li>
<li>Heat transfer system type: Floor heating</li>
</ul>
</html>"));
end UnderfloorHeatingTransferData;
