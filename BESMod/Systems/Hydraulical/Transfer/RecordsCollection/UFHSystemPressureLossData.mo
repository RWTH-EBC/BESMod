within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record UFHSystemPressureLossData
  extends TransferDataBaseDefinition_forUFH(
    valveAutho=fill(0.5, nZones),
    pressureDropPerLen=100,
    typeOfHydRes=BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.FittingAndThermostatAndCheckValve,
    traType=BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.FloorHeating);
end UFHSystemPressureLossData;
