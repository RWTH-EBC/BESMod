within BESMod.Systems.Hydraulical.RecordsCollection;
record HydraulicSystemBaseDataDefinition
  extends BESMod.Systems.RecordsCollection.SupplySystemBaseDataDefinition;
  extends BESMod.Systems.Hydraulical.RecordsCollection.DHWDesignParameters;
  annotation (Documentation(info="<html>
<p>Base data record for hydraulic systems that combines 
system-level parameters with domestic hot water parameters.</p>
</html>"));
end HydraulicSystemBaseDataDefinition;
