within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage;
record DefaultDetailedStorage_Direct
  extends BufferStorageBaseDataDefinition(
    dTLoadingHC1=0,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_28x0_9 pipeHC2,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_28x0_9 pipeHC1);
end DefaultDetailedStorage_Direct;
