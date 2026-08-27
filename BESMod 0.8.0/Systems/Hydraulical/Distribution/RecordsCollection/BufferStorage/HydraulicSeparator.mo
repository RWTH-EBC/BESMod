within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage;
record HydraulicSeparator "Hydraulic separator record"
  extends BufferStorageBaseDataDefinition(
    final use_hr=false,
    sIns(displayUnit="mm") = 0.05,
    QLosPerDay=0,
    d(displayUnit="mm"),
    V(displayUnit="l") = 0.005,
    storage_H_dia_ratio=3,
    energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.B,
    dTLoadingHC1=0);
end HydraulicSeparator;
