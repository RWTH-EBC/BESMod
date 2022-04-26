within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndHeatingRod "Bivalent monoenergetic heat pump"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final dTLoss_nominal=fill(0, nParallelDem),
    dTTra_nominal={if TDem_nominal[i] > 273.15 + 55 then 10 elseif TDem_nominal[
        i] > 44.9 + 273.15 then 8 else 5 for i in 1:nParallelDem},
    dp_nominal={heatPump.dpCon_nominal + dpHeaRod_nominal},
      nParallelDem=1);
     parameter Boolean use_pressure=false "=true to use a pump which works on pressure difference";
   parameter Boolean use_heaRod=true "=false to disable the heating rod";
    replaceable model PerDataMainHP =
      AixLib.DataBase.HeatPump.PerformanceData.LookUpTable2D
    constrainedby
    AixLib.DataBase.HeatPump.PerformanceData.BaseClasses.PartialPerformanceData
    annotation (__Dymola_choicesAllMatching=true);
  parameter Modelica.Media.Interfaces.Types.Temperature TSoilConst=273.15 + 10
    "Constant soil temperature for ground source heat pumps";
  replaceable package Medium_eva = Modelica.Media.Interfaces.PartialMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition
    heatPumpParameters constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition(
        final QGen_flow_nominal=Q_flow_nominal[1],
        final TOda_nominal=TOda_nominal)
                       annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-90,4},{-72,22}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatingRodBaseDataDefinition
    heatingRodParameters annotation (choicesAllMatching=true, Placement(
        transformation(extent={{58,42},{70,54}})));

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (choicesAllMatching=true, Placement(transformation(extent={{4,-46},{18,-34}})));

  AixLib.Fluid.Interfaces.PassThroughMedium passThroughMediumHRBuf(redeclare
      package Medium = Medium, allowFlowReversal=allowFlowReversal)
    if not use_heaRod
    annotation (Placement(transformation(extent={{32,74},{44,86}})));

  BESMod.Components.Pumps.ArtificalPumpIsotermhal artificalPumpIsotermhal(
    redeclare package Medium = Medium,
    final p=p_start,
    final m_flow_nominal=m_flow_nominal[1]) if not
    use_pressure                         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,-50})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-16})));
  Modelica.Blocks.Sources.RealExpression dummyMassFlow(final y=if use_pressure
         then 1 else m_flow_nominal[1])
    annotation (Placement(transformation(extent={{84,-6},{64,14}})));
  Modelica.Blocks.Sources.RealExpression dummyZero annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={18,4})));
  Modelica.Blocks.MathBoolean.Or
                             or1(nu=3)
                                 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={46,14})));

  AixLib.Fluid.HeatPumps.HeatPump heatPump(
    redeclare package Medium_con = Medium,
    redeclare package Medium_eva = Medium_eva,
    final use_rev=false,
    final use_autoCalc=false,
    final Q_useNominal=0,
    final scalingFactor=heatPumpParameters.scalingFactor,
    final use_refIne=heatPumpParameters.use_refIne,
    final refIneFre_constant=heatPumpParameters.refIneFre_constant,
    final nthOrder=1,
    final useBusConnectorOnly=true,
    final mFlow_conNominal=m_flow_nominal[1],
    final VCon=heatPumpParameters.VCon,
    final dpCon_nominal=heatPumpParameters.dpCon_nominal,
    final use_conCap=false,
    final CCon=0,
    final GConOut=0,
    final GConIns=0,
    final mFlow_evaNominal=heatPumpParameters.mEva_flow_nominal,
    final VEva=heatPumpParameters.VEva,
    final dpEva_nominal=heatPumpParameters.dpEva_nominal,
    final use_evaCap=false,
    final CEva=0,
    final GEvaOut=0,
    final GEvaIns=0,
    final tauSenT=heatPumpParameters.TempSensorData.tau,
    final transferHeat=true,
    final allowFlowReversalEva=allowFlowReversal,
    final allowFlowReversalCon=allowFlowReversal,
    final tauHeaTraEva=heatPumpParameters.TempSensorData.tauHeaTra,
    final TAmbEva_nominal=heatPumpParameters.TempSensorData.TAmb,
    final tauHeaTraCon=heatPumpParameters.TempSensorData.tauHeaTra,
    final TAmbCon_nominal=heatPumpParameters.TempSensorData.TAmb,
    final pCon_start=p_start,
    final TCon_start=T_start,
    final pEva_start=Medium_eva.p_default,
    final TEva_start=Medium_eva.T_default,
    final massDynamics=massDynamics,
    final energyDynamics=energyDynamics,
    final show_TPort=show_T,
    redeclare model PerDataMainHP = PerDataMainHP,
    redeclare model PerDataRevHP =
        AixLib.DataBase.Chiller.PerformanceData.LookUpTable2D (final dataTable=
            AixLib.DataBase.Chiller.EN14511.Vitocal200AWO201()))
                                                 annotation (Placement(
        transformation(
        extent={{22,-27},{-22,27}},
        rotation=270,
        origin={-44,15})));

  IBPSA.Fluid.Sources.Boundary_ph bou_sinkAir(final nPorts=1, redeclare package
      Medium =         Medium_eva)                       annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-22})));
  IBPSA.Fluid.Sources.MassFlowSource_T bou_air(
    final m_flow=heatPumpParameters.mEva_flow_nominal,
    final use_T_in=true,
    redeclare package Medium = Medium_eva,
    final use_m_flow_in=false,
    final nPorts=1)
    annotation (Placement(transformation(extent={{-100,42},{-80,62}})));

  Modelica.Blocks.Logical.GreaterThreshold isOnHP(threshold=Modelica.Constants.eps)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={16,38})));

  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-124,56})));
  Modelica.Blocks.Sources.BooleanConstant
                                   AirOrSoil(k=heatPumpParameters.useAirSource)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-164,56})));
  Modelica.Blocks.Logical.GreaterThreshold isOnHR(threshold=Modelica.Constants.eps)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={40,36})));

  Utilities.KPIs.InputKPICalculator KPIWel(
    calc_singleOnTime=true,
    calc_integral=true,
    calc_movAve=false)
    annotation (Placement(transformation(extent={{-78,-106},{-66,-84}})));
  Utilities.KPIs.InputKPICalculator KPIWHRel(
    calc_singleOnTime=true,
    calc_integral=true,
    calc_movAve=false) if use_heaRod
    annotation (Placement(transformation(extent={{86,86},{98,108}})));

  Modelica.Blocks.Sources.BooleanConstant constRunPump247(final k=
        heatPumpParameters.use_refIne)
    annotation (Placement(transformation(
        extent={{-5,5},{5,-5}},
        rotation=180,
        origin={79,27})));
  IBPSA.Fluid.Movers.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData
      per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal[1],
      final dp_nominal=dpDem_nominal[1] + dp_nominal[1],
      final rho=rho,
      final V_flowCurve=pumpData.V_flowCurve,
      final dpCurve=pumpData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=pumpData.addPowerToMedium,
    final tau=pumpData.tau,
    final use_inputFilter=pumpData.use_inputFilter,
    final riseTime=pumpData.riseTimeInpFilter,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1) if use_pressure annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={16,-68})));
  AixLib.Fluid.HeatExchangers.HeatingRod hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final dp_nominal=heatingRodParameters.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=heatPumpParameters.QSec_flow_nominal,
    final V=heatingRodParameters.V_hr,
    final eta=heatingRodParameters.eta_hr,
    use_countNumSwi=false) if use_heaRod
    annotation (Placement(transformation(extent={{22,64},{54,96}})));

  Modelica.Blocks.Sources.Constant TSoil(k=TSoilConst)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-164,32})));

