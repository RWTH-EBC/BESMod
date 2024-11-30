within BESMod.Systems.RecordsCollection.Movers;
record SpeedControlled "External speed controlled pump"
  extends MoverBaseDataDefinition(
    externalCtrlTyp=BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.speed,
    dpVarBase_nominal=0.5,
    ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar,
    tau=1,
    riseTimeInpFilter=30,
    use_inputFilter=false,
    addPowerToMedium=false);
end SpeedControlled;
