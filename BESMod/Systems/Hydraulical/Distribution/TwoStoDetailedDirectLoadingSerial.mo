within BESMod.Systems.Hydraulical.Distribution;
model TwoStoDetailedDirectLoadingSerial
  "Two detailed storages, direct loading of space heating"
  extends BaseClasses.PartialTwoStorageSerialWithHeaters(
    stoBuf(m2_flow_nominal=0,
           final useHeatingCoil1=false),
    final dpBufHCSto_design=0,
    final dTLoaHCBuf=0);

equation
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.fluidportBottom1)
    annotation (Line(points={{-40,154},{12,154},{12,88},{-56,88},{-56,-6},{-40,-6},
          {-40,-0.4},{-39.4,-0.4}},
                   color={0,127,255}));
  connect(portBui_in[1], stoBuf.fluidportTop1) annotation (Line(points={{100,40},
          {-12,40},{-12,46},{-39.6,46},{-39.6,40.2}}, color={0,127,255}));
end TwoStoDetailedDirectLoadingSerial;
