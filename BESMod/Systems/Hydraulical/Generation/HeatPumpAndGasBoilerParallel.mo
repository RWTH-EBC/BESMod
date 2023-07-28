within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndGasBoilerParallel
  "Bivalent heat pump System parallel inspired by Bagarella"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final dTLoss_nominal=fill(0, nParallelDem),
    dTTra_nominal={if TDem_nominal[i] > 273.15 + 55 then 10 elseif TDem_nominal[
        i] > 44.9 + 273.15 then 8 else 5 for i in 1:nParallelDem},
    dp_nominal={0.5*heatPump.dpCon_nominal + 0.5*boiNoCtrl.dp_nominal},
    nParallelDem=1);

     parameter Modelica.Units.SI.Power Q_nom=boiNoCtrl.paramBoiler.Q_nom
    "Nominal heating power";

     parameter Modelica.Units.SI.Volume V=boiNoCtrl.paramBoiler.volume "Volume";


  parameter Boolean use_airSource=true
    "Turn false to use water as temperature source."
     annotation(Dialog(group="Component choices"));

   parameter Boolean use_heaRod=false "=false to disable the heating rod"
     annotation(Dialog(group="Component choices"));
    replaceable model PerDataMainHP =
      AixLib.DataBase.HeatPump.PerformanceData.LookUpTable2D
    constrainedby
    AixLib.DataBase.HeatPump.PerformanceData.BaseClasses.PartialPerformanceData
    annotation (Dialog(group="Component data"), __Dymola_choicesAllMatching=true);
  parameter Modelica.Media.Interfaces.Types.Temperature TSoilConst=273.15 + 10
    "Constant soil temperature for ground source heat pumps"
    annotation(Dialog(group="Component choices", enable=use_airSource));

  replaceable package Medium_eva = Modelica.Media.Interfaces.PartialMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (Dialog(group="Component choices"),
      choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition
    heatPumpParameters constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumpBaseDataDefinition(
        final QGen_flow_nominal=Q_flow_nominal[1],
        final TOda_nominal=TOda_nominal)
     annotation (Dialog(group="Component data"), choicesAllMatching=true, Placement(
        transformation(extent={{-98,14},{-82,28}})));


  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData annotation (Dialog(group="Component data"),
    choicesAllMatching=true, Placement(transformation(extent={{68,-36},{82,-24}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
    temperatureSensorData
    annotation (Dialog(group="Component data"), choicesAllMatching=true,
    Placement(transformation(extent={{60,10},{80,30}})));

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
    final tauSenT=temperatureSensorData.tau,
    final transferHeat=true,
    final allowFlowReversalEva=allowFlowReversal,
    final allowFlowReversalCon=allowFlowReversal,
    final tauHeaTraEva=temperatureSensorData.tauHeaTra,
    final TAmbEva_nominal=temperatureSensorData.TAmb,
    final tauHeaTraCon=temperatureSensorData.tauHeaTra,
    final TAmbCon_nominal=temperatureSensorData.TAmb,
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
        origin={-42,13})));

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
  Modelica.Blocks.Sources.BooleanConstant AirOrSoil(final k=use_airSource)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,90})));

  Utilities.KPIs.EnergyKPICalculator KPIWel(use_inpCon=true)
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

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

  Modelica.Blocks.Sources.Constant TSoil(k=TSoilConst)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,50})));

  Utilities.KPIs.EnergyKPICalculator KPIQHP(use_inpCon=false, y=heatPump.con.QFlow_in)
    annotation (Placement(transformation(extent={{-140,-112},{-120,-92}})));

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
    tau=temperatureSensorData.tau,
    initType=temperatureSensorData.initType,
    T_start=T_start,
    final transferHeat=temperatureSensorData.transferHeat,
    TAmb=temperatureSensorData.TAmb,
    tauHeaTra=temperatureSensorData.tauHeaTra)
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
  Modelica.Blocks.Math.MultiSum multiSum(nu=2)                           annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={130,-82})));
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



  AixLib.Fluid.BoilerCHP.BoilerNoControl boiNoCtrl(
    redeclare package Medium = AixLib.Media.Water,
    final allowFlowReversal=true,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final initType=Modelica.Blocks.Types.Init.NoInit,
    final transferHeat=false,
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    final etaLoadBased= boiNoCtrl.paramBoiler.eta,
    final G=0.003*Q_nom/50,
    final C=1.5*Q_nom,
    final Q_nom=boiNoCtrl.paramBoiler.Q_nom,
    final V=boiNoCtrl.paramBoiler.volume,
    final etaTempBased=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.; 373.15,0.99],
    final paramBoiler=AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_15kW())
    annotation (Placement(transformation(extent={{10,-2},{48,36}})));





  Distribution.Components.Valves.ThreeWayValveWithFlowReturn
                                            threeWayValveWithFlowReturn(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters=threeWayValveParameters)
    annotation (Placement(transformation(extent={{-20,-88},{-46,-62}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    threeWayValveParameters(from_dp=true) constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={heatPumpParameters.dpCon_nominal,boiNoCtrl.dp_nominal},
    final m_flow_nominal=2*m_flow_nominal[1],
    final fraK=1,
    use_inputFilter=false) annotation (Placement(transformation(extent={{-242,-70},
            {-222,-50}})), choicesAllMatching=true);


  Utilities.KPIs.EnergyKPICalculator KPIBoi(use_inpCon=true)
    annotation (Placement(transformation(extent={{-140,-142},{-120,-122}})));
equation

  connect(bou_air.ports[1], heatPump.port_a2) annotation (Line(
      points={{-80,50},{-74,50},{-74,42},{-55.5,42},{-55.5,35}},
      color={0,127,255}));
  connect(heatPump.port_b2, bou_sinkAir.ports[1]) annotation (Line(
      points={{-55.5,-9},{-56,-9},{-56,-10},{-80,-10}},
      color={0,127,255}));
  connect(bou_air.T_in, switch2.y)
    annotation (Line(points={{-102,54},{-108,54},{-108,50},{-119,50}},
                                                   color={0,0,127}));
  connect(switch2.u2, AirOrSoil.y)
    annotation (Line(points={{-142,50},{-152,50},{-152,90},{-159,90}},
                                                     color={255,0,255}));

  connect(TSoil.y, switch2.u3) annotation (Line(points={{-159,50},{-156,50},{-156,
          42},{-142,42}},       color={0,0,127}));
  connect(bouPum.ports[1], pump.port_a)
    annotation (Line(points={{50,-76},{50,-70},{20,-70}}, color={0,127,255}));
  connect(senTGenOut.T, sigBusGen.THeaRodMea) annotation (Line(points={{70,91},{
          70,96},{26,96},{26,74},{2,74},{2,98}},
                           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{89.8,-78.2},{72,-78.2},{72,-100}},
      color={0,0,0},
      thickness=1));
  connect(multiSum.y, realToElecCon.PEleLoa)
    annotation (Line(points={{122.98,-82},{112,-82}}, color={0,0,127}));
  if use_heaRod then
    connect(multiSum.u[1], reaExpPEleHeaPum.y) annotation (Line(points={{136,
            -84.1},{144,-84.1},{144,-150},{-154,-150},{-154,-70},{-159,-70}},
                                                           color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    connect(multiSum.u[2], pump.P) annotation (Line(points={{136,-79.9},{144,
            -79.9},{144,-114},{-14,-114},{-14,-58},{0,-58},{0,-61},{-1,-61}},
                                             color={0,0,127}));
  else
    connect(multiSum.u[2], pump.P) annotation (Line(points={{136,-79.9},{144,
            -79.9},{144,-114},{-14,-114},{-14,-58},{0,-58},{0,-61},{-1,-61}},
                                             color={0,0,127}));
    connect(multiSum.u[1], reaExpPEleHeaPum.y) annotation (Line(points={{136,
            -84.1},{144,-84.1},{144,-150},{-154,-150},{-154,-70},{-159,-70}},
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
  connect(reaExpPEleHeaPum.y, KPIWel.u)
    annotation (Line(points={{-159,-70},{-141.8,-70}}, color={0,0,127}));
  connect(conIceFac.y, heatPump.iceFac_in) annotation (Line(points={{-156.9,11},
          {-106,11},{-106,-3.72},{-72.6,-3.72}}, color={0,0,127}));
  connect(heatPump.nSet, sigBusGen.yHeaPumSet) annotation (Line(points={{-37.5,-12.52},
          {-37.5,-26},{2,-26},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booExpHeaPumIsOn.y, sigBusGen.heaPumIsOn) annotation (Line(points={{-159,
          -10},{-150,-10},{-150,98},{2,98}}, color={255,0,255}), Text(
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
  connect(heatPump.modeSet, conNotRev.y) annotation (Line(points={{-46.5,-12.52},
          {-46.5,-38},{-159,-38}}, color={255,0,255}));
  connect(reaExpTEvaIn.y, sigBusGen.THeaPumEvaIn) annotation (Line(points={{-39,
          50},{2,50},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boiNoCtrl.T_out, sigBusGen.TBoilerOut) annotation (Line(points={{
          42.68,23.08},{42.68,22},{52,22},{52,72},{2,72},{2,98}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pump.port_b, threeWayValveWithFlowReturn.portGen_a) annotation (Line(
        points={{1.77636e-15,-70},{-14,-70},{-14,-69.28},{-20,-69.28}}, color={0,
          127,255}));
  connect(threeWayValveWithFlowReturn.portBui_b, heatPump.port_a1) annotation (
      Line(points={{-46,-64.6},{-54,-64.6},{-54,-64},{-60,-64},{-60,-44},{-28.5,
          -44},{-28.5,-9}}, color={0,127,255}));
  connect(heatPump.port_b1, threeWayValveWithFlowReturn.portBui_a) annotation (
      Line(points={{-28.5,35},{-28.5,46},{-20,46},{-20,-46},{-52,-46},{-52,-69.8},
          {-46,-69.8}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_a, boiNoCtrl.port_b) annotation (
      Line(points={{-46,-84.88},{-56,-84.88},{-56,-86},{-62,-86},{-62,-110},{48,
          -110},{48,17}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, boiNoCtrl.port_a) annotation (
      Line(points={{-46,-79.68},{-62,-79.68},{-62,-80},{-72,-80},{-72,-120},{-6,
          -120},{-6,-44},{10,-44},{10,17}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portGen_b, senTGenOut.port_a) annotation (
     Line(points={{-20,-79.68},{2,-79.68},{2,-82},{28,-82},{28,-120},{148,-120},
          {148,52},{38,52},{38,80},{60,80}}, color={0,127,255}));
  connect(senTGenOut.port_b, portGen_out[1])
    annotation (Line(points={{80,80},{100,80}}, color={0,127,255}));
  connect(pump.port_a, portGen_in[1]) annotation (Line(points={{20,-70},{56,-70},
          {56,-68},{100,-68},{100,-2}}, color={0,127,255}));
  connect(sigBusGen.uThrWayValGen, threeWayValveWithFlowReturn.uBuf)
    annotation (Line(
      points={{2,98},{4,98},{4,-54},{-33,-54},{-33,-59.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(boiNoCtrl.u_rel, sigBusGen.yBoiler) annotation (Line(points={{15.7,
          30.3},{2,30.3},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(boiNoCtrl.thermalPower, KPIBoi.u) annotation (Line(points={{42.68,
          32.96},{178,32.96},{178,-174},{-174,-174},{-174,-132},{-141.8,-132}},
        color={0,0,127}));
  connect(KPIBoi.KPI, outBusGen.QBoi_flow) annotation (Line(points={{-117.8,
          -132},{0,-132},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
end HeatPumpAndGasBoilerParallel;
