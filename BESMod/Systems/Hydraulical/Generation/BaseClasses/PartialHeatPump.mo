within BESMod.Systems.Hydraulical.Generation.BaseClasses;
model PartialHeatPump "Generation with only the heat pump"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final dTLoss_nominal=fill(0, nParallelDem),
    Q_flow_design = {if use_old_design[i] then QOld_flow_design[i] else Q_flow_nominal[i] for i in 1:nParallelDem},
    dTTra_nominal={if TDem_nominal[i] > 273.15 + 55 then 10 elseif TDem_nominal[
        i] > 44.9 + 273.15 then 8 else 5 for i in 1:nParallelDem},
    dTTraOld_design={if TDemOld_design[i] > 273.15 + 55 then 10 elseif TDemOld_design[
        i] > 44.9 + 273.15 then 8 else 5 for i in 1:nParallelDem},
    dTTra_design={if use_old_design[i] then dTTraOld_design[i] else dTTra_nominal[i] for i in 1:nParallelDem},
    dp_nominal={heatPump.dpCon_nominal},
      nParallelDem=1);

  parameter Boolean use_old_design[nParallelDem]=fill(false, nParallelDem)
    "If true, design parameters of the building with no retrofit (old state) are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  replaceable model PerDataMainHP =
      AixLib.Obsolete.Year2024.DataBase.HeatPump.PerformanceData.LookUpTable2D
    constrainedby
    AixLib.Obsolete.Year2024.DataBase.HeatPump.PerformanceData.BaseClasses.PartialPerformanceData
    "Heat pump model approach"
    annotation (Dialog(group="Component data"), choicesAllMatching=true);
  replaceable model PerDataRevHP =
      AixLib.Obsolete.Year2024.DataBase.Chiller.PerformanceData.PolynomalApproach
      (redeclare function PolyData =
          AixLib.Obsolete.Year2024.DataBase.HeatPump.Functions.Characteristics.ConstantCoP
          (powerCompressor=2000, CoP=2))
    constrainedby
    AixLib.Obsolete.Year2024.DataBase.Chiller.PerformanceData.BaseClasses.PartialPerformanceData
    annotation (Dialog(group="Frosting"), choicesAllMatching=true);
  parameter Boolean use_airSource=true
    "Turn false to use water as temperature source."
     annotation(Dialog(group="Component choices"));
  replaceable package Medium_eva = IBPSA.Media.Air                         constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (Dialog(group="Component choices"),
      choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  parameter Modelica.Media.Interfaces.Types.Temperature TSoilConst=273.15 + 10
    "Constant soil temperature for ground source heat pumps"
    annotation(Dialog(group="Component choices", enable=use_airSource));
  replaceable Components.Frosting.NoFrosting frost constrainedby
    Components.Frosting.BaseClasses.PartialFrosting
    "Model to account for frosting and defrost control" annotation (Dialog(group="Frosting"), Placement(
        transformation(extent={{-178,2},{-162,18}})), choicesAllMatching=true);
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition
    parHeaPum constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition(
      final QGen_flow_nominal=Q_flow_design[1], final TOda_nominal=TOda_nominal)
    "Heat pump parameters" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-98,22},{-82,36}})));

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPum
    "Parameters for pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{42,-56},{56,-44}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    parTemSen "Parameters for temperature sensors"
                                             annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{62,104},{76,118}})));

  AixLib.Obsolete.Year2024.Fluid.HeatPumps.HeatPump heatPump(
    redeclare package Medium_con = Medium,
    redeclare package Medium_eva = Medium_eva,
    final use_rev=true,
    final use_autoCalc=false,
    final Q_useNominal=0,
    final scalingFactor=parHeaPum.scalingFactor,
    final use_refIne=parHeaPum.use_refIne,
    final refIneFre_constant=parHeaPum.refIneFre_constant,
    final nthOrder=1,
    final useBusConnectorOnly=false,
    final mFlow_conNominal=m_flow_design[1],
    final VCon=parHeaPum.VCon,
    final dpCon_nominal=parHeaPum.dpCon_nominal,
    final use_conCap=false,
    final CCon=0,
    final GConOut=0,
    final GConIns=0,
    final mFlow_evaNominal=parHeaPum.mEva_flow_nominal,
    final VEva=parHeaPum.VEva,
    final dpEva_nominal=parHeaPum.dpEva_nominal,
    final use_evaCap=false,
    final CEva=0,
    final GEvaOut=0,
    final GEvaIns=0,
    final tauSenT=parTemSen.tau,
    final transferHeat=parTemSen.transferHeat,
    final allowFlowReversalEva=allowFlowReversal,
    final allowFlowReversalCon=allowFlowReversal,
    final tauHeaTraEva=parTemSen.tauHeaTra,
    final TAmbEva_nominal=parTemSen.TAmb,
    final tauHeaTraCon=parTemSen.tauHeaTra,
    final TAmbCon_nominal=parTemSen.TAmb,
    final pCon_start=p_start,
    final TCon_start=T_start,
    final pEva_start=Medium_eva.p_default,
    final TEva_start=TOda_nominal,
    final energyDynamics=energyDynamics,
    final show_TPort=show_T,
    redeclare model PerDataMainHP = PerDataMainHP,
    redeclare model PerDataRevHP = PerDataRevHP) annotation (Placement(
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
  IBPSA.Fluid.Sources.MassFlowSource_T bouEva(
    final m_flow=parHeaPum.mEva_flow_nominal,
    final use_T_in=true,
    redeclare package Medium = Medium_eva,
    final use_m_flow_in=false,
    final nPorts=1) "Evaporator boundary"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Modelica.Blocks.Logical.Switch switch "Switch between air and soil temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,50})));
  Modelica.Blocks.Sources.BooleanConstant AirOrSoil(final k=use_airSource)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,90})));

  Utilities.KPIs.EnergyKPICalculator KPIWel(use_inpCon=true)
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

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
        origin={10,-70})));

  Modelica.Blocks.Sources.Constant TSoil(k=TSoilConst)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,50})));

  Utilities.KPIs.EnergyKPICalculator KPIQHP(use_inpCon=false, final y=heatPump.con.QFlow_in)
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

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
    tau=parTemSen.tau,
    initType=parTemSen.initType,
    T_start=T_start,
    final transferHeat=parTemSen.transferHeat,
    TAmb=parTemSen.TAmb,
    tauHeaTra=parTemSen.tauHeaTra) "Temperature at supply (generation outlet)"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,80})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={100,-78})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2)                           annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={130,-82})));
  Modelica.Blocks.Sources.BooleanExpression booExpHeaPumIsOn(y=heatPump.greaterThreshold.y)
    annotation (Placement(transformation(extent={{-182,-40},{-162,-20}})));
  Modelica.Blocks.Sources.RealExpression reaExpPEleHeaPum(y=heatPump.innerCycle.Pel)
    "Electrical power consumption of heat pump"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Modelica.Blocks.Sources.RealExpression reaExpTHeaPumOut(y=heatPump.senT_b1.T)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.RealExpression reaExpTHeaPumIn(y=heatPump.senT_a1.T)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.RealExpression reaExpTEvaIn(y=heatPump.senT_a2.T)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Utilities.KPIs.DeviceKPICalculator KPIHeaPum(
    use_reaInp=false,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true) "Heat pump KPIs"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Modelica.Blocks.Sources.RealExpression reaExpQEva_flow(y=heatPump.innerCycle.QEva)
    "Electrical power consumption of heat pump"
    annotation (Placement(transformation(extent={{-220,-4},{-200,16}})));

