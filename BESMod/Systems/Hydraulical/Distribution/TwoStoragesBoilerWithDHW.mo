within BESMod.Systems.Hydraulical.Distribution;
model TwoStoragesBoilerWithDHW
  "Two storages with a boiler after buffer and with DHW support"
  extends
    BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialTwoStorageParallel(
    final QHC2_flow_nominal=parBoi.Q_nom,
    final mHC2_flow_nominal=pumBoi.m_flow_nominal,
    final dTLoadingHC2=dTBoiDHWLoa,
    stoBuf(final useHeatingCoil1=false),
    final dpBufHCSto_nominal=0,
    final dTLoaHCBuf=0,
    final use_secHeaCoiDHWSto=true,
    stoDHW(nHC2Up=parStoDHW.nLayer, nHC2Low=1),
    final use_old_design=fill(false, nParallelDem));
  parameter Modelica.Units.SI.TemperatureDifference dTBoiDHWLoa = 5
    "Temperature difference for DHW storage loading with the boiler"
    annotation(Dialog(group="Component data"));
  parameter Real etaTem[:,2]=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.; 373.15,
      0.99] "Temperature based efficiency"
        annotation(Dialog(group="Component data"));
  parameter Modelica.Units.SI.PressureDifference dpBufStoBoiVal_nominal
    "Nominal pressure drop between boiler valve and buffer storage"
    annotation (Dialog(tab="Pressure Drops"));
  parameter Modelica.Units.SI.PressureDifference dpBoiValDHWSto_nominal
    "Nominal pressure drop between boiler valve and DHW storage"
    annotation (Dialog(tab="Pressure Drops"));
   parameter Modelica.Units.SI.PressureDifference dpBoiValHydSep_nominal
    "Nominal pressure drop between boiler valve and hydraulic sepearator"
    annotation (Dialog(tab="Pressure Drops"));
  replaceable parameter BESMod.Systems.Hydraulical.Generation.RecordsCollection.AutoparameterBoiler
    parBoi constrainedby
    AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition(
      Q_nom=max(11000, Q_flow_nominal[1]))
    "Parameters for Boiler"
    annotation(Placement(transformation(extent={{84,124},{96,136}})),
      choicesAllMatching=true, Dialog(group="Component data"));
  replaceable parameter BESMod.Systems.RecordsCollection.Movers.DPVar parPum(iconName="Pump Boi")
    constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{44,124},{56,136}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve parThrWayValBoi(iconName=
        "BoiWayValve")
    constrainedby BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final m_flow_nominal=m_flow_nominal[1],
    final dp_nominal={0,sum(stoDHW.heatingCoil2.pipe.res.dp_nominal)},
    final fraK=1,
    use_strokeTime=false) "Parameters for three way valve of boiler" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{64,124},{76,136}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
    parHydSep(iconName="HydSep")
              constrainedby
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
    final rho=rho,
    final c_p=cp,
    energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.APlus,
    final TAmb=TAmb,
    T_m=TSup_nominal[1],
    final QHC1_flow_nominal=Q_flow_nominal[1]*f_design[1],
    final mHC1_flow_nominal=mSup_flow_nominal[1],
    redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1,
    final use_HC2=stoBuf.useHeatingCoil2,
    final use_HC1=stoBuf.useHeatingCoil1,
    final dTLoadingHC2=9999999,
    final dTLoadingHC1=9999999,
    final fHeiHC2=1,
    final fDiaHC2=1,
    final QHC2_flow_nominal=9999999,
    final mHC2_flow_nominal=9999999,
    redeclare final AixLib.DataBase.Pipes.Copper.Copper_10x0_6 pipeHC2)
    "Parameters for hydraulic separator" annotation (choicesAllMatching=true,
      Placement(transformation(extent={{24,164},{36,176}})));
  AixLib.Fluid.BoilerCHP.BoilerNoControl boi(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final dp_nominal=m_flow_nominal[1]^2*boi.a/(rho^2),
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    final tau=parTemSen.tau,
    final initType=parTemSen.initType,
    final transferHeat=parTemSen.transferHeat,
    final TAmb=parTemSen.TAmb,
    final tauHeaTra=parTemSen.tauHeaTra,
    final etaLoadBased=parBoi.eta,
    final G=0.003*parBoi.Q_nom/50,
    final C=1.5*parBoi.Q_nom,
    final Q_nom=parBoi.Q_nom,
    final V=parBoi.volume,
    final etaTempBased=etaTem,
    final paramBoiler=parBoi,
    T_out(unit="K", displayUnit="degC"))
    "Boiler with no control"
    annotation (Placement(transformation(extent={{30,50},{48,70}})));

  BESMod.Systems.Hydraulical.Distribution.Components.Valves.ThreeWayValveWithFlowReturn
    thrWayValBoiDHW(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters=parThrWayValBoi)
    "Three way valve to swith the boiler between DHW and building"
    annotation (Placement(transformation(extent={{20,-14},{40,6}})));
  AixLib.Fluid.Storage.StorageDetailed hydSep(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final mSenFac=1,
    redeclare package MediumHC1 = IBPSA.Media.Water,
    redeclare package MediumHC2 = IBPSA.Media.Water,
    final m1_flow_nominal=m_flow_nominal[1],
    final m2_flow_nominal=m_flow_nominal[1],
    final mHC1_flow_nominal=parStoBuf.mHC1_flow_nominal,
    final mHC2_flow_nominal=parStoBuf.mHC2_flow_nominal,
    final useHeatingCoil1=false,
    final useHeatingCoil2=false,
    final useHeatingRod=false,
    final TStart=fill(T_start, parHydSep.nLayer),
    redeclare final
      BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.bufferData
      data(
      final hTank=parHydSep.h,
      hHC1Low=0,
      hHR=parHydSep.nLayerHR/parHydSep.nLayer*parStoBuf.h,
      final dTank=parHydSep.d,
      final sWall=parHydSep.sIns/2,
      final sIns=parHydSep.sIns/2,
      final lambdaWall=parHydSep.lambda_ins,
      final lambdaIns=parHydSep.lambda_ins,
      final rhoIns=373000,
      final cIns=1000,
      pipeHC1=parHydSep.pipeHC1,
      pipeHC2=parHydSep.pipeHC2,
      lengthHC1=parHydSep.lengthHC1,
      lengthHC2=parHydSep.lengthHC2),
    final n=parHydSep.nLayer,
    final hConIn=parHydSep.hConIn,
    final hConOut=parHydSep.hConOut,
    final hConHC1=parStoBuf.hConHC1,
    final hConHC2=parStoBuf.hConHC2,
    upToDownHC1=true,
    upToDownHC2=true,
    final TStartWall=T_start,
    final TStartIns=T_start,
    redeclare model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferBuoyancyWetter,
    final allowFlowReversal_layers=allowFlowReversal,
    final allowFlowReversal_HC1=allowFlowReversal,
    final allowFlowReversal_HC2=allowFlowReversal) "Hydraulic seperator"
    annotation (Placement(transformation(extent={{64,0},{80,20}})));

  IBPSA.Fluid.Movers.Preconfigured.SpeedControlled_y pumBoi(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_nominal=m_flow_nominal[1],
    final use_riseTime=parPum.use_riseTime,
    final dp_nominal=boi.dp_nominal + (parThrWayValBoi.dpValve_nominal + max(
        parThrWayValBoi.dp_nominal)),
    final addPowerToMedium=parPumGen.addPowerToMedium,
    final tau=parPumGen.tau,
    final use_riseTime=parPumGen.use_riseTime,
    final riseTime=parPumGen.riseTime,
    final y_start=1) "Pump in supply line of boiler" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-16,60})));

  Utilities.KPIs.EnergyKPICalculator KPIBoi1(use_inpCon=false, y=boi.thermalPower)
    "Boiler heat flow KPI"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-170})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalAftBufBoi(use_inpCon=false, y=boi.fuelPower)
    "Boiler after buffer KPIs" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-140})));
  IBPSA.Fluid.FixedResistances.PressureDrop resBufStoToBoiVal(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=dpBufStoBoiVal_nominal,
    final linearized=false,
    final deltaM=0.3)
    "Pressure drop due to resistances between boiler valve and buffer storage"
    annotation (Placement(transformation(extent={{4,50},{24,70}})));
  IBPSA.Fluid.FixedResistances.PressureDrop resBoiValHydSep(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=dpBoiValHydSep_nominal,
    final linearized=false,
    final deltaM=0.3)
    "Pressure drop due to resistances between boiler valve and hydraulic sepearator"
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));
  IBPSA.Fluid.FixedResistances.PressureDrop resBoiValDHWSto(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_nominal[1],
    final show_T=show_T,
    final from_dp=false,
    final dp_nominal=dpBoiValDHWSto_nominal,
    final linearized=false,
    final deltaM=0.3)
    "Pressure drop due to resistances between boiler valve and DHW storage"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-50})));
