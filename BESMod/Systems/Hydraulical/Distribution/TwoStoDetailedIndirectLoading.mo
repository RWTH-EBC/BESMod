within BESMod.Systems.Hydraulical.Distribution;
model TwoStoDetailedIndirectLoading "Two detailed storages, indirect loading of space heating"
  extends BaseClasses.PartialDistributionTwoStorageParallelDetailed(final
      dpBufHCSto_nominal=sum(storageBuf.heatingCoil1.pipe.res.dp_nominal));
  IBPSA.Fluid.Sources.Boundary_pT bouPumBuf(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1)
    "Pressure reference for transfer circuit as generation circuit reference is not connected (indirect loading)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-10})));
equation
  connect(threeWayValveWithFlowReturn.portBui_b, storageBuf.portHC1In)
    annotation (Line(points={{-60,72},{-58,72},{-58,48.54},{-36.45,48.54}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_a, storageBuf.portHC1Out)
<<<<<<< HEAD
<<<<<<< HEAD
    annotation (Line(points={{-64,68},{-58,68},{-58,66},{-50,66},{-50,41.72},{
          -36.225,41.72}},
                   color={0,127,255}));
  connect(bouPumpBuf.ports[1], storageBuf.fluidportBottom2) annotation (Line(
        points={{-13,-2},{-13,13.78},{-12.825,13.78}}, color={0,127,255}));
=======
    annotation (Line(points={{-64,68},{-58,68},{-58,66},{-50,66},{-50,41.72},{-36.225,
=======
    annotation (Line(points={{-60,68},{-58,68},{-58,66},{-50,66},{-50,41.72},{-36.225,
>>>>>>> main
          41.72}}, color={0,127,255}));
  connect(bouPumBuf.ports[1], storageBuf.fluidportBottom2) annotation (Line(
        points={{-10,0},{-10,13.78},{-12.825,13.78}}, color={0,127,255}));
>>>>>>> main
end TwoStoDetailedIndirectLoading;
