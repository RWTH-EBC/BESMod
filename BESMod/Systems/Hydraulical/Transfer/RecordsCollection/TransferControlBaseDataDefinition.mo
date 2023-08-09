within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record TransferControlBaseDataDefinition
  "Custom transfer control data record"
  extends BESMod.Systems.RecordsCollection.SubsystemControlBaseDataDefinition;
  parameter Real nHeaTra "Exponent of heat transfer system";
end TransferControlBaseDataDefinition;
