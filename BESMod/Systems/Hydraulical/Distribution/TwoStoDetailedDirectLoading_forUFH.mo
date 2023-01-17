within BESMod.Systems.Hydraulical.Distribution;
model TwoStoDetailedDirectLoading_forUFH
  "Two detailed storages, direct loading of space heating for UFH"
  extends BaseClasses.PartialDistributionTwoStorageParallelDetailed_HCPipeForUFH(
    storageBuf(final useHeatingCoil1=false),
    final dpBufHCSto_nominal=0,
    final dTLoaHCBuf=0);

equation
  connect(threeWayValveWithFlowReturn.portBui_b, storageBuf.fluidportTop1)
    annotation (Line(points={{-60,72},{-58,72},{-58,66},{-24,66},{-24,58.22},{-24.3,
          58.22}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_a, storageBuf.fluidportBottom1)
    annotation (Line(points={{-60,68},{-60,68},{-60,64},{-42,64},{-42,4},{-24,4},
          {-24,13.56},{-24.075,13.56}},
                   color={0,127,255}));
end TwoStoDetailedDirectLoading_forUFH;
