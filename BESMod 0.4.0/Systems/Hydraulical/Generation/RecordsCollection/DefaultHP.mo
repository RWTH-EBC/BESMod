within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
record DefaultHP
  extends
    Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition(
    genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentAlternativ,
    THeaTresh=293.15);

end DefaultHP;
