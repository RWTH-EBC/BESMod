within BESMod.Systems.Hydraulical.Distribution;
model TwoStoDetailedDirectLoading "Two detailed storages, direct loading of space heating"
  extends BaseClasses.PartialTwoStorageParallelWithHeaters(
    stoBuf(final useHeatingCoil1=false),
    final dpBufHCSto_nominal=0,
    final dTLoaHCBuf=0);

equation
  connect(threeWayValveWithFlowReturn.portBui_b, stoBuf.fluidportTop1)
    annotation (Line(points={{-60,78},{-58,78},{-58,66},{-24,66},{-24,40.2},{
          -39.6,40.2}},
                   color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.fluidportBottom1)
    annotation (Line(points={{-60,74},{-60,74},{-60,64},{-42,64},{-42,4},{-24,4},
          {-24,-0.4},{-39.4,-0.4}},
                   color={0,127,255}));
end TwoStoDetailedDirectLoading;
