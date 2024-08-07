within BESMod.Systems.Hydraulical.Distribution;
model TwoStoDetailedDirectLoading "Two detailed storages, direct loading of space heating"
  extends BaseClasses.PartialTwoStorageParallelWithHeaters(
    stoBuf(final useHeatingCoil1=false),
    final dpBufHCSto_nominal=0,
    final dTLoaHCBuf=0);

equation
  connect(threeWayValveWithFlowReturn.portBui_b, stoBuf.fluidportTop1)
    annotation (Line(points={{-20,72},{6,72},{6,48},{-40,48},{-40,42},{-38,42},
          {-38,40.2},{-39.6,40.2}},
                   color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.fluidportBottom1)
    annotation (Line(points={{-20,68},{8,68},{8,46},{-54,46},{-54,-8},{-40,-8},
          {-40,-0.4},{-39.4,-0.4}},
                   color={0,127,255}));
  connect(pumpTra.port_a, portBui_in[1])
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(pumpTra.port_b, stoBuf.fluidportBottom2) annotation (Line(points={{60,
          40},{58,40},{58,-8},{-29.4,-8},{-29.4,-0.2}}, color={0,127,255}));
end TwoStoDetailedDirectLoading;
