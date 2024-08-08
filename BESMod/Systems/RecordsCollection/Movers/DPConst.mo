within BESMod.Systems.RecordsCollection.Movers;
record DPConst "Controlled according to dpConst"
  extends MoverBaseDataDefinition(
    dpVarBase_nominal=0.5,
    ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar,
    tau=1,
    riseTimeInpFilter=30,
    use_inputFilter=false,
    addPowerToMedium=false);
end DPConst;