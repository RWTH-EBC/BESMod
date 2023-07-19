within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage;
record DefaultStorage "Default storage data"
  extends SimpleStorageBaseDataDefinition(
    energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.B,
    kappa=0.4, 
    beta=350e-6);
end DefaultStorage;
