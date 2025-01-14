within BESMod.Systems.Hydraulical.Distribution;
model TwoStoDetailedIndirectLoading "Two detailed storages, indirect loading of space heating"
  extends BaseClasses.PartialTwoStorageParallelWithHeaters(
    final dpBufHCSto_design=sum(stoBuf.heatingCoil1.pipe.res.dp_nominal));
  IBPSA.Fluid.Sources.Boundary_pT bouPumBuf(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    nPorts=1)
    "Pressure reference for transfer circuit as generation circuit reference is not connected (indirect loading)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,10})));
initial algorithm
  assert(parStoBuf.qHC1_flow_nominal * 1000 > 0.25, "In " + getInstanceName() +
      ": Storage heat exchanger is probably to small and the calculated heat 
      transfer coefficient to high. VDI 4645 suggests at least 0.25 m2/W, 
      you have " + String(parStoBuf.qHC1_flow_nominal) + "m2/W", AssertionLevel.warning);
equation
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.portHC1Out)
    annotation (Line(points={{-40,154},{10,154},{10,52},{-56,52},{-56,24},{-50.2,
          24},{-50.2,25.2}},
                   color={0,127,255}));
  connect(bouPumBuf.ports[1], pumTra.port_a)
    annotation (Line(points={{90,20},{90,40},{80,40}}, color={0,127,255}));
  connect(pumTra.port_b, stoBuf.fluidportBottom2) annotation (Line(points={{60,
          40},{26,40},{26,-4},{-30,-4},{-30,-0.2},{-29.4,-0.2}}, color={0,127,
          255}));
  connect(resValToBufSto.port_b, stoBuf.portHC1In) annotation (Line(points={{0,160},
          {12,160},{12,46},{-54,46},{-54,31.4},{-50.4,31.4}}, color={0,127,255}));
end TwoStoDetailedIndirectLoading;
