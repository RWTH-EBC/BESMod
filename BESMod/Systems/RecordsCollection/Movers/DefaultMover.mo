within BESMod.Systems.RecordsCollection.Movers;
record DefaultMover
  extends MoverBaseDataDefinition(
    tau=1,
    riseTimeInpFilter=30,
    use_riseTime=false,
    addPowerToMedium=false);
end DefaultMover;
