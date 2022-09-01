within BESMod.Examples.SolarThermalSystem;
record CombiStorage
  extends
    Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    V(displayUnit="l") = 0.5,
    nLayer=20,
    dTLoadingHC2=5,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_22x1 pipeHC2,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_22x1 pipeHC1);
end CombiStorage;
