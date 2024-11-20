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
    annotation (Line(points={{-60,74},{-56,74},{-56,-12},{-40,-12},{-40,-0.4},{
          -39.4,-0.4}},
                   color={0,127,255}));
  connect(portBui_in[1], stoBuf.fluidportBottom2) annotation (Line(points={{100,
          40},{70,40},{70,-8},{-29.4,-8},{-29.4,-0.2}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>Model for two storage system with direct loading for space 
heating purposes. The buffer storage is loaded by the heat 
generators and directly supplies the space heating transer 
system. The DHW storage is supplied with heat from 
the heat generators.</p>
</html>"));
end TwoStoDetailedDirectLoading;
