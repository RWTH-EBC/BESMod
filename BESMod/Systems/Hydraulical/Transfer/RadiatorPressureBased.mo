within BESMod.Systems.Hydraulical.Transfer;
model RadiatorPressureBased "Pressure Based transfer system"
  // Abui =1 and hBui =1 to avaoid warnings, will be overwritten anyway
  extends BaseClasses.PartialTransfer(
    nHeaTra=parRad.n,
    ABui=1,
    hBui=1,
    final dp_nominal=parTra.dp_nominal,
    final nParallelSup=1,
    Q_flow_design={if use_oldRad_design[i] then QOld_flow_design[i] else Q_flow_nominal[i] for i in 1:nParallelDem},
    TTra_design={if use_oldRad_design[i] then TTraOld_design[i] else TTra_nominal[i] for i in 1:nParallelDem});

  parameter Boolean use_oldRad_design[nParallelDem]=fill(false, nParallelDem)
    "If true, radiator design of the building with no retrofit (old state) is used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Boolean use_preRelVal=false "=false to disable pressure relief valve"
    annotation(Dialog(group="Component choices"));
  parameter Real perPreRelValOpens=0.99
    "Percentage of nominal pressure difference at which the pressure relief valve starts to open"
      annotation(Dialog(group="Component choices", enable=use_preRelVal));
  replaceable parameter RecordsCollection.TransferDataBaseDefinition parTra
    constrainedby RecordsCollection.TransferDataBaseDefinition(
    final Q_flow_nominal=Q_flow_design .* f_design,
    final nZones=nParallelDem,
    final AFloor=ABui,
    final heiBui=hBui,
    mRad_flow_nominal=m_flow_nominal) "Transfer parameters" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-62,-98},{-42,-78}})));

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    parPum annotation (Dialog(group="Component data"),
      choicesAllMatching=true, Placement(transformation(extent={{-98,78},
            {-72,100}})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
    parRad
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{-100,-98},{-80,-78}})));
  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final nEle=parRad.nEle,
    each final fraRad=parRad.fraRad,
    final Q_flow_nominal=Q_flow_design .* f_design,
    final T_a_nominal=TTra_design,
    final T_b_nominal=TTra_design .- dTTra_design,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=parRad.n,
    each final deltaM=0.3,
    each final dp_nominal=0,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator" annotation (Placement(transformation(
        extent={{11,11},{-11,-11}},
        rotation=90,
        origin={-13,-25})));

  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=parTra.dpHeaDistr_nominal+parTra.dpRad_nominal[1],
    final m_flow_nominal=m_flow_nominal)
    "Hydraulic resistance of supply and radiator to set dp allways to m_flow_nominal"
    annotation (Placement(transformation(
        extent={{-12.5,-13.5},{12.5,13.5}},
        rotation=0,
        origin={-34.5,37.5})));
  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val[nParallelDem](
    redeclare package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=parTra.dpHeaSysValve_nominal,
    each final use_inputFilter=false,
    final dpFixed_nominal=parTra.dpHeaSysPreValve_nominal,
    each final l=parTra.leakageOpening) annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=270,
        origin={-12,1})));

  IBPSA.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=sum(rad.m_flow_nominal),
    final m_flow_small=1E-4*abs(sum(rad.m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    final V(displayUnit="l") = parTra.vol,
    final use_C_flow=false,
    nPorts=1 + nParallelDem) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-58,18})));
  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_nominal=sum(m_flow_nominal),
    final dp_nominal=parTra.dpPumpHeaCir_nominal + dpSup_nominal[1],
    final addPowerToMedium=parPum.addPowerToMedium,
    final tau=parPum.tau,
    final use_inputFilter=parPum.use_inputFilter,
    final riseTime=parPum.riseTimeInpFilter,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,38})));

  Modelica.Blocks.Sources.Constant m_flow1(k=1)   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-48,68})));

  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{34,-94},{54,-74}})));
  Distribution.Components.Valves.PressureReliefValve pressureReliefValve(
    redeclare final package Medium = Medium,
    m_flow_nominal=mSup_flow_nominal[1],
    final dpFullOpen_nominal=dp_nominal[1],
    final dpThreshold_nominal=perPreRelValOpens*dp_nominal[1],
    final facDpValve_nominal=parTra.valveAutho[1],
    final l=parTra.leakageOpening) if use_preRelVal annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-90,-10})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpe[nParallelDem] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,70})));
  Modelica.Blocks.Sources.RealExpression senTRet[nParallelSup](final y(
      each final unit="K",
      each displayUnit="degC") = Medium.temperature(Medium.setState_phX(
      portTra_out.p,
      inStream(portTra_out.h_outflow),
      inStream(portTra_out.Xi_outflow)))) "Real expression for return temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-74})));
  Modelica.Blocks.Sources.RealExpression senTSup[nParallelSup](final y(
      each final unit="K",
      each displayUnit="degC") = Medium.temperature(Medium.setState_phX(
      portTra_in.p,
      inStream(portTra_in.h_outflow),
      inStream(portTra_in.Xi_outflow)))) "Real expression for supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-54})));