equation
  connect(bouEva.ports[1], heatPump.port_a2) annotation (Line(points={{-80,50},{-74,
          50},{-74,42},{-57.5,42},{-57.5,37}}, color={0,127,255}));
  connect(heatPump.port_b2, bou_sinkAir.ports[1]) annotation (Line(
      points={{-57.5,-7},{-56,-7},{-56,-10},{-80,-10}},
      color={0,127,255}));
  connect(bouEva.T_in, switch.y) annotation (Line(points={{-102,54},{-108,54},{-108,
          50},{-119,50}}, color={0,0,127}));
  connect(switch.u2, AirOrSoil.y) annotation (Line(points={{-142,50},{-152,50},{-152,
          90},{-159,90}}, color={255,0,255}));
  connect(pump.port_a, portGen_in[1]) annotation (Line(
      points={{20,-70},{100,-70},{100,-2}},
      color={0,127,255}));

  connect(TSoil.y, switch.u3) annotation (Line(points={{-159,50},{-156,50},{-156,
          42},{-142,42}}, color={0,0,127}));
  connect(bouPum.ports[1], pump.port_a)
    annotation (Line(points={{50,-76},{50,-70},{20,-70}}, color={0,127,255}));
  connect(senTGenOut.port_b, portGen_out[1])
    annotation (Line(points={{80,80},{100,80}}, color={0,127,255}));

  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{89.8,-78.2},{72,-78.2},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(multiSum.y, realToElecCon.PEleLoa)
    annotation (Line(points={{122.98,-82},{112,-82}}, color={0,0,127}));
  connect(multiSum.u[1], reaExpPEleHeaPum.y) annotation (Line(points={{136,-80.95},
          {144,-80.95},{144,-150},{-154,-150},{-154,-70},{-159,-70}},
                                                           color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(switch.u1, weaBus.TDryBul) annotation (Line(points={{-142,58},{-144,58},
          {-144,80.11},{-100.895,80.11}},
                                color={0,0,127}), Text(
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
  connect(reaExpPEleHeaPum.y, KPIWel.u)
    annotation (Line(points={{-159,-70},{-148,-70},{-148,-30},{-141.8,-30}},
                                                       color={0,0,127}));
  connect(heatPump.nSet, sigBusGen.yHeaPumSet) annotation (Line(points={{-39.5,-10.52},
          {-39.5,-26},{2,-26},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booExpHeaPumIsOn.y, sigBusGen.heaPumIsOn) annotation (Line(points={{-161,
          -30},{-142,-30},{-142,98},{2,98}}, color={255,0,255}), Text(
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
  connect(reaExpTEvaIn.y, sigBusGen.THeaPumEvaIn) annotation (Line(points={{-39,
          50},{2,50},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTGenOut.T, sigBusGen.TGenOutMea) annotation (Line(points={{70,91},{
          70,98},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIQHP.KPI, outBusGen.QHeaPum_flow) annotation (Line(points={{-117.8,
          -70},{-114,-70},{-114,-122},{0,-122},{0,-100}}, color={135,135,135}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIWel.KPI, outBusGen.PEleHeaPum) annotation (Line(points={{-117.8,-30},
          {0,-30},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIHeaPum.u, booExpHeaPumIsOn.y) annotation (Line(points={{-122.2,-50},{
          -134,-50},{-134,-48},{-154,-48},{-154,-30},{-161,-30}},  color={255,0,
          255}));
  connect(KPIHeaPum.KPI, outBusGen.heaPum) annotation (Line(points={{-97.8,-50},{
          0,-50},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(frost.modeHeaPum, heatPump.modeSet) annotation (Line(points={{-161.2,5.2},
          {-112,5.2},{-112,-36},{-48.5,-36},{-48.5,-10.52}}, color={255,0,255}));
  connect(frost.iceFacMea, heatPump.iceFac_in) annotation (Line(points={{-161.2,14.8},
          {-120,14.8},{-120,-1.72},{-74.6,-1.72}}, color={0,0,127}));
  connect(frost.relHum, weaBus.relHum) annotation (Line(points={{-179.6,16.08},{-190,
          16.08},{-190,80.11},{-100.895,80.11}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(frost.genConBus, heatPump.sigBus) annotation (Line(
      points={{-178.8,2.96},{-190,2.96},{-190,-38},{-52.775,-38},{-52.775,-6.78}},
      color={255,204,51},
      thickness=0.5));

  connect(frost.TOda, weaBus.TDryBul) annotation (Line(points={{-179.6,10.32},{-200,
          10.32},{-200,80.11},{-100.895,80.11}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaExpQEva_flow.y, frost.QEva_flow) annotation (Line(points={{-199,6},{-190,
          6},{-190,5.68},{-179.6,5.68}}, color={0,0,127}));
  connect(pump.P, multiSum.u[2]) annotation (Line(points={{-1,-61},{-10,-61},{-10,
          -116},{148,-116},{148,-83.05},{136,-83.05}}, color={0,0,127}));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
end PartialHeatPump;
