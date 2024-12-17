within BESMod.Systems.Hydraulical.Generation;
model ElectricalHeater "Only heat using an electric heater"
  extends BaseClasses.PartialGeneration(
    dp_design={hea.dp_nominal + resGen.dp_nominal},
    final dTLoss_nominal=fill(0, nParallelDem),    final nParallelDem=1);
  parameter Modelica.Units.SI.Length lengthPip=4 "Length of all pipes"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoe=4*facPerBend
    "Factor to take into account resistance of bendsm, fittings etc."
    annotation (Dialog(tab="Pressure losses"));
  AixLib.Fluid.HeatExchangers.HeatingRod hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final dp_nominal=parEleHea.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=Q_flow_nominal[1],
    final V=parEleHea.V_hr,
    final eta=parEleHea.eta)
    annotation (Placement(transformation(extent={{-16,-16},{16,16}},
        rotation=90,
        origin={-32,10})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.Generic
    parEleHea "Electric heater parameters" annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-62,-42},{-50,-30}})));

  Utilities.KPIs.EnergyKPICalculator KPIQEleHea(use_inpCon=false, y=hea.vol.heatPort.Q_flow)
    "Electric heater heat flow rate"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{32,-108},{52,-88}})));
  Utilities.KPIs.DeviceKPICalculator KPIEleHea(
    use_reaInp=true,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true) "Electric heater KPIs"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Modelica.Blocks.Sources.RealExpression reaExpTOut(y=hea.vol.T)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,70})));
  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameter
                                            resGen(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPip_design[1],
    final length=lengthPip,
    final ReC=ReC,
    final v_nominal=v_design[1],
    final roughness=roughness,
    final resCoe=resCoe)          "Pressure drop model depending on the configuration"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

equation

  connect(hea.Pel, outBusGen.PelHR) annotation (Line(points={{-41.6,27.6},{-41.6,
          49.6},{-72,49.6},{-72,-100},{0,-100}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{52.2,-97.8},{52.2,-96},{58,-96},{58,-86},{72,-86},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(realToElecCon.PEleLoa, hea.Pel) annotation (Line(points={{30,-94},{
          -80,-94},{-80,28},{-60,28},{-60,27.6},{-41.6,27.6}},
                                             color={0,0,127}));
  connect(KPIQEleHea.KPI, outBusGen.QEleHea_flow) annotation (Line(points={{-17.8,-70},
          {0,-70},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIEleHea.KPI, outBusGen.eleHea) annotation (Line(points={{-37.8,-90},{-14,
          -90},{-14,-86},{0,-86},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIEleHea.uRea, sigBusGen.uEleHea) annotation (Line(points={{-62.2,-90},{-76,
          -90},{-76,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hea.u, sigBusGen.uEleHea) annotation (Line(points={{-41.6,-9.2},{
          -41.6,-14},{-54,-14},{-54,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpTOut.y, sigBusGen.TGenOutMea) annotation (Line(points={{-19,70},{
          2,70},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hea.port_b, portGen_out[1]) annotation (Line(points={{-32,26},{-32,40},
          {20,40},{20,80},{100,80}}, color={0,127,255}));
  connect(resGen.port_b, portGen_in[1]) annotation (Line(points={{40,-10},{84,-10},
          {84,-2},{100,-2}}, color={0,127,255}));
  connect(resGen.port_a, hea.port_a) annotation (Line(points={{20,-10},{-32,-10},
          {-32,-6}},         color={0,127,255}));
end ElectricalHeater;
