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

  Utilities.KPIs.IntegralKPICalculator     KPIWel(
    use_inpCon=true,
    intUnit="J",
    unit="W")
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Utilities.KPIs.IntegralKPICalculator     KPIWHRel(
    use_inpCon=true,
    unit="W",
    intUnit="J")       if use_heaRod
    annotation (Placement(transformation(extent={{-180,-48},{-160,-28}})));

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

  Utilities.KPIs.IntegralKPICalculator        KPIQHP(
    use_inpCon=false,
    unit="W",
    intUnit="J",
    y=heatPump.con.QFlow_in)
    annotation (Placement(transformation(extent={{-180,-112},{-160,-92}})));
  Utilities.KPIs.IntegralKPICalculator        KPIQHR(
    use_inpCon=false,
    unit="W",
    intUnit="J",
    y=hea.vol.heatPort.Q_flow) if use_heaRod
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));

  IBPSA.Fluid.Sources.Boundary_pT bouPumpHP(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1)                 annotation (Placement(transformation(
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
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Utilities.KPIs.DeviceKPICalculator KPIHeaRod1(
    use_reaInp=true,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true)
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
protected
  parameter Modelica.Units.SI.PressureDifference dpHeaRod_nominal=if use_heaRod
       then heatingRodParameters.dp_nominal else 0;

equation

  connect(bou_air.ports[1], heatPump.port_a2) annotation (Line(
      points={{-80,52},{-57.5,52},{-57.5,37}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(heatPump.port_b2, bou_sinkAir.ports[1]) annotation (Line(
      points={{-57.5,-7},{-58,-7},{-58,-22},{-80,-22}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(sigBusGen.hp_bus, heatPump.sigBus) annotation (Line(
      points={{2,98},{-150,98},{-150,-40},{-52.775,-40},{-52.775,-6.78}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(bou_air.T_in, switch2.y)
    annotation (Line(points={{-102,56},{-113,56}}, color={0,0,127}));
  connect(switch2.u2, AirOrSoil.y)
    annotation (Line(points={{-136,56},{-157.4,56}}, color={255,0,255}));
  connect(hea.u, sigBusGen.hr_on) annotation (Line(points={{18.8,89.6},{18.8,74},
          {2,74},{2,98}},        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIWel.u, sigBusGen.hp_bus.PelMea) annotation (Line(points={{-181.8,
          -70},{-196,-70},{-196,120},{-22,120},{-22,122},{26,122},{26,98},{2,98}},
                                             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hea.Pel, KPIWHRel.u) annotation (Line(points={{55.6,89.6},{58,89.6},{
          58,114},{-184,114},{-184,-38},{-181.8,-38}},
                                    color={0,0,127}));
  connect(pump.port_a, portGen_in[1]) annotation (Line(
      points={{26,-68},{100,-68},{100,-2}},
      color={0,127,255}));

  connect(passThroughMediumHRBuf.port_a, heatPump.port_b1) annotation (Line(
        points={{32,80},{-30,80},{-30,78},{-30.5,78},{-30.5,37}},
                                                color={0,127,255}));
  connect(pump.port_b, heatPump.port_a1) annotation (Line(
      points={{6,-68},{-30.5,-68},{-30.5,-7}},
      color={0,127,255}));
  connect(TSoil.y, switch2.u3) annotation (Line(points={{-157.4,32},{-146,32},
          {-146,48},{-136,48}}, color={0,0,127}));
  connect(heatPump.port_b1, hea.port_a) annotation (Line(points={{-30.5,37},{
          -30.5,80},{22,80}}, color={0,127,255}));
  connect(bouPumpHP.ports[1], pump.port_a) annotation (Line(
      points={{52,-76},{52,-68},{26,-68}},
      color={0,127,255}));
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
      points={{89.8,-78.2},{72,-78.2},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(multiSum.y, realToElecCon.PEleLoa)
    annotation (Line(points={{122.98,-82},{112,-82}}, color={0,0,127}));
  if use_heaRod then
    connect(multiSum.u[2], hea.Pel) annotation (Line(points={{136,-82},{142,-82},
          {142,89.6},{55.6,89.6}},color={0,0,127}));
    connect(multiSum.u[1], sigBusGen.hp_bus.PelMea) annotation (Line(points={{136,
          -82},{140,-82},{140,96},{72,96},{72,98},{2,98}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    connect(multiSum.u[3], pump.P) annotation (Line(points={{136,-82},{140,-82},{
          140,-86},{144,-86},{144,-59},{5,-59}},
                                             color={0,0,127}));
  else
    connect(multiSum.u[2], pump.P) annotation (Line(points={{136,-82},{144,-82},
            {144,-114},{-14,-114},{-14,-58},{0,-58},{0,-59},{5,-59}},
                                             color={0,0,127}));
    connect(multiSum.u[1], sigBusGen.hp_bus.PelMea) annotation (Line(points={{136,
          -82},{140,-82},{140,96},{72,96},{72,98},{2,98}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  end if;
  connect(switch2.u1, weaBus.TDryBul) annotation (Line(points={{-136,64},{-144,64},
          {-144,80},{-101,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pump.y, sigBusGen.uPump) annotation (Line(points={{16,-56},{24,-56},{24,
          -22},{2,-22},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIQHR.KPI, outBusGen.QHR_flow) annotation (Line(points={{-157.8,-130},
          {-146,-130},{-146,-102},{0,-102},{0,-100}}, color={135,135,135}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIQHP.KPI, outBusGen.QHP_flow) annotation (Line(points={{-157.8,-102},
          {-16,-102},{-16,-100},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIWel.KPI, outBusGen.PEleHP) annotation (Line(points={{-157.8,-70},{
          -144,-70},{-144,-102},{-14,-102},{-14,-100},{0,-100}}, color={135,135,
          135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIWHRel.KPI, outBusGen.PEleHR) annotation (Line(points={{-157.8,-38},
          {-146,-38},{-146,-102},{0,-102},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod.KPI, outBusGen.heaPum) annotation (Line(points={{-157.8,-10},
          {-146,-10},{-146,-12},{-138,-12},{-138,-100},{0,-100}}, color={135,
          135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod.u, sigBusGen.hp_bus.onOffMea) annotation (Line(points={{
          -182.2,-10},{-198,-10},{-198,98},{2,98}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod1.KPI, outBusGen.heaRod) annotation (Line(points={{-117.8,
          -110},{0,-110},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaRod1.uRea, sigBusGen.hr_on) annotation (Line(points={{-142.2,
          -110},{-168,-110},{-168,-112},{-190,-112},{-190,98},{2,98}}, color={0,
          0,127}), Text(
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
