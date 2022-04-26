within BESMod.Systems.RecordsCollection;
record ExampleSystemParameters
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    THydSup_nominal={328.15},
    V_dhwCalc_day=0,
    use_dhwCalc=false,
    redeclare
      BESMod.Systems.Demand.DHW.RecordsCollection.ProfileS
      DHWProfile,
    QBui_flow_nominal={10632.414942943078},
    use_ventilation=true,
    TOda_nominal=261.15);

end ExampleSystemParameters;
