within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage;
record DefaultDetailedStorage
  extends BufferStorageBaseDataDefinition(
    energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.B,
    dTLoadingHC1=5);
  annotation (Documentation(info="<html>
<p>
This record extends the basic buffer storage 
definition for hydraulic distribution systems. 
It represents a detailed buffer storage configuration with energy 
efficiency class B and a temperature difference for loading the 
heating circuit 1 (dTLoadingHC1) of 5 Kelvin.
</p>
</html>"));
end DefaultDetailedStorage;
