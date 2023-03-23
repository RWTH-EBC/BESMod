within BESMod.Systems.Hydraulical.Transfer;
model PressurLoss
  "No heat tranfser to building and pressur loss in supply. (test for FMU-interface)"
  extends BaseClasses.PartialTransfer(
    dp_nominal=fill(0, nParallelDem),
    dTTra_nominal=fill(0, nParallelDem));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  IBPSA.Fluid.FixedResistances.PressureDrop res[nParallelDem](
    redeclare package Medium = Medium,
    each final dp_nominal=10000,
    final m_flow_nominal=m_flow_nominal) "Hydraulic resistance of supply"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,40})));
  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad[nParallelDem](
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final nEle=radParameters.nEle,
    each final fraRad=radParameters.fraRad,
    final Q_flow_nominal=Q_flow_nominal .* f_design,
    final T_a_nominal=TTra_nominal,
    final T_b_nominal=TTra_nominal - dTTra_nominal,
    final TAir_nominal=TDem_nominal,
    final TRad_nominal=TDem_nominal,
    each final n=radParameters.n,
    each final deltaM=0.3,
    each final dp_nominal=0,
    redeclare package Medium = Medium,
    each final T_start=T_start) "Radiator" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={6,2})));
  replaceable parameter RecordsCollection.RadiatorTransferData
    radParameters annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-78,-94},{-58,-74}})));
  Modelica.Fluid.Sensors.Pressure p_in[nParallelSup](
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-94,68},{-74,88}})));
  Modelica.Fluid.Sensors.Temperature T_in[nParallelSup](
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-66,66},{-46,86}})));
  Modelica.Fluid.Sensors.Pressure p_in1[nParallelSup](
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-24,54},{-4,74}})));
  Modelica.Fluid.Sensors.Pressure p_in2[nParallelSup](
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-54,-24},{-34,-4}})));
  Modelica.Fluid.Sensors.Temperature T_in1[nParallelSup](
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-42,8},{-22,28}})));
  Modelica.Fluid.Sensors.Temperature T_in2[nParallelSup](
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{24,-28},{44,-8}})));
equation
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{60,-70},{72,-70},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(portTra_in, res.port_a) annotation (Line(points={{-100,38},{-98,38},{-98,
          40},{-60,40}}, color={0,127,255}));
  connect(res.port_b, rad.port_a)
    annotation (Line(points={{-40,40},{6,40},{6,12}}, color={0,127,255}));
  connect(rad.port_b, portTra_out) annotation (Line(points={{6,-8},{4,-8},{4,-42},
          {-100,-42}}, color={0,127,255}));
  connect(rad.heatPortCon, heatPortCon) annotation (Line(points={{13.2,4},{86,4},
          {86,40},{100,40}}, color={191,0,0}));
  connect(rad.heatPortRad, heatPortRad) annotation (Line(points={{13.2,-4.44089e-16},
          {86,-4.44089e-16},{86,-40},{100,-40}}, color={191,0,0}));
  connect(p_in.port, portTra_in)
    annotation (Line(points={{-84,68},{-84,38},{-100,38}}, color={0,127,255}));
  connect(T_in.port, portTra_in) annotation (Line(points={{-56,66},{-56,54},{-84,
          54},{-84,38},{-100,38}}, color={0,127,255}));
  connect(p_in1.port, res.port_b)
    annotation (Line(points={{-14,54},{-14,40},{-40,40}}, color={0,127,255}));
  connect(p_in2.port, rad.port_b) annotation (Line(points={{-44,-24},{-44,-26},{
          6,-26},{6,-8}}, color={0,127,255}));
  connect(T_in1.port, rad.port_a) annotation (Line(points={{-32,8},{-32,2},{-10,
          2},{-10,12},{6,12}}, color={0,127,255}));
  connect(T_in2.port, rad.port_b) annotation (Line(points={{34,-28},{34,-30},{6,
          -30},{6,-8}}, color={0,127,255}));
  connect(p_in.p, outBusTra.p_in) annotation (Line(points={{-73,78},{-73,80},{-68,
          80},{-68,72},{-70,72},{-70,-70},{0,-70},{0,-104}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(T_in.T, outBusTra.T_in) annotation (Line(points={{-49,76},{-30,76},{-30,
          32},{-16,32},{-16,-68},{0,-68},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(p_in1.p, outBusTra.p_m) annotation (Line(points={{-3,64},{22,64},{22,-4},
          {48,-4},{48,-56},{0,-56},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(T_in1.T, outBusTra.T_m) annotation (Line(points={{-25,18},{-18,18},{-18,
          -88},{0,-88},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(p_in2.p, outBusTra.p_out) annotation (Line(points={{-33,-14},{-12,-14},
          {-12,-66},{0,-66},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(T_in2.T, outBusTra.T_out) annotation (Line(points={{41,-18},{46,-18},{
          46,-54},{0,-54},{0,-104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end PressurLoss;
