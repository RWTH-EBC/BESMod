within BESMod.Systems.Hydraulical.RecordsCollection;
record HydraulicSystemBaseDataDefinition
  extends BESMod.Systems.RecordsCollection.SupplySystemBaseDataDefinition;
  parameter BESMod.Systems.Demand.DHW.RecordsCollection.DHWDesignParameters dhwParas annotation (Dialog(group="DHW"));
end HydraulicSystemBaseDataDefinition;
