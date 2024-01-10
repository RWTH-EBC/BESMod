within BESMod.Systems.Hydraulical.Transfer;
model UFHTransferSystem
  extends BaseClasses.PartialTransfer(
    nHeaTra=1,
    final nParallelSup=1,
    final dp_nominal=parTra.dp_nominal);

  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=parTra.dpHeaDistr_nominal,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,50})));

  Modelica.Blocks.Math.Gain gain[nParallelDem](k=m_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,80})));
  BESMod.Systems.Hydraulical.Components.UFH.PanelHeating ufh[nParallelDem](
    redeclare package Medium = Medium,
    final floorHeatingType=floorHeatingType,
    each final dis=5,
    final A=UFHParameters.area,
    each final T0=T_start,
    each calcMethod=1) "Underfloor heating" annotation (Placement(
        transformation(
        extent={{-29.5,-10.5},{29.5,10.5}},
        rotation=270,
        origin={9.5,9.5})));

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
      each final C=100) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,4})));

  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.UFHData UFHParameters
    constrainedby RecordsCollection.UFHData(nZones=nParallelDem, area=AZone)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{78,78},
            {98,98}})));

  Utilities.KPIs.EnergyKPICalculator integralKPICalculator[nParallelDem]
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  IBPSA.Fluid.Movers.Preconfigured.FlowControlled_m_flow pumpFix_m_flow[nParallelDem](
    redeclare package Medium = Medium,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=1E-4*abs(m_flow_nominal),
    each final show_T=show_T,
    final dp_nominal=dp_nominal,
    each final addPowerToMedium=parPum.addPowerToMedium,
    each final tau=parPum.tau,
    each final use_inputFilter=false,
    final m_flow_start=m_flow_nominal)             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,50})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    parPum annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,78},
            {-78,98}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{32,-108},{52,-88}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpe[nParallelDem] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,70})));
  replaceable parameter RecordsCollection.TransferDataBaseDefinition parTra
    constrainedby RecordsCollection.TransferDataBaseDefinition(
    final Q_flow_nominal=Q_flow_nominal .* f_design,
    final nZones=nParallelDem,
    final AFloor=ABui,
    final heiBui=hBui,
    mRad_flow_nominal=m_flow_nominal,
    mHeaCir_flow_nominal=mSup_flow_nominal[1]) "Transfer parameters" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-100,-98},{-80,-78}})));
protected
  parameter
    BESMod.Systems.Hydraulical.Components.UFH.ActiveWallBaseDataDefinition
    floorHeatingType[nParallelDem]={
      BESMod.Systems.Hydraulical.Components.UFH.ActiveWallBaseDataDefinition(
      Temp_nom=Modelica.Units.Conversions.from_degC({TTra_nominal[i],
        TTra_nominal[i] - dTTra_nominal[i],TDem_nominal[i]}),
      q_dot_nom=Q_flow_nominal[i]/UFHParameters.area[i],
      k_isolation=UFHParameters.k_top[i] + UFHParameters.k_down[i],
      k_top=UFHParameters.k_top[i],
      k_down=UFHParameters.k_down[i],
      VolumeWaterPerMeter=0,
      eps=0.9,
      C_ActivatedElement=UFHParameters.C_ActivatedElement[i],
      c_top_ratio=UFHParameters.c_top_ratio[i],
      PressureDropExponent=0,
      PressureDropCoefficient=0,
      diameter=UFHParameters.diameter) for i in 1:nParallelDem};

equation

  for i in 1:nParallelDem loop
    connect(res[i].port_a, portTra_in[1]) annotation (Line(points={{-80,50},{
            -86,50},{-86,38},{-100,38}}, color={0,127,255}));
    connect(ufh[i].port_b, portTra_out[1]) annotation (Line(points={{7.75,-20},
            {6,-20},{6,-42},{-100,-42}}, color={0,127,255}));
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

  connect(ufh.thermConv, heatPortCon) annotation (Line(points={{21.75,5.37},{
          21.75,4},{86,4},{86,40},{100,40}}, color={191,0,0}));
  connect(ufh.starRad, heatPortRad) annotation (Line(points={{21.05,13.04},{
          21.05,12},{98,12},{98,-26},{86,-26},{86,-40},{100,-40}}, color={0,0,0}));

  connect(heaFloSen.port_b, ufh.ThermDown) annotation (Line(points={{-20,-10},{
          -8,-10},{-8,7.14},{-2.05,7.14}}, color={191,0,0}));

  connect(gain.u, traControlBus.opening) annotation (Line(points={{-30,92},{-30,
          100},{-14,100},{-14,86},{0,86},{0,100}},
                         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaFloSen.Q_flow, integralKPICalculator.u) annotation (Line(points={{
          -30,-21},{-30,-56},{-48,-56},{-48,-70},{-41.8,-70}}, color={0,0,127}));
  connect(res.port_b, pumpFix_m_flow.port_a)
    annotation (Line(points={{-60,50},{-40,50}}, color={0,127,255}));
  connect(pumpFix_m_flow.port_b, ufh.port_a) annotation (Line(points={{-20,50},
          {7.75,50},{7.75,39}}, color={0,127,255}));
  connect(gain.y, pumpFix_m_flow.m_flow_in) annotation (Line(points={{-30,69},{
          -30,62}},                 color={0,0,127}));
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
  annotation (Documentation(info="<html>
<p>According to https://www.energie-lexikon.info/heizkoerperexponent.html, the heating transfer exponent of underfloor heating systems is between 1 and 1.1.</p>
</html>"));
end UFHTransferSystem;