Utilities.KPIs.InternalKPICalculator KPIQHP(
    calc_singleOnTime=false,                                        calc_integral=true,
    calc_totalOnTime=false,
    calc_numSwi=false,                                                                  calc_movAve=false,
    calc_intBelThres=false,                                                                                y=heatPump.con.QFlow_in)
  annotation (Placement(transformation(extent={{-76,-124},{-64,-102}})));
Utilities.KPIs.InternalKPICalculator KPIQHR(
    calc_singleOnTime=false,                                        calc_integral=true,
    calc_totalOnTime=false,
    calc_numSwi=false,                                                                  calc_movAve=false,
    calc_intBelThres=false,                                                                                y=hea.vol.heatPort.Q_flow)
 if use_heaRod
  annotation (Placement(transformation(extent={{-76,-142},{-64,-120}})));

  IBPSA.Fluid.Sources.Boundary_pT bouPumpHP(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1) if use_pressure annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={52,-86})));

  IBPSA.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal[1],
    tau=heatPumpParameters.TempSensorData.tau,
    initType=heatPumpParameters.TempSensorData.initType,
    T_start=T_start,
    final transferHeat=heatPumpParameters.TempSensorData.transferHeat,
    TAmb=heatPumpParameters.TempSensorData.TAmb,
    tauHeaTra=heatPumpParameters.TempSensorData.tauHeaTra)
    "Temperature at supply for building" annotation (Placement(transformation(
        extent={{5,6},{-5,-6}},
        rotation=180,
        origin={71,80})));
  Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={100,-78})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=if use_pressure then 3 else 2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={130,-82})));
