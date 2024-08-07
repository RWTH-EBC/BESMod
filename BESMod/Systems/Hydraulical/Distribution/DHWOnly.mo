within BESMod.Systems.Hydraulical.Distribution;
model DHWOnly "only loads DHW"
  extends BaseClasses.PartialDistribution(
    final VStoDHW=0,
    final fFullSto=0,
    final dpDHW_nominal=0,
    final QDHWStoLoss_flow=0,
    final designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage,
    nParallelDem=1,
    final dpDem_nominal=fill(0, nParallelDem),
    final dpSup_nominal=fill(0, nParallelSup),
    final dTTraDHW_nominal=0,
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final f_design=fill(1, nParallelDem),
    final dTLoss_nominal=fill(0, nParallelDem),
    final m_flow_nominal=mSup_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    redeclare package MediumGen = Medium,
    redeclare package MediumDHW = Medium,
    final dTTra_nominal=fill(0, nParallelDem),
    final nParallelSup=1);
  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_nominal=m_flow_design[1],
    final dp_nominal=dpDem_nominal[1] + dp_nominal[1],
    final addPowerToMedium=parPum.addPowerToMedium,
    final tau=parPum.tau,
    final use_inputFilter=parPum.use_inputFilter,
    final riseTime=parPum.riseTimeInpFilter,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-70,40})));
  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1) "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-10})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPum
    "Parameters for pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-76,4},{-62,16}})));
  Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-70})));
equation
  connect(portDHW_out, portGen_in[1]) annotation (Line(points={{100,-22},{2,-22},
          {2,80},{-100,80}}, color={0,127,255}));
  connect(portBui_out, portBui_in) annotation (Line(points={{100,80},{84,80},{
          84,40},{100,40}}, color={0,127,255}));
  connect(bouPum.ports[1],pump. port_a)
    annotation (Line(points={{-50,0},{-50,40},{-60,40}},  color={0,127,255}));
  connect(portDHW_in, pump.port_a) annotation (Line(points={{100,-82},{100,-36},
          {-26,-36},{-26,40},{-60,40}}, color={0,127,255}));
  connect(pump.port_b, portGen_out[1])
    annotation (Line(points={{-80,40},{-100,40}}, color={0,127,255}));
  connect(pump.y, sigBusDistr.uPump) annotation (Line(points={{-70,52},{-70,101},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pump.P, realToElecCon.PEleLoa) annotation (Line(points={{-81,49},{-86,
          49},{-86,-66},{18,-66}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{40.2,-69.8},{50,-69.8},{50,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
end DHWOnly;
