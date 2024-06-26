within BESMod.Systems.Hydraulical.Distribution;
model TwoStoDetailedIndirectLoading "Two detailed storages, indirect loading of space heating"
  extends BaseClasses.PartialTwoStorageParallelWithHeaters(final
      dpBufHCSto_nominal=sum(stoBuf.heatingCoil1.pipe.res.dp_nominal));
  IBPSA.Fluid.Sources.Boundary_pT bouPumBuf(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=2)
    "Pressure reference for transfer circuit as generation circuit reference is not connected (indirect loading)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={52,10})));
equation
  connect(threeWayValveWithFlowReturn.portBui_b, stoBuf.portHC1In)
    annotation (Line(points={{-60,78},{-58,78},{-58,31.4},{-50.4,31.4}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.portHC1Out)
    annotation (Line(points={{-60,74},{-58,74},{-58,66},{-50,66},{-50,25.2},{
          -50.2,25.2}},
                   color={0,127,255}));
  connect(bouPumBuf.ports[1], stoBuf.fluidportBottom2) annotation (Line(
        points={{53,20},{53,22},{26,22},{26,-6},{-29.4,-6},{-29.4,-0.2}},
                                                      color={0,127,255}));
  connect(bouPumBuf.ports[2], portBui_in[1]) annotation (Line(points={{52,20},{52,
          28},{84,28},{84,40},{100,40}}, color={0,127,255}));
end TwoStoDetailedIndirectLoading;
