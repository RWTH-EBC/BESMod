within BESMod.Systems.RecordsCollection.Movers;
record DefaultMover
  extends MoverBaseDataDefinition(
    tau=1,
    riseTimeInpFilter=30,
    use_inputFilter=false,
    addPowerToMedium=false,
    speed_rpm_nominal=1500,
    dpCurve={1.01,1,0.99,0},
    V_flowCurve={0,0.99,1,1.01});
end DefaultMover;
