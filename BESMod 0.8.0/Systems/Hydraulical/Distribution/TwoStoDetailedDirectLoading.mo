within BESMod.Systems.Hydraulical.Distribution;
model TwoStoDetailedDirectLoading "Two detailed storages, direct loading of space heating"
  extends BaseClasses.PartialTwoStorageParallelWithHeaters(
    stoBuf(final useHeatingCoil1=false),
    final dpBufHCSto_design=0,
    final dTLoaHCBuf=0);

equation
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.fluidportBottom1)
    annotation (Line(points={{-40,154},{12,154},{12,88},{-56,88},{-56,-6},{-40,-6},
          {-40,-0.4},{-39.4,-0.4}},
                   color={0,127,255}));
  connect(pumTra.port_b, stoBuf.fluidportBottom2) annotation (Line(points={{60,40},
          {52,40},{52,-6},{-29.4,-6},{-29.4,-0.2}},     color={0,127,255}));
  connect(stoBuf.fluidportTop1, resValToBufSto.port_b) annotation (Line(points={
          {-39.6,40.2},{-39.6,86},{14,86},{14,160},{0,160}}, color={0,127,255}));
end TwoStoDetailedDirectLoading;