protected
  parameter Modelica.SIunits.PressureDifference dpHeaRod_nominal = if use_heaRod then heatingRodParameters.dp_nominal else 0;

equation
  connect(KPIQHP.KPIBus, outBusGen.QHP_flow) annotation (Line(points={{-63.88,-113},{0,-113},{0,-100}}, color={255,204,51}, thickness=0.5), Text(string="%second", index=1, extent={{6,3},{6,3}}, horizontalAlignment=TextAlignment.Left));
connect(KPIQHR.KPIBus, outBusGen.QHR_flow) annotation (Line(points={{-63.88,-131},{0,-131},{0,-100}}, color={255,204,51}, thickness=0.5), Text(string="%second", index=1, extent={{6,3},{6,3}}, horizontalAlignment=TextAlignment.Left));

  connect(dummyZero.y,switch1. u3)
    annotation (Line(points={{29,4},{38,4},{38,-4}},    color={0,0,127}));
  connect(dummyMassFlow.y,switch1. u1)
    annotation (Line(points={{63,4},{54,4},{54,-4}}, color={0,0,127}));
  connect(or1.y,switch1. u2)
    annotation (Line(points={{46,7.1},{46,-4}},
                                             color={255,0,255}));
  connect(switch1.y, artificalPumpIsotermhal.m_flow_in)
    annotation (Line(points={{46,-27},{46,-38.4},{70,-38.4}},
                                                       color={0,0,127},
      pattern=LinePattern.Dash));

  connect(artificalPumpIsotermhal.port_b, heatPump.port_a1) annotation (Line(
        points={{60,-50},{-30.5,-50},{-30.5,-7}}, color={0,127,255},
      pattern=LinePattern.Dash));
  connect(bou_air.ports[1], heatPump.port_a2) annotation (Line(
      points={{-80,52},{-57.5,52},{-57.5,37}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(heatPump.port_b2, bou_sinkAir.ports[1]) annotation (Line(
      points={{-57.5,-7},{-58,-7},{-58,-22},{-80,-22}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(sigBusGen.hp_bus, heatPump.sigBus) annotation (Line(
      points={{2,98},{-132,98},{-132,-62},{-52.775,-62},{-52.775,-6.78}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBusGen.hp_bus.nSet, isOnHP.u) annotation (Line(
      points={{2,98},{2,58},{16,58},{16,45.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bou_air.T_in, switch2.y)
    annotation (Line(points={{-102,56},{-113,56}}, color={0,0,127}));
  connect(sigBusGen.hp_bus.TOdaMea, switch2.u1) annotation (Line(
      points={{2,98},{-150,98},{-150,64},{-136,64}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(switch2.u2, AirOrSoil.y)
    annotation (Line(points={{-136,56},{-157.4,56}}, color={255,0,255}));
  connect(hea.u, sigBusGen.hr_on) annotation (Line(points={{18.8,89.6},{18.8,74},
          {2,74},{2,98}},        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusGen.hr_on, isOnHR.u) annotation (Line(
      points={{2,98},{2,60},{46,60},{46,43.2},{40,43.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_in[1], artificalPumpIsotermhal.port_a) annotation (Line(
        points={{100,-2},{102,-2},{102,-50},{80,-50}}, color={0,127,255},
      pattern=LinePattern.Dash));
  connect(KPIWel.u, sigBusGen.hp_bus.PelMea) annotation (Line(points={{-79.32,
          -95},{-110,-95},{-110,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIWel.KPIBus, outBusGen.WHPel) annotation (Line(
      points={{-65.88,-95},{0,-95},{0,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hea.Pel, KPIWHRel.u) annotation (Line(points={{55.6,89.6},{54,89.6},{
          54,100},{76,100},{76,97},{84.68,97}},
                                    color={0,0,127}));
  connect(KPIWHRel.KPIBus, outBusGen.WHRel) annotation (Line(
      points={{98.12,97},{116,97},{116,-108},{0,-108},{0,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(isOnHR.y, or1.u[1]) annotation (Line(points={{40,29.4},{40,26},{44.6,26},
          {44.6,20}}, color={255,0,255}));
  connect(isOnHP.y, or1.u[2]) annotation (Line(points={{16,31.4},{16,24},{46,24},
          {46,20}}, color={255,0,255}));
  connect(constRunPump247.y, or1.u[3]) annotation (Line(points={{73.5,27},{48.1,
          27},{48.1,20},{47.4,20}}, color={255,0,255}));
  connect(pump.port_a, portGen_in[1]) annotation (Line(
      points={{26,-68},{100,-68},{100,-2}},
      color={0,127,255},
      pattern=LinePattern.Dash));

  connect(passThroughMediumHRBuf.port_a, heatPump.port_b1) annotation (Line(
        points={{32,80},{-30,80},{-30,78},{-30.5,78},{-30.5,37}},
                                                color={0,127,255}));
  connect(pump.port_b, heatPump.port_a1) annotation (Line(
      points={{6,-68},{-30.5,-68},{-30.5,-7}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(TSoil.y, switch2.u3) annotation (Line(points={{-157.4,32},{-146,32},
          {-146,48},{-136,48}}, color={0,0,127}));
  connect(heatPump.port_b1, hea.port_a) annotation (Line(points={{-30.5,37},{
          -30.5,80},{22,80}}, color={0,127,255}));
  connect(bouPumpHP.ports[1], pump.port_a) annotation (Line(
      points={{52,-76},{52,-68},{26,-68}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(switch1.y, pump.y) annotation (Line(points={{46,-27},{46,-38},{16,-38},
          {16,-56}}, color={0,0,127}));
  connect(hea.port_b, passThroughMediumHRBuf.port_a)
    annotation (Line(points={{54,80},{32,80}}, color={0,127,255}));
  connect(senTBuiSup.T, sigBusGen.THeaRodMea) annotation (Line(points={{71,86.6},
          {71,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTBuiSup.port_b, portGen_out[1])
    annotation (Line(points={{76,80},{100,80}}, color={0,127,255}));
  connect(passThroughMediumHRBuf.port_a, hea.port_a)
    annotation (Line(points={{32,80},{22,80}}, color={0,127,255}));
  connect(passThroughMediumHRBuf.port_b, senTBuiSup.port_a)
    annotation (Line(points={{44,80},{66,80}}, color={0,127,255}));
  connect(hea.port_b, senTBuiSup.port_a)
    annotation (Line(points={{54,80},{66,80}}, color={0,127,255}));

  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{89.8,-78.2},{72,-78.2},{72,-98}},
      color={0,0,0},
      thickness=1));
  connect(multiSum.y, realToElecCon.PEleLoa)
    annotation (Line(points={{122.98,-82},{112,-82}}, color={0,0,127}));
  connect(multiSum.u[1], hea.Pel) annotation (Line(points={{136,-82},{142,-82},
          {142,89.6},{55.6,89.6}},color={0,0,127}));
  connect(multiSum.u[2], sigBusGen.hp_bus.PelMea) annotation (Line(points={{136,
          -82},{140,-82},{140,96},{72,96},{72,98},{2,98}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(multiSum.u[3], pump.P) annotation (Line(points={{136,-82},{140,-82},{
          140,-86},{144,-86},{144,-59},{5,-59}},
                                             color={0,0,127}));
end HeatPumpAndHeatingRod;