initial algorithm
  assert(use_dhw, "This system can only be simulated with use_dhw=true", AssertionLevel.error);
equation
  connect(boi.port_b, thrWayValBoiDHW.portGen_a) annotation (Line(points={{48,60},
          {50,60},{50,42},{18,42},{18,0},{20,0},{20,0.4}},       color={0,127,255}));
  connect(thrWayValBoiDHW.uBuf, sigBusDistr.uThrWayVal) annotation (Line(points={{30,8},{
          30,48},{0,48},{0,101}},                            color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTBuiSup.port_b, portBui_out[1]) annotation (Line(points={{86,80},{96,
          80},{96,80},{100,80}},    color={0,127,255}));
  connect(thrWayValBoiDHW.portGen_b, stoBuf.fluidportBottom2) annotation (Line(
        points={{20,-7.6},{18,-7.6},{18,-8},{-30,-8},{-30,-0.2},{-29.4,-0.2}},
                                                                        color={0,127,
          255}));
  connect(stoBuf.fluidportTop2, pumBoi.port_a) annotation (Line(points={{-29,40.2},
          {-26,40.2},{-26,60}},               color={0,127,255}));
  connect(hydSep.fluidportTop2, senTBuiSup.port_a) annotation (Line(points={{74.5,
          20.1},{74.5,24},{54,24},{54,80},{66,80}}, color={0,127,255}));
  connect(eneKPICalAftBufBoi.KPI, outBusDist.PBoiAftBuf) annotation (Line(points={{17.8,
          -140},{0,-140},{0,-100}},       color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIBoi1.KPI, outBusDist.QBoi_flow) annotation (Line(points={{17.8,
          -170},{0,-170},{0,-100}},
                              color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boi.T_out, sigBusDistr.TBoiOut) annotation (Line(points={{45.48,63.2},{45.48,
          66},{50,66},{50,74},{28,74},{28,101},{0,101}},
                                                   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boi.u_rel, sigBusDistr.yBoi) annotation (Line(points={{32.7,67},{32.7,66},
          {28,66},{28,102},{16,102},{16,101},{0,101}},
                                   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(stoDHW.portHC2Out, thrWayValBoiDHW.portDHW_a) annotation (Line(points={{-50.2,
          -61.4},{-50.2,-62},{-54,-62},{-54,-72},{42,-72},{42,-11.6},{40,-11.6}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.fluidportBottom1)
    annotation (Line(points={{-40,154},{12,154},{12,92},{-54,92},{-54,-10},{-39.4,
          -10},{-39.4,-0.4}},
        color={0,127,255}));
  connect(pumTra.port_b, hydSep.fluidportBottom2) annotation (Line(points={{60,40},
          {60,28},{86,28},{86,-4},{74.3,-4},{74.3,-0.1}},                color=
          {0,127,255}));
  connect(stoBuf.fluidportTop1, resValToBufSto.port_b) annotation (Line(points={
          {-39.6,40.2},{-39.6,88},{16,88},{16,160},{0,160}}, color={0,127,255}));
  connect(resBufStoToBoiVal.port_b, boi.port_a)
    annotation (Line(points={{24,60},{30,60}}, color={0,127,255}));
  connect(resBufStoToBoiVal.port_a, pumBoi.port_b)
    annotation (Line(points={{4,60},{-6,60}}, color={0,127,255}));
  connect(thrWayValBoiDHW.portDHW_b, resBoiValDHWSto.port_a) annotation (Line(
        points={{40,-7.6},{46,-7.6},{46,-34},{50,-34},{50,-40}}, color={0,127,
          255}));
  connect(resBoiValDHWSto.port_b, stoDHW.portHC2In) annotation (Line(points={{
          50,-60},{50,-78},{-56,-78},{-56,-68},{-58,-68},{-58,-55},{-50.2,-55}},
        color={0,127,255}));
  connect(thrWayValBoiDHW.portBui_b, hydSep.fluidportTop1) annotation (Line(
        points={{40,4},{44,4},{44,22},{69.2,22},{69.2,20.1}}, color={0,127,255}));
  connect(resBoiValHydSep.port_a, thrWayValBoiDHW.portBui_a) annotation (Line(
        points={{50,-10},{48,-10},{48,0},{40,0}}, color={0,127,255}));
  connect(resBoiValHydSep.port_b, hydSep.fluidportBottom1) annotation (Line(
        points={{70,-10},{72,-10},{72,-2},{69.3,-2},{69.3,-0.2}}, color={0,127,
          255}));
end TwoStoragesBoilerWithDHW;
