within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndHeatingRod "Bivalent monoenergetic heat pump"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final dTLoss_nominal=fill(0, nParallelDem),
    dTTra_nominal={if TDem_nominal[i] > 273.15 + 55 then 10 elseif TDem_nominal[
        i] > 44.9 + 273.15 then 8 else 5 for i in 1:nParallelDem},
    dp_nominal={heatPump.dpCon_nominal + dpHeaRod_nominal},
      nParallelDem=1);
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
        transformation(extent={{-98,14},{-82,28}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatingRodBaseDataDefinition
    heatingRodParameters annotation (choicesAllMatching=true, Placement(
        transformation(extent={{64,44},{76,56}})));

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (choicesAllMatching=true, Placement(transformation(extent={{42,-56},
            {56,-44}})));

  AixLib.Fluid.Interfaces.PassThroughMedium pasThrMedHeaRod(redeclare package
      Medium = Medium, allowFlowReversal=allowFlowReversal) if not use_heaRod
    "Pass through if heating rod is not used"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  AixLib.Fluid.HeatPumps.HeatPump heatPump(
    redeclare package Medium_con = Medium,
    redeclare package Medium_eva = Medium_eva,
    final use_rev=true,
    final use_autoCalc=false,
    final Q_useNominal=0,
    final scalingFactor=heatPumpParameters.scalingFactor,
    final use_refIne=heatPumpParameters.use_refIne,
    final refIneFre_constant=heatPumpParameters.refIneFre_constant,
    final nthOrder=1,
    final useBusConnectorOnly=false,
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
    final energyDynamics=energyDynamics,
    final show_TPort=show_T,
    redeclare model PerDataMainHP = PerDataMainHP,
    redeclare model PerDataRevHP =
        AixLib.DataBase.Chiller.PerformanceData.LookUpTable2D (dataTable=
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
        origin={-90,-10})));
  IBPSA.Fluid.Sources.MassFlowSource_T bou_air(
    final m_flow=heatPumpParameters.mEva_flow_nominal,
    final use_T_in=true,
    redeclare package Medium = Medium_eva,
    final use_m_flow_in=false,
    final nPorts=1)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,50})));
  Modelica.Blocks.Sources.BooleanConstant
                                   AirOrSoil(k=heatPumpParameters.useAirSource)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,90})));

  Utilities.KPIs.EnergyKPICalculator KPIWel(use_inpCon=true)
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Utilities.KPIs.EnergyKPICalculator KPIWHRel(use_inpCon=true) if use_heaRod
    annotation (Placement(transformation(extent={{-140,-48},{-120,-28}})));

  IBPSA.Fluid.Movers.SpeedControlled_y pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
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
    final y_start=1)                 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,-70})));
  AixLib.Fluid.HeatExchangers.HeatingRod hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final dp_nominal=heatingRodParameters.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=heatPumpParameters.QSec_flow_nominal,
    final V=heatingRodParameters.V_hr,
    final eta=heatingRodParameters.eta_hr,
    use_countNumSwi=false) if use_heaRod
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Modelica.Blocks.Sources.Constant TSoil(k=TSoilConst)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,50})));

  Utilities.KPIs.EnergyKPICalculator KPIQHP(use_inpCon=false, y=heatPump.con.QFlow_in)
    annotation (Placement(transformation(extent={{-140,-112},{-120,-92}})));
  Utilities.KPIs.EnergyKPICalculator KPIQHR(use_inpCon=false, y=hea.vol.heatPort.Q_flow)
    if use_heaRod
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1) "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-86})));

  IBPSA.Fluid.Sensors.TemperatureTwoPort senTGenOut(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal[1],
    tau=heatPumpParameters.TempSensorData.tau,
    initType=heatPumpParameters.TempSensorData.initType,
    T_start=T_start,
    final transferHeat=heatPumpParameters.TempSensorData.transferHeat,
    TAmb=heatPumpParameters.TempSensorData.TAmb,
    tauHeaTra=heatPumpParameters.TempSensorData.tauHeaTra)
    "Temperature at supply (generation outlet)"
                                         annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,80})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={100,-78})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=if use_heaRod then 3 else 2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={130,-82})));
  Utilities.KPIs.DeviceKPICalculator KPIHeaRod(
    use_reaInp=false,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true)
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Utilities.KPIs.DeviceKPICalculator KPIHeaRod1(
    use_reaInp=true,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true)
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Modelica.Blocks.Sources.BooleanExpression booExpHeaPumIsOn(y=heatPump.greaterThreshold.y)
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Modelica.Blocks.Sources.RealExpression reaExpPEleHeaPum(y=heatPump.innerCycle.Pel)
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Modelica.Blocks.Sources.Constant conIceFac(final k=1) annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-169,11})));
  Modelica.Blocks.Sources.RealExpression reaExpTHeaPumOut(y=heatPump.senT_b1.T)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.RealExpression reaExpTHeaPumIn(y=heatPump.senT_a1.T)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.BooleanConstant conNotRev(final k=true) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-38})));
  Modelica.Blocks.Sources.RealExpression reaExpTEvaIn(y=heatPump.senT_a2.T)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