equation
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{-5.08,-27.2},
          {40,-27.2},{40,-40},{100,-40}}, color={191,0,0}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{-5.08,-22.8},
          {-5.08,-26},{40,-26},{40,40},{100,40}},  color={191,0,0}));

  for i in 1:nParallelDem loop
    connect(rad[i].port_b, portTra_out[1]) annotation (Line(points={{-13,-36},{-13,
            -42},{-100,-42}},
                       color={0,127,255}));
    connect(res[i].port_a, vol.ports[i + 1]) annotation (Line(points={{-47,37.5},
            {-56,37.5},{-56,28},{-58,28}}, color={0,127,255}));
  end for;

  connect(val.port_b, rad.port_a) annotation (Line(points={{-12,-9},{-12,-13.5},
          {-13,-13.5},{-13,-14}}, color={0,127,255}));
  connect(res.port_b, val.port_a) annotation (Line(points={{-22,37.5},{-12,37.5},
          {-12,11}}, color={0,127,255}));
  connect(portTra_in[1],pump.port_a)
    annotation (Line(points={{-100,38},{-84,38}}, color={0,127,255}));
  connect(pump.port_b, vol.ports[1]) annotation (Line(points={{-64,38},{-62,38},
          {-62,28},{-58,28}}, color={0,127,255}));

  connect(m_flow1.y,pump. y)
    annotation (Line(points={{-59,68},{-74,68},{-74,50}}, color={0,0,127}));
  connect(val.y, traControlBus.opening) annotation (Line(points={{1.2,1},{8,1},{
          8,74},{0,74},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{54.2,-83.8},{54.2,-84},{72,-84},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(realToElecCon.PEleLoa, pump.P) annotation (Line(points={{32,-80},{
          22,-80},{22,47},{-63,47}}, color={0,0,127}));
  connect(pressureReliefValve.port_b, portTra_out[1]) annotation (Line(points={{-90,-20},
          {-90,-42},{-100,-42}},           color={0,127,255}));
  connect(pump.port_b, pressureReliefValve.port_a) annotation (Line(points={{-64,38},
          {-60,38},{-60,30},{-90,30},{-90,0}},         color={0,127,255}));
  connect(reaPasThrOpe.u, traControlBus.opening) annotation (Line(points={{30,
          82},{30,94},{0,94},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrOpe.y, outBusTra.opening) annotation (Line(points={{30,59},{
          30,-32},{4,-32},{4,-90},{0,-90},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
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
<h4>Information</h4>
<p>
Pressure-based transfer system with radiators according to EN442-2. 
The model can be used for single or multiple radiator circuits 
with thermostatic radiator valves. 
A pump circulates the heating water through the radiators. 
Optionally, a pressure relief valve can be used to allow mass flow 
when all valves are closed.
</p>

<h4>Important Parameters</h4>
<ul>
<li><code>use_preRelVal</code>: Enable/disable pressure relief valve</li>
<li><code>perPreRelValOpens</code>: Opening threshold of relief valve as percentage of nominal pressure</li>
<li><code>parTra</code>: Transfer system parameters (pressures drops, valve characteristics)</li>
<li><code>parPum</code>: Pump parameters</li>
<li><code>parRad</code>: Radiator parameters according to EN442-2 (number of elements, radiative fraction)</li>
<li><code>use_oldRad_design</code>: Use radiator design for non-retrofitted state</li>
</ul>

</html>"));
end RadiatorPressureBased;
