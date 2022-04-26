within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage;
record DefaultDetailedStorage
  extends BufferStorageBaseDataDefinition(
    dTLoadingHC1=5,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC2,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1);
end DefaultDetailedStorage;
