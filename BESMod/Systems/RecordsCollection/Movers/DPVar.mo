within BESMod.Systems.RecordsCollection.Movers;
record DPVar "Controlled according to dpVar"
  extends MoverBaseDataDefinition(
    dpVarBase_nominal=0.5,
    ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar,
    tau=1,
    riseTimeInpFilter=30,
    use_inputFilter=false,
    addPowerToMedium=false);
end DPVar;