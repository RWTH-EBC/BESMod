within BESMod.Systems.Hydraulical.Transfer;
model UFHTransferSystemPressureBasedNormBased
  extends
    BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialWithPipingLosses(
      dp_design=val.dpFixed_nominal .+ val.dpValve_nominal, nHeaTra=1.1);


  final parameter Modelica.Units.SI.PressureDifference dpFixedTotal_nominal[nParallelDem] = dpPipSca_design.+ dpUFH_design;

  parameter Boolean use_preRelVal=true "=false to disable pressure relief valve"
    annotation(Dialog(group="Component choices"));
  parameter Real perPreRelValOpens=0.99
    "Percentage of nominal pressure difference at which the pressure relief valve starts to open"
      annotation(Dialog(group="Component choices", enable=use_preRelVal));


  // Valves
  parameter Real valveAutho[nParallelDem](unit="1")=fill(0.5, nParallelDem)
    "Assumed valve authority (typical value: 0.5)"
     annotation(Dialog(group="Thermostatic Valve"));
  parameter Boolean use_hydrBalAutom = true
    "Use automatic hydraluic balancing to set dpFixed_nominal in valve"
    annotation(Dialog(group="Thermostatic Valve"));
  parameter Real leakageOpening = 0.0001
    "may be useful for simulation stability. Always check the influence it has on your results"
    annotation(Dialog(group="Thermostatic Valve"));

  final parameter Modelica.Units.SI.PressureDifference dpUFH_design[nParallelDem]=ufh.pressureDrop.tubeLength.*ufh.pressureDrop.m.*m_flow_design.^ufh.pressureDrop.n
    "Pressure drop as calculated in UFH model";
  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.UFHData UFHParameters
    constrainedby BESMod.Systems.Hydraulical.Transfer.RecordsCollection.UFHData(
                                            nZones=nParallelDem, area=AZone)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{82,82},
            {96,96}})));

  parameter Integer dis=5 "Number of Discreatisation Layers"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.Volume volDis(displayUnit="l")=0.002
    "Volume of water in distributors"
    annotation (Dialog(group="Volume"));

  BESMod.Systems.Hydraulical.Components.UFH.PanelHeating_NormBased ufh[
    nParallelDem](
    redeclare package Medium = Medium,
    final floorHeatingType=floorHeatingType,
    each final dis=dis,
    final A=UFHParameters.area,
    each final T0=T_start,
    each calcMethod=AixLib.ThermalZones.HighOrder.Components.Types.CalcMethodConvectiveHeatTransferInsideSurface.ASHRAE140_2017,
    each panelHeatingSegment(each fixedInitial=energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial))
    "Underfloor heating" annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=270,
        origin={10,0})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemp[nParallelDem](
      each final T=UFHParameters.T_floor) "Fixed floor temperature" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen[nParallelDem]
    "Heat flow sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-10})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo[nParallelDem](
      each final Q_flow=0) "Fixed heat flow rate of 0 W" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-92,-20})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap[nParallelDem](
      each T(start=T_start, fixed=energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial),
      each final C=100) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,4})));

  BESMod.Utilities.KPIs.EnergyKPICalculator integralKPICalculator[nParallelDem]
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{32,-108},{52,-88}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpe[nParallelDem] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,70})));
  Modelica.Blocks.Sources.RealExpression senTRet[nParallelSup](final y(
      each final unit="K",
      each displayUnit="degC") = Medium.temperature(Medium.setState_phX(
      portTra_out.p,
      actualStream(portTra_out.h_outflow),
      inStream(portTra_out.Xi_outflow)))) "Real expression for return temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-74})));
  Modelica.Blocks.Sources.RealExpression senTSup[nParallelSup](final y(
      each final unit="K",
      each displayUnit="degC") = Medium.temperature(Medium.setState_phX(
      portTra_in.p,
      inStream(portTra_in.h_outflow),
      inStream(portTra_in.Xi_outflow)))) "Real expression for supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-54})));

  IBPSA.Fluid.Actuators.Valves.TwoWayLinear val[nParallelDem](
    redeclare package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design,
    each final show_T=show_T,
    each final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=valveAutho .* dpFixedTotal_nominal ./ (1 .-
        valveAutho),
    each final use_strokeTime=false,
    final dpFixed_nominal=if use_hydrBalAutom then fill(max(
        dpFixedTotal_nominal), nParallelDem) else dpFixedTotal_nominal,
    each final l=leakageOpening,
    dp(start=val.dpFixed_nominal .+ val.dpValve_nominal))
                                        annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=270,
        origin={2,41})));
  IBPSA.Fluid.MixingVolumes.MixingVolume volSup(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=mSup_flow_design[1],
    final m_flow_small=1E-4*abs(sum(m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    V(displayUnit="l") = volDis/2,
    final use_C_flow=false,
    nPorts=2)                    "Volume of supply pipes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,66})));
  IBPSA.Fluid.MixingVolumes.MixingVolume volRet(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final mSenFac=1,
    final m_flow_nominal=mSup_flow_design[1],
    final m_flow_small=1E-4*abs(sum(m_flow_nominal)),
    final allowFlowReversal=allowFlowReversal,
    V(displayUnit="l") = volDis/2,
    final use_C_flow=false,
    nPorts=2)                "Volume of return pipes" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-32})));
  BESMod.Systems.Hydraulical.Distribution.Components.Valves.PressureReliefValve
                                                     pressureReliefValve(
    redeclare final package Medium = Medium,
    m_flow_nominal=mSup_flow_design[1],
    final dpFullOpen_nominal=dpSup_design[1],
    final dpThreshold_nominal=perPreRelValOpens*dpSup_design[1],
    final facDpValve_nominal=valveAutho[1],
    final l=leakageOpening,
    dpValve_nominal(displayUnit="Pa"))
                            if use_preRelVal annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-124,0})));
protected
  parameter
    BESMod.Systems.Hydraulical.Components.UFH.ActiveWallBaseDataDefinition
    floorHeatingType[nParallelDem]={
      BESMod.Systems.Hydraulical.Components.UFH.ActiveWallBaseDataDefinition(
      Temp_nom={TTra_nominal[i], TTra_nominal[i] - dTTra_nominal[i],TDem_nominal[i]},
      q_dot_nom=Q_flow_design[i] * f_design[i]/UFHParameters.area[i],
      k_isolation=UFHParameters.k_top[i] + UFHParameters.k_down[i],
      k_top=UFHParameters.k_top[i],
      k_down=UFHParameters.k_down[i],
      VolumeWaterPerMeter=0,
      eps=0.9,
      C_ActivatedElement=UFHParameters.C_ActivatedElement[i],
      c_top_ratio=UFHParameters.c_top_ratio[i],
      PressureDropExponent=UFHParameters.dpExp,
      PressureDropCoefficient=UFHParameters.dpCoe,
      diameter=UFHParameters.diameter) for i in 1:nParallelDem};

equation

  for i in 1:nParallelDem loop
  if UFHParameters.is_groundFloor[i] then
      connect(fixHeaFlo[i].port, heaCap[i].port) annotation (Line(points={{-82,
              -20},{-64,-20},{-64,-6}}, color={191,0,0}));
      connect(fixTemp[i].port, heaFloSen[i].port_a) annotation (Line(
          points={{-80,10},{-80,-6},{-50,-6},{-50,-10},{-40,-10}},
          color={191,0,0},
          pattern=LinePattern.Dash));
  else
      connect(fixHeaFlo[i].port, heaFloSen[i].port_a) annotation (Line(
          points={{-82,-20},{-76,-20},{-76,-6},{-50,-6},{-50,-10},{-40,-10}},
          color={191,0,0},
          pattern=LinePattern.Dash));
      connect(fixTemp[i].port, heaCap[i].port) annotation (Line(
          points={{-80,10},{-80,12},{-76,12},{-76,-6},{-64,-6}},
          color={191,0,0},
          pattern=LinePattern.Dash));
  end if;
  end for;

  connect(ufh.thermConv, heatPortCon) annotation (Line(points={{21.6667,-2.8},{
          100,-2.8},{100,26},{86,26},{86,40},{100,40}},
                                             color={191,0,0}));
  connect(ufh.starRad, heatPortRad) annotation (Line(points={{21,2.4},{102,2.4},
          {102,-26},{86,-26},{86,-40},{100,-40}},                  color={0,0,0}));

  connect(heaFloSen.port_b, ufh.ThermDown) annotation (Line(points={{-20,-10},{-12,
          -10},{-12,-1.6},{-1,-1.6}},      color={191,0,0}));

  connect(heaFloSen.Q_flow, integralKPICalculator.u) annotation (Line(points={{
          -30,-21},{-30,-56},{-48,-56},{-48,-70},{-41.8,-70}}, color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{52,-98},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(integralKPICalculator.KPI, outBusTra.QUFH_flow) annotation (Line(
        points={{-17.8,-70},{0,-70},{0,-104}},   color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrOpe.u, traControlBus.opening) annotation (Line(points={{
          2.22045e-15,82},{2.22045e-15,91},{0,91},{0,100}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrOpe.y, outBusTra.opening) annotation (Line(points={{
          -1.9984e-15,59},{38,59},{38,-82},{0,-82},{0,-104}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTSup.y, outBusTra.TSup) annotation (Line(points={{-49,-54},{0,-54},
          {0,-104}},                   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTRet.y, outBusTra.TRet) annotation (Line(points={{-49,-74},{-50,
          -74},{-50,-90},{0,-90},{0,-104}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(res.port_b, val.port_a) annotation (Line(points={{-20,40},{-14,40},{-14,
          51},{2,51}}, color={0,127,255}));
  connect(val.port_b, ufh.port_a) annotation (Line(points={{2,31},{2,26},{8.33333,
          26},{8.33333,20}}, color={0,127,255}));
  connect(reaPasThrOpe.y, val.y) annotation (Line(points={{-1.9984e-15,59},{-1.9984e-15,
          58},{20,58},{20,41},{15.2,41}}, color={0,0,127}));
  connect(resMaiLin[1].port_b, volSup.ports[1]) annotation (Line(points={{-60,40},
          {-56,40},{-56,52},{-64,52},{-64,76},{-49,76}}, color={0,127,255}));
  for i in 1:nParallelDem loop
    connect(volSup.ports[i+1], res[i].port_a) annotation (Line(points={{-50,76},{-50,
            78},{-64,78},{-64,52},{-56,52},{-56,40},{-40,40}}, color={0,127,255}));
    connect(volRet.ports[i+1], ufh[i].port_b) annotation (Line(points={{-50,-42},
            {-50,-38},{8.33333,-38},{8.33333,-20}},
                                             color={0,127,255}));
  end for;


  connect(portTra_out[1], volRet.ports[1]) annotation (Line(points={{-100,-42},{
          -74,-42},{-74,-38},{-64,-38},{-64,-42},{-51,-42}}, color={0,127,255}));

  connect(portTra_in[1], pressureReliefValve.port_a) annotation (Line(points={{-100,
          38},{-86,38},{-86,24},{-124,24},{-124,10}}, color={0,127,255}));
  connect(pressureReliefValve.port_b, portTra_out[1]) annotation (Line(points={{
          -124,-10},{-120,-10},{-120,-58},{-86,-58},{-86,-42},{-100,-42}},
        color={0,127,255}));
  annotation (Documentation(info="<html>
  <p>
  According to https://www.energie-lexikon.info/heizkoerperexponent.html, 
  the heating transfer exponent of underfloor heating systems is between 1 and 1.1.
  In the Recknagel, a value of 1.1 is speficied.
  </p>
<p>TODO: In the test, the heat flow rate does not match design conditions.</p>
</html>"));
end UFHTransferSystemPressureBasedNormBased;
