within BESMod.Systems.RecordsCollection.Valves;
record DefaultThreeWayValve
  extends ThreeWayValve(
    from_dp=true,
    y_start=1,
    valveAutho=0.5,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    order=2,
    strokeTime=120,
    use_strokeTime=false,
    tau=10,
    fraK=1,
    l={0.0001,0.0001},
    R=50,
    delta0=0.01,
    deltaM=0.02);
end DefaultThreeWayValve;
