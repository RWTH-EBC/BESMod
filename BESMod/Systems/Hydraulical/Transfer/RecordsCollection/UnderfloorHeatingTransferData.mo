within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record UnderfloorHeatingTransferData
  "Underfloor heating volume and 100 Pa/m pressure loss"
  extends TransferDataBaseDefinition(
    valveAutho=fill(0.5, nZones),
    perPreLosRad=0.05,
    pressureDropPerLen=100,
    typeOfHydRes=BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.FittingAndThermostatAndCheckValve,
    traType=BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.FloorHeating);

end UnderfloorHeatingTransferData;
