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

  replaceable model RefrigerantCycleHeatPumpHeating =
    AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
      (PEle_nominal=0)
       constrainedby
    AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
       final useInHeaPum=true,
       final QHea_flow_nominal=heatPump.QHea_flow_nominal,
       final TCon_nominal=heatPump.TConHea_nominal,
       final TEva_nominal=heatPump.TEvaHea_nominal,
       final cpCon=heatPump.cpCon,
       final cpEva=heatPump.cpEva)
  "Refrigerant cycle module for the heating mode"
    annotation (choicesAllMatching=true);

  replaceable parameter RecordsCollection.HeatPumps.Generic parHeaPum
    "Heat pump parameters"
    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{-34,42},{-18,58}})));
  replaceable parameter
    AixLib.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
    safCtrPar "Safety control parameters" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-58,44},{-42,58}})));
  parameter Boolean use_rev=true
    "=true if the heat pump is reversible"
    annotation(Dialog(group="Component choices"));
  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    parTemSen constrainedby
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition(
      transferHeat=true)
              "Parameters for temperature sensors"
                                             annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{62,44},{76,58}})));
  replaceable model RefrigerantCycleInertia =
      AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia
      "Model approach for internal heat pump intertia"
    annotation (choicesAllMatching=true);
  parameter Boolean use_old_design[nParallelDem]=fill(false, nParallelDem)
    "If true, design parameters of the building with no retrofit (old state) are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));
  // Temperature Levels
  parameter Modelica.Units.SI.Temperature TBiv=TOda_nominal
    "Bivalence temperature. Equals TOda_nominal for monovalent systems."
    annotation (Dialog(enable=genDesTyp <> Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent,
        group="Heat Pump System Design"));
  parameter Modelica.Units.SI.Temperature THeaTresh=293.15
    "Heating treshhold temperature for bivalent design"
    annotation (Dialog(group="Heat Pump System Design"));
  parameter Modelica.Units.SI.Temperature TSupAtBiv = BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.ConstantGradientHeatCurve(
    TBiv, THeaTresh, 293.15, TSup_nominal[1], TSup_nominal[1] - 10, TOda_nominal, 1.24)
    "Supply temperature at bivalence point for design"
    annotation (Dialog(group="Heat Pump System Design"));

  parameter
    BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign
    genDesTyp "Type of generation system design" annotation (Dialog(
      group="Heat Pump System Design"));

  parameter Modelica.Units.SI.HeatFlowRate QPriAtTOdaNom_flow_nominal=0
    "Nominal heat flow rate of primary generation device at 
    nominal outdoor air temperature, required for bivalent parallel design.
    Default of 0 equals a part-parallel design with cut-off equal to TOda_nominal"
    annotation (Dialog(group="Heat Pump System Design",
    enable=genDesTyp == Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel));

  parameter Modelica.Units.SI.HeatFlowRate QGenBiv_flow_nominal=
      Q_flow_design[1]*(TBiv - THeaTresh)/(TOda_nominal - THeaTresh)
    "Nominal heat flow rate at bivalence temperature"
    annotation (Dialog(tab="Calculated", group="Heat Pump System Design"));

  parameter Modelica.Units.SI.HeatFlowRate QPri_flow_nominal=if genDesTyp ==
      Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent then
      Q_flow_design[1] else QGenBiv_flow_nominal
    "Nominal heat flow rate of primary generation component (e.g. heat pump)"
    annotation (Dialog(tab="Calculated", group="Heat Pump System Design"));
  parameter Modelica.Units.SI.HeatFlowRate QSec_flow_nominal=if genDesTyp ==
      Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent then 0
       elseif genDesTyp == Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentAlternativ
       then Q_flow_design[1] elseif genDesTyp == Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel
       then max(0, Q_flow_design[1] - QPriAtTOdaNom_flow_nominal) else Q_flow_design[1]
    "Nominal heat flow rate of secondary generation component (e.g. auxilliar heater)"
    annotation (Dialog(tab="Calculated", group="Heat Pump System Design"));


  parameter Boolean use_airSource=true
    "Turn false to use water as temperature source"
     annotation(Dialog(group="Component choices"));
  replaceable package MediumEva = IBPSA.Media.Air constrainedby
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

  replaceable BESMod.Systems.Hydraulical.Control.Components.Defrost.NoDefrost defCtrl if use_rev and use_airSource
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.Defrost.BaseClasses.PartialDefrost
       "Defrost control"
    annotation (choicesAllMatching=true,
        Dialog(group="Component choices", enable=use_rev and use_airSource),
        Placement(transformation(extent={{-98,12},{-82,28}})));
  replaceable model RefrigerantCycleHeatPumpCooling =
      AixLib.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling
      constrainedby
    AixLib.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
       final useInChi=false,
       final cpCon=heatPump.cpCon,
       final cpEva=heatPump.cpEva,
       final TCon_nominal=heatPump.TEvaCoo_nominal,
       final TEva_nominal=heatPump.TConCoo_nominal,
       QCoo_flow_nominal=heatPump.QCoo_flow_nominal)
  "Refrigerant cycle module for the cooling mode"
    annotation (Dialog(group="Component choices", enable=use_rev),choicesAllMatching=true);

  parameter Modelica.Units.SI.Temperature TConCoo_nominal=291.15
    "Nominal temperature of the cooled fluid"
     annotation(Dialog(group="Component choices", enable=use_rev));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal=303.15
    "Nominal temperature of the heated fluid"
     annotation(Dialog(group="Component choices", enable=use_rev));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=0
    "Nominal cooling capacity"
     annotation(Dialog(group="Component choices", enable=use_rev));
  BESMod.Systems.Hydraulical.Generation.BaseClasses.ModularPropagable heatPump(
    redeclare package MediumCon = Medium,
    redeclare package MediumEva = MediumEva,
    allowDifferentDeviceIdentifiers=true,
    final use_busConOnl=false,
    redeclare model RefrigerantCycleInertia = RefrigerantCycleInertia,
    final use_rev=use_rev,
    final tauCon=parHeaPum.tauCon,
    final dTCon_nominal=dTTra_nominal[1],
    final mCon_flow_nominal=m_flow_design[1],
    final dpCon_nominal=parHeaPum.dpCon_nominal,
    final use_conCap=parHeaPum.use_conCap,
    final CCon=parHeaPum.CCon,
    final GConOut=parHeaPum.GConOut,
    final GConIns=parHeaPum.GConIns,
    final tauEva=parHeaPum.tauEva,
    final dTEva_nominal=parHeaPum.dTEva_nominal,
    final dpEva_nominal=parHeaPum.dpEva_nominal,
    final use_evaCap=parHeaPum.use_evaCap,
    final CEva=parHeaPum.CEva,
    final GEvaOut=parHeaPum.GEvaOut,
    final GEvaIns=parHeaPum.GEvaIns,
    final safCtrPar=safCtrPar,
    final allowFlowReversalEva=allowFlowReversal,
    final allowFlowReversalCon=allowFlowReversal,
    final pCon_start=p_start,
    final TCon_start=T_start,
    final pEva_start=MediumEva.p_default,
    final TEva_start=TOda_nominal,
    final energyDynamics=energyDynamics,
    final show_T=show_T,
    final QHea_flow_nominal=QPri_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    final TConHea_nominal=if genDesTyp == BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent then TSup_nominal[1] else TSupAtBiv,
    final TEvaHea_nominal=TBiv,
    final TConCoo_nominal=TConCoo_nominal,
    final TEvaCoo_nominal=TEvaCoo_nominal,
    refCyc(
      redeclare model RefrigerantCycleHeatPumpHeating =
          RefrigerantCycleHeatPumpHeating,
      redeclare model RefrigerantCycleHeatPumpCooling =
          RefrigerantCycleHeatPumpCooling))
                         annotation (
     Placement(transformation(
        extent={{17.5,-17.5},{-17.5,17.5}},
        rotation=270,
        origin={-40.5,17.5})));

  IBPSA.Fluid.Sources.Boundary_ph bou_sinkAir(final nPorts=1, redeclare package
      Medium =         MediumEva)                       annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-10})));
  IBPSA.Fluid.Sources.MassFlowSource_T bouEva(
    final m_flow=heatPump.mEva_flow_nominal,
    final use_T_in=true,
    redeclare package Medium = MediumEva,
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

  Modelica.Blocks.Sources.Constant TSoil(k=TSoilConst)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,50})));

  BESMod.Utilities.KPIs.EnergyKPICalculator KPIQHP(use_inpCon=true)
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

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
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)                           annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={130,-82})));
  BESMod.Utilities.KPIs.DeviceKPICalculator KPIHeaPum(
    use_reaInp=false,
    calc_singleOnTime=true,
    calc_totalOnTime=true,
    calc_numSwi=true) "Heat pump KPIs"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  BESMod.Systems.Hydraulical.Control.Components.BaseClasses.HeatPumpBusPassThrough
    heaPumSigBusPasThr
    "Bus connector pass through for OpenModelica" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-40,90})));

  Modelica.Blocks.Sources.Constant constTAmb(final k=TAmb) if not use_airSource
    "Constant ambient temperature for heat pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,10})));

  AixLib.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus
    sigBus "Bus with model outputs and possibly inputs"
    annotation (Placement(transformation(extent={{-92,-60},{-52,-20}})));
  Modelica.Blocks.Routing.RealPassThrough
                                   reaPasThrRelHum
    "Get relative humidity"                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-30})));


  IBPSA.Fluid.FixedResistances.PressureDrop resGen(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final deltaM=0.3) "Pressure drop model depending on the configuration"
    annotation (Placement(transformation(extent={{60,-12},{80,8}})));
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

  connect(TSoil.y, switch.u3) annotation (Line(points={{-159,50},{-156,50},{-156,
          42},{-142,42}}, color={0,0,127}));
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

  connect(heatPump.P, multiSum.u[1]) annotation (Line(points={{-40.5,36.75},{-40.5,
          40},{152,40},{152,-82},{136,-82}},       color={0,0,127}));
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
  connect(KPIHeaPum.u, sigBusGen.heaPumIsOn) annotation (Line(points={{-122.2,-50},
          {-148,-50},{-148,98},{2,98}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  if parHeaPum.use_conCap then
    if use_airSource then
      connect(heatPump.TConAmb, weaBus.TDryBul) annotation (Line(points={{-24.925,-1.925},
            {-24.925,-26},{-100.895,-26},{-100.895,80.11}}, color={0,0,127}));
    else
      connect(constTAmb.y, heatPump.TConAmb) annotation (Line(points={{-159,10},{-108,
              10},{-108,-26},{-26,-26},{-26,-1.925},{-24.925,-1.925}}, color={0,0,127}));
    end if;

  end if;
  if parHeaPum.use_evaCap then
    if use_airSource then
      connect(heatPump.TEvaAmb, weaBus.TDryBul) annotation (Line(points={{-56.425,-1.925},
            {-56.425,-26},{-100.895,-26},{-100.895,80.11}}, color={0,0,127}));
    else
      connect(constTAmb.y, heatPump.TEvaAmb) annotation (Line(points={{-159,10},{-108,
              10},{-108,-26},{-56.425,-26},{-56.425,-1.925}}, color={0,0,127}));
    end if;

  end if;
  connect(defCtrl.hea, heatPump.hea) annotation (Line(points={{-81.2,20},{-60,20},
          {-60,-1.925},{-44.175,-1.925}}, color={255,0,255}));

  connect(sigBus, heatPump.sigBus) annotation (Line(
      points={{-72,-40},{-72,0.175},{-47.325,0.175}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaPumSigBusPasThr.vapComBus, sigBus) annotation (Line(
      points={{-50,90},{-66,90},{-66,0},{-72,0},{-72,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(defCtrl.sigBus, sigBus) annotation (Line(
      points={{-98.8,12.96},{-98.8,6},{-66,6},{-66,0},{-72,0},{-72,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrRelHum.y, sigBus.relHum) annotation (Line(points={{-159,-30},
          {-152,-30},{-152,-40},{-72,-40}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrRelHum.u, weaBus.relHum) annotation (Line(points={{-182,-30},
          {-190,-30},{-190,110},{-100.895,110},{-100.895,80.11}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heatPump.QEva_flow, sigBus.QEva_flow) annotation (Line(points={{
          -56.25,36.75},{-72,36.75},{-72,-40}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_in[1], resGen.port_b)
    annotation (Line(points={{100,-2},{80,-2}}, color={0,127,255}));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
end PartialHeatPump;
