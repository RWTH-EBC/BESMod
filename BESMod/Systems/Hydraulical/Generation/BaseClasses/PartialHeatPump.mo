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
  replaceable parameter
    AixLib.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
    safCtrPar "Safety control parameters" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-58,44},{-42,58}})));

  replaceable model RefrigerantCycleInertia =
      AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia
    annotation (choicesAllMatching=true);
  parameter Boolean use_old_design[nParallelDem]=fill(false, nParallelDem)
    "If true, design parameters of the building with no retrofit (old state) are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Boolean use_rev=false
    "=true if the heat pump is reversible";
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
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition
    parHeaPum constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition(
      final QGen_flow_nominal=Q_flow_design[1], final TOda_nominal=TOda_nominal)
    "Heat pump parameters" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-34,44},{-18,58}})));

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

  AixLib.Fluid.HeatPumps.ModularReversible.Modular heatPump(
    redeclare package MediumCon = Medium,
    redeclare package MediumEva = Medium_eva,
    redeclare model RefrigerantCycleInertia = RefrigerantCycleInertia,
    final use_rev=use_rev,
    final dTCon_nominal=dTTra_nominal[1],
    final mCon_flow_nominal=m_flow_design[1],
    final dpCon_nominal=parHeaPum.dpCon_nominal,
    final use_conCap=false,
    final CCon=0,
    final GConOut=0,
    final GConIns=0,
    final dTEva_nominal=parHeaPum.dTEva_nominal,
    final dpEva_nominal=parHeaPum.dpEva_nominal,
    final use_evaCap=false,
    final CEva=0,
    final GEvaOut=0,
    final GEvaIns=0,
    final safCtrPar=safCtrPar,
    final allowFlowReversalEva=allowFlowReversal,
    final allowFlowReversalCon=allowFlowReversal,
    final pCon_start=p_start,
    final TCon_start=T_start,
    final pEva_start=Medium_eva.p_default,
    final TEva_start=TOda_nominal,
    final energyDynamics=energyDynamics,
    final show_T=show_T,
    final QHea_flow_nominal=parHeaPum.QPri_flow_nominal,
    final TConHea_nominal=TSup_nominal[1],
    final TEvaHea_nominal=parHeaPum.TBiv,
    final TConCoo_nominal=273.15,
    final TEvaCoo_nominal=273.15)
                         annotation (
     Placement(transformation(
        extent={{17.5,-17.5},{-17.5,17.5}},
        rotation=270,
        origin={-40.5,17.5})));

  IBPSA.Fluid.Sources.Boundary_ph bou_sinkAir(final nPorts=1, redeclare package
      Medium =         Medium_eva)                       annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-10})));
  IBPSA.Fluid.Sources.MassFlowSource_T bouEva(
    final m_flow=heatPump.mEva_flow_nominal,
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

  Utilities.KPIs.EnergyKPICalculator KPIQHP(use_inpCon=true)
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
  Utilities.KPIs.DeviceKPICalculator KPIHeaPum(
    use_reaInp=false,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true) "Heat pump KPIs"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Control.Components.BaseClasses.HeatPumpBusPassThrough
                                                heaPumSigBusPasThr
    "Bus connector pass through for OpenModelica" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-40,90})));

equation
  connect(bouEva.ports[1], heatPump.port_a2) annotation (Line(points={{-80,50},{
          -70,50},{-70,35},{-51,35}},          color={0,127,255}));
  connect(heatPump.port_b2, bou_sinkAir.ports[1]) annotation (Line(
      points={{-51,7.10543e-15},{-51,-10},{-80,-10}},
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

  connect(switch.u1, weaBus.TDryBul) annotation (Line(points={{-142,58},{-144,58},
          {-144,80.11},{-100.895,80.11}},
                                color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pump.y, sigBusGen.uPump) annotation (Line(points={{10,-58},{24,-58},{24,
          -10},{2,-10},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heatPump.ySet, sigBusGen.yHeaPumSet) annotation (Line(points={{-37.175,
          -1.925},{-37.175,-10},{2,-10},{2,98}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
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
  connect(KPIHeaPum.KPI, outBusGen.heaPum) annotation (Line(points={{-97.8,-50},{
          0,-50},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(pump.P, multiSum.u[1]) annotation (Line(points={{-1,-61},{-10,-61},{-10,
          -116},{148,-116},{148,-80.95},{136,-80.95}}, color={0,0,127}));
  connect(heatPump.P, multiSum.u[2]) annotation (Line(points={{-40.5,36.75},{-40.5,
          40},{152,40},{152,-83.05},{136,-83.05}}, color={0,0,127}));
  connect(KPIWel.u, heatPump.P) annotation (Line(points={{-141.8,-30},{-150,-30},
          {-150,36.75},{-40.5,36.75}},                   color={0,0,127}));
  connect(KPIQHP.u, heatPump.QCon_flow) annotation (Line(points={{-141.8,-70},{-188,
          -70},{-188,108},{-8,108},{-8,36},{-24.75,36},{-24.75,36.75}}, color={0,
          0,127}));
  connect(heaPumSigBusPasThr.sigBusGen, sigBusGen) annotation (Line(
      points={{-30,90},{-24,90},{-24,98},{2,98}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaPumSigBusPasThr.vapComBus, heatPump.sigBus) annotation (Line(
      points={{-50,90},{-72,90},{-72,-8},{-52,-8},{-52,0.175},{-47.325,0.175}},
      color={255,204,51},
      thickness=0.5));
  connect(KPIHeaPum.u, sigBusGen.heaPumIsOn) annotation (Line(points={{-122.2,-50},
          {-148,-50},{-148,98},{2,98}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heatPump.hea, sigBusGen.hea) annotation (Line(points={{-44.175,-1.925},
          {-44.175,-16},{2,-16},{2,98}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
end PartialHeatPump;
