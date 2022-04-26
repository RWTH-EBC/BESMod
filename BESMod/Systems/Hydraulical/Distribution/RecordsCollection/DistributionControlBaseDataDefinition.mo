within BESMod.Systems.Hydraulical.Distribution.RecordsCollection;
record DistributionControlBaseDataDefinition
  extends
    BESMod.Systems.RecordsCollection.SubsystemControlBaseDataDefinition;
  extends
    BESMod.Systems.Demand.DHW.RecordsCollection.DHWDesignParameters;
  parameter Modelica.SIunits.TemperatureDifference dTTraDHW_nominal "Nominal temperature difference to transfer heat to DHW"  annotation (Dialog(group="DHW Demand"));

end DistributionControlBaseDataDefinition;
