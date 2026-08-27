within BESMod.Utilities.TimeConstantEstimation.BaseClasses;
model CustomRadiator "Custom radiator with radiative fractions"
  // Abui =1 and hBui =1 to avaoid warnings, will be overwritten anyway
  extends BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialWithPipingLosses(
    nHeaTra=parRad.n,
    ABui=1,
    hBui=1,
    final dp_design=dpPipSca_design .+ val.dpFixed_nominal .+ val.dpValve_nominal .+ rad.dp_nominal,
    Q_flow_design={if use_oldRad_design[i] then QOld_flow_design[i] else Q_flow_nominal[i] for i in 1:nParallelDem},
    TTra_design={if use_oldRad_design[i] then TTraOld_design[i] else TTra_nominal[i] for i in 1:nParallelDem});
  parameter Boolean use_dynamicFraRad=true;
  parameter Boolean use_oldRad_design[nParallelDem]={abs(QOld_flow_design[i]-Q_flow_nominal[i])>1 for i in 1:nParallelDem}
    "If true, radiator design of the building with no retrofit (old state) is used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Boolean use_preRelVal=false "=false to disable pressure relief valve"
    annotation(Dialog(group="Component choices"));
  parameter Real perPreRelValOpens=0.99
    "Percentage of nominal pressure difference at which the pressure relief valve starts to open"
      annotation(Dialog(group="Component choices", enable=use_preRelVal));

  // Valves
  parameter Real valveAutho[nParallelDem](each min=0.2, each max=0.8, each unit="1")=
    fill(0.5, nParallelDem)
    "Assumed valve authority (typical value: 0.5)"
     annotation(Dialog(group="Thermostatic Valve"));
  parameter Boolean use_hydrBalAutom = true
    "Use automatic hydraluic balancing to set dpFixed_nominal in valve"
    annotation(Dialog(group="Thermostatic Valve"));
  parameter Real leakageOpening = 0.0001
    "may be useful for simulation stability. Always check the influence it has on your results"
    annotation(Dialog(group="Thermostatic Valve"));

  // Volume
  parameter BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType traType=
    BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.SteelRadiator
    "Heat transfer system type"
      annotation(Dialog(group="Volume"));
  parameter Modelica.Units.SI.Volume vol=
      BESMod.Systems.Hydraulical.Transfer.Functions.GetAverageVolumeOfWater(sum(
      Q_flow_nominal), traType)
    "Volume of water in whole heat distribution and transfer system"
    annotation (Dialog(group="Volume"));
  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
    parRad
    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{-96,82},{-82,96}})));

  BESMod.Utilities.TimeConstantEstimation.BaseClasses.RadiatorEN442_2 rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final nEle=parRad.nEle,
    each fraRad_nominal=parRad.fraRad,
    each use_dynamicFraRad=use_dynamicFraRad,
    final Q_flow_nominal=Q_flow_design .* f_design,
    final T_a_nominal=TTra_design,
    final T_b_nominal=TTra_design .- dTTra_design,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=parRad.n,
    each final deltaM=0.3,
    final dp_nominal=dpPipSca_design*parRad.perPreLosRad,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-10,-30})));

  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val[nParallelDem](
    redeclare package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design,
    each final show_T=show_T,
    each final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=valveAutho .* (val.dpFixed_nominal .+ rad.dp_nominal) ./ (1 .- valveAutho),
    each final use_strokeTime=false,
    final dpFixed_nominal=if use_hydrBalAutom then max(dpPipSca_design .+ rad.dp_nominal) .- (dpPipSca_design .+ rad.dp_nominal)
       else fill(0, nParallelDem),
    each final l=leakageOpening)        annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=270,
        origin={-10,9})));

  IBPSA.Fluid.MixingVolumes.MixingVolume volSup(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=mSup_flow_design[1],
    final m_flow_small=1E-4*abs(sum(rad.m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    final V(displayUnit="l") = vol/2,
    final use_C_flow=false,
    nPorts=nParallelDem + 1)     "Volume of supply pipes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-66,20})));

  BESMod.Utilities.Electrical.ZeroLoad             zeroLoad
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  BESMod.Systems.Hydraulical.Distribution.Components.Valves.PressureReliefValve pressureReliefValve(
    redeclare final package Medium = Medium,
    m_flow_nominal=mSup_flow_design[1],
    final dpFullOpen_nominal=dpSup_design[1],
    final dpThreshold_nominal=perPreRelValOpens*dpSup_design[1],
    final facDpValve_nominal=valveAutho[1],
    final l=leakageOpening) if use_preRelVal annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-90,-10})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpe[nParallelDem] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,70})));
  IBPSA.Fluid.MixingVolumes.MixingVolume volRet(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=mSup_flow_design[1],
    final m_flow_small=1E-4*abs(sum(rad.m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    final V(displayUnit="l") = vol/2,
    final use_C_flow=false,
    nPorts=nParallelDem + 1) "Volume of return pipes" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,-22})));
  Modelica.Blocks.Sources.RealExpression senTRet[nParallelSup](final y(
      each final unit="K",
      each displayUnit="degC") = Medium.temperature(Medium.setState_phX(
      portTra_out.p,
      actualStream(portTra_out.h_outflow),
      inStream(portTra_out.Xi_outflow)))) if not use_openModelica "Real expression for return temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-74})));
  Modelica.Blocks.Sources.RealExpression senTSup[nParallelSup](final y(
      each final unit="K",
      each displayUnit="degC") = Medium.temperature(Medium.setState_phX(
      portTra_in.p,
      inStream(portTra_in.h_outflow),
      inStream(portTra_in.Xi_outflow)))) if not use_openModelica "Real expression for supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-54})));
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{-2.8,-32},{40,
          -32},{40,-40},{100,-40}},       color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{-2.8,-28},{-2.8,
          -26},{40,-26},{40,40},{100,40}},         color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(rad[i].port_b, volRet.ports[i + 1]) annotation (Line(points={{-10,-40},
            {-62,-40},{-62,-32}},
                       color={0,127,255}));
    connect(res[i].port_a, volSup.ports[i + 1]) annotation (Line(points={{-60,40},
            {-64,40},{-64,30},{-66,30}},   color={0,127,255}));
  end for;

  connect(val.port_b, rad.port_a) annotation (Line(points={{-10,-1},{-10,-20}},
                                  color={0,127,255}));
  connect(res.port_b, val.port_a) annotation (Line(points={{-40,40},{-10,40},{-10,
          19}},      color={0,127,255}));

  connect(val.y, traControlBus.opening) annotation (Line(points={{3.2,9},{8,9},{
          8,74},{0,74},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{60,-70},{72,-70},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(pressureReliefValve.port_b, portTra_out[1]) annotation (Line(points={{-90,-20},
          {-90,-42},{-100,-42}},           color={0,127,255}));
  connect(reaPasThrOpe.u, traControlBus.opening) annotation (Line(points={{30,
          82},{30,94},{0,94},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrOpe.y, outBusTra.opening) annotation (Line(points={{30,59},{
          30,-90},{0,-90},{0,-104}},                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(volRet.ports[1], portTra_out[1]) annotation (Line(points={{-62,-32},{-62,
          -42},{-100,-42}}, color={0,127,255}));
  connect(pressureReliefValve.port_a, portTra_in[1])
    annotation (Line(points={{-90,0},{-90,38},{-100,38}}, color={0,127,255}));
  connect(volSup.ports[1], portTra_in[1]) annotation (Line(points={{-66,30},{-68,
          30},{-68,38},{-100,38}},
                              color={0,127,255}));
  connect(senTSup.y, outBusTra.TSup) annotation (Line(points={{-19,-54},{0,-54},
          {0,-104}},                   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTRet.y, outBusTra.TRet) annotation (Line(points={{-19,-74},{0,-74},
          {0,-104}},                   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>TODO: In the test with pressure relief valve, mass flow rates do not match</p>
</html>"));
end CustomRadiator;
