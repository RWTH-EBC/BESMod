within BESMod.Systems.Hydraulical.Distribution.RecordsCollection;
record DistributionControlBaseDataDefinition
  extends BESMod.Systems.RecordsCollection.SubsystemControlBaseDataDefinition;
  extends BESMod.Systems.Hydraulical.RecordsCollection.DHWDesignParameters;
  parameter Modelica.Units.SI.TemperatureDifference dTTraDHW_nominal
    "Nominal temperature difference to transfer heat to DHW"
    annotation (Dialog(group="DHW Demand"));

  annotation (Documentation(info="<html>
<p>Record that extends base parameters for DHW system control and design. 
Combines general subsystem control parameters from
<a href=\"modelica://BESMod.Systems.RecordsCollection.SubsystemControlBaseDataDefinition\">BESMod.Systems.RecordsCollection.SubsystemControlBaseDataDefinition</a> 
and DHW design parameters from <a href=\"modelica://BESMod.Systems.Hydraulical.RecordsCollection.DHWDesignParameters\">BESMod.Systems.Hydraulical.RecordsCollection.DHWDesignParameters</a>.
</p>
</html>"));
end DistributionControlBaseDataDefinition;
