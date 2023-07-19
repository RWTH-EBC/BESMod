within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage;
record DefaultDetailedStorage
  extends BufferStorageBaseDataDefinition(
    energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.B,
    dTLoadingHC1=5,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_28x0_9 pipeHC2,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_28x0_9 pipeHC1);
end DefaultDetailedStorage;