protected
  parameter Modelica.Units.SI.PressureDifference dpHeaRod_nominal=if use_heaRod
       then heatingRodParameters.dp_nominal else 0;

equation

  connect(bou_air.ports[1], heatPump.port_a2) annotation (Line(
      points={{-80,50},{-74,50},{-74,42},{-57.5,42},{-57.5,37}},
      color={0,127,255}));
  connect(heatPump.port_b2, bou_sinkAir.ports[1]) annotation (Line(
      points={{-57.5,-7},{-56,-7},{-56,-10},{-80,-10}},
      color={0,127,255}));
  connect(bou_air.T_in, switch2.y)
    annotation (Line(points={{-102,54},{-108,54},{-108,50},{-119,50}},
                                                   color={0,0,127}));
  connect(switch2.u2, AirOrSoil.y)
    annotation (Line(points={{-142,50},{-152,50},{-152,90},{-159,90}},
                                                     color={255,0,255}));
  connect(hea.Pel, KPIWHRel.u) annotation (Line(points={{41,56},{40,56},{40,68},
          {0,68},{0,-30},{-74,-30},{-74,-36},{-110,-36},{-110,-24},{-141.8,-24},
          {-141.8,-38}},            color={0,0,127}));
  connect(pump.port_a, portGen_in[1]) annotation (Line(
      points={{20,-70},{100,-70},{100,-2}},
      color={0,127,255}));

  connect(pasThrMedHeaRod.port_a, heatPump.port_b1) annotation (Line(points={{20,
          30},{10,30},{10,50},{-30,50},{-30,38},{-30.5,38},{-30.5,37}}, color={0,
          127,255}));
  connect(pump.port_b, heatPump.port_a1) annotation (Line(
      points={{1.77636e-15,-70},{-30.5,-70},{-30.5,-7}},
      color={0,127,255}));
  connect(TSoil.y, switch2.u3) annotation (Line(points={{-159,50},{-156,50},{-156,
          42},{-142,42}},       color={0,0,127}));
  connect(heatPump.port_b1, hea.port_a) annotation (Line(points={{-30.5,37},{-30.5,
          36},{-30,36},{-30,50},{20,50}},
                              color={0,127,255}));
  connect(bouPum.ports[1], pump.port_a)
    annotation (Line(points={{50,-76},{50,-70},{20,-70}}, color={0,127,255}));
  connect(senTGenOut.T, sigBusGen.THeaRodMea) annotation (Line(points={{70,91},{
          70,96},{26,96},{26,74},{2,74},{2,98}},
                           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTGenOut.port_b, portGen_out[1])
    annotation (Line(points={{80,80},{100,80}}, color={0,127,255}));
  connect(pasThrMedHeaRod.port_b, senTGenOut.port_a) annotation (Line(points={{40,
          30},{54,30},{54,80},{60,80}}, color={0,127,255}));
  connect(hea.port_b,senTGenOut. port_a)
    annotation (Line(points={{40,50},{54,50},{54,80},{60,80}},
                                               color={0,127,255}));

  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{89.8,-78.2},{72,-78.2},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(multiSum.y, realToElecCon.PEleLoa)
    annotation (Line(points={{122.98,-82},{112,-82}}, color={0,0,127}));
  if use_heaRod then
    connect(multiSum.u[3], hea.Pel) annotation (Line(points={{136,-82},{94,-82},
            {94,56},{41,56}},     color={0,0,127}));
    connect(multiSum.u[1], reaExpPEleHeaPum.y) annotation (Line(points={{136,-82},
            {144,-82},{144,-150},{-154,-150},{-154,-70},{-159,-70}},
                                                           color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    connect(multiSum.u[2], pump.P) annotation (Line(points={{136,-82},{144,-82},
            {144,-114},{-14,-114},{-14,-58},{0,-58},{0,-61},{-1,-61}},
                                             color={0,0,127}));
  else
    connect(multiSum.u[2], pump.P) annotation (Line(points={{136,-82},{144,-82},
            {144,-114},{-14,-114},{-14,-58},{0,-58},{0,-61},{-1,-61}},
                                             color={0,0,127}));
    connect(multiSum.u[1], reaExpPEleHeaPum.y) annotation (Line(points={{136,-82},
            {144,-82},{144,-150},{-154,-150},{-154,-70},{-159,-70}},
                                                           color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  end if;
  connect(switch2.u1, weaBus.TDryBul) annotation (Line(points={{-142,58},{-144,58},
          {-144,80},{-101,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pump.y, sigBusGen.uPump) annotation (Line(points={{10,-58},{24,-58},{24,
          -22},{2,-22},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIQHR.KPI, outBusGen.QHR_flow) annotation (Line(points={{-117.8,-130},
          {-106,-130},{-106,-102},{0,-102},{0,-100}}, color={135,135,135}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIQHP.KPI, outBusGen.QHP_flow) annotation (Line(points={{-117.8,-102},
          {0,-102},{0,-100}},              color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIWel.KPI, outBusGen.PEleHP) annotation (Line(points={{-117.8,-70},{-104,
          -70},{-104,-102},{0,-102},{0,-100}},                   color={135,135,
          135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIWHRel.KPI, outBusGen.PEleHR) annotation (Line(points={{-117.8,-38},
          {-106,-38},{-106,-102},{0,-102},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod.KPI, outBusGen.heaPum) annotation (Line(points={{-117.8,-10},
          {-106,-10},{-106,-12},{-98,-12},{-98,-100},{0,-100}},   color={135,
          135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod1.KPI, outBusGen.heaRod) annotation (Line(points={{-77.8,-110},
          {0,-110},{0,-100}},       color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod1.uRea, sigBusGen.uHeaRod) annotation (Line(points={{-102.2,-110},
          {-128,-110},{-128,-112},{-150,-112},{-150,98},{2,98}},       color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(booExpHeaPumIsOn.y, KPIHeaRod.u)
    annotation (Line(points={{-159,-10},{-142.2,-10}}, color={255,0,255}));
  connect(reaExpPEleHeaPum.y, KPIWel.u)
    annotation (Line(points={{-159,-70},{-141.8,-70}}, color={0,0,127}));
  connect(conIceFac.y, heatPump.iceFac_in) annotation (Line(points={{-156.9,11},
          {-106,11},{-106,-1.72},{-74.6,-1.72}}, color={0,0,127}));
  connect(heatPump.nSet, sigBusGen.yHeaPumSet) annotation (Line(points={{-39.5,-10.52},
          {-39.5,-26},{2,-26},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booExpHeaPumIsOn.y, sigBusGen.heaPumIsOn) annotation (Line(points={{-159,
          -10},{-142,-10},{-142,98},{2,98}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaExpTHeaPumIn.y, sigBusGen.THeaPumIn) annotation (Line(points={{-39,
          70},{2,70},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaExpTHeaPumOut.y, sigBusGen.THeaPumOut) annotation (Line(points={{-39,
          90},{-28,90},{-28,74},{2,74},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heatPump.modeSet, conNotRev.y) annotation (Line(points={{-48.5,-10.52},
          {-48.5,-38},{-159,-38}}, color={255,0,255}));
  connect(reaExpTEvaIn.y, sigBusGen.THeaPumEvaIn) annotation (Line(points={{-39,
          50},{2,50},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hea.u, sigBusGen.uHeaRod) annotation (Line(points={{18,56},{2,56},{2,98}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
end HeatPumpAndHeatingRod;
