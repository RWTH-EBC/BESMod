within BESMod.Systems.Hydraulical.Distribution;
model TwoStoragesBoilerWithDHW
  "Two storages with a boiler after buffer and with DHW support"
  extends
    BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialTwoStorageParallel(
    final dpBufToDem_design=0,
    final QHC2_flow_nominal=parBoi.Q_nom,
    final mHC2_flow_nominal=mBoi_flow_nominal,
    final dTLoadingHC2=dTBoiDHWLoa,
    stoBuf(final m2_flow_nominal=mBoi_flow_nominal,
           final useHeatingCoil1=false),
    final dpBufHCSto_design=0,
    final dTLoaHCBuf=0,
    final use_secHeaCoiDHWSto=true,
    stoDHW(nHC2Up=parStoDHW.nLayer, nHC2Low=1),
    multiSum(nu=5));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal=
    boi.Q_nom / dTBoi_nominal / cp "Nominal mass flow rate of boiler";
  parameter Modelica.Units.SI.TemperatureDifference dTBoi_nominal=10
    "Nominal boiler temperature difference";

  parameter Modelica.Units.SI.TemperatureDifference dTBoiDHWLoa = 5
    "Temperature difference for DHW storage loading with the boiler"
    annotation(Dialog(group="Component data"));
  parameter Real etaTem[:,2]=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.; 373.15,
      0.99] "Temperature based efficiency"
        annotation(Dialog(group="Component data"));
  parameter Modelica.Units.SI.Velocity vBoi_design=vSup_design[1]
    "Nominal fluid velocity, used to design pipes"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Length dPipBoi_design=
     sqrt(4*mBoi_flow_nominal/rho/vBoi_design/Modelica.Constants.pi)
      "Hydraulic diameter of pipes"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Length lengthPipBoiValDHW=6
    "Length of all pipes between boiler valve to DHW storage and back"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeBoiValDHW=facPerBend*4
    "Factor for resistance due to bends, fittings etc. between boiler valve to DHW storage and back"
    annotation (Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length lengthPipBoiValHydSep=0.8
    "Length of all pipes in boiler valve and hydraulic separator circuit"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeBoiValHydSep=facPerBend*2
    "Factor for resistance due to bends, fittings etc. between boiler valve and hydraulic separator"
    annotation (Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length lengthPipBoiToBoiVal=0.8
    "Length of all pipes in boiler valve and boiler"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeBoiToBoiVal=facPerBend*2
    "Factor for resistance due to bends, fittings etc. between boiler valve and boiler"
    annotation (Dialog(tab="Pressure losses"));

  replaceable parameter BESMod.Systems.Hydraulical.Generation.RecordsCollection.AutoparameterBoiler
    parBoi(Q_nom=max(11000, Q_flow_design[1]))
           constrainedby
    AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition(
      Q_nom=max(11000, Q_flow_nominal[1]))
    "Parameters for Boiler"
    annotation(Placement(transformation(extent={{84,124},{96,136}})),
      choicesAllMatching=true, Dialog(group="Component data"));
  replaceable parameter BESMod.Systems.RecordsCollection.Movers.DPVar parPumBoi
    constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition(iconName="Pump Boi")
    "Boiler pump parameters" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{44,124},{56,136}})));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve parThrWayValBoi
    constrainedby BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final m_flow_nominal=mBoi_flow_nominal,
    iconName="BoiWayValve",
    final dp_nominal={0,0},
    dpFixedExtra_nominal={resBoiValHydSep.dp_nominal,resBoiValDHW.dp_nominal + stoDHW.dpHC2Fixed_nominal},
    final fraK=1,
    use_strokeTime=false) "Parameters for three way valve of boiler" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{64,124},{76,136}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.HydraulicSeparator
    parHydSep constrainedby
    RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    iconName="HydSep",
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
    final m_flow_nominal=mBoi_flow_nominal,
    final m_flow_small=1E-4*abs(mBoi_flow_nominal),
    final show_T=show_T,
    dp_nominal=boi.a*(boi.m_flow_nominal/boi.rho_default)^boi.n +
        resBoiToBoiVal.dp_nominal,
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    final tau=parTemSen.tau,
    final initType=parTemSen.initType,
    final transferHeat=parTemSen.transferHeat,
    final TAmb=parTemSen.TAmb,
    final tauHeaTra=parTemSen.tauHeaTra,
    final energyDynamics=energyDynamics,
    final etaLoadBased=parBoi.eta,
    final G=0.003*parBoi.Q_nom/50,
    final C=1.5*parBoi.Q_nom,
    final Q_nom=parBoi.Q_nom,
    final V=parBoi.volume,
    final etaTempBased=etaTem,
    final paramBoiler=parBoi,
    T_out(unit="K", displayUnit="degC"))
    "Boiler with no control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={150,20})));

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
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,10})));
  AixLib.Fluid.Storage.StorageDetailed hydSep(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final mSenFac=1,
    redeclare package MediumHC1 = IBPSA.Media.Water,
    redeclare package MediumHC2 = IBPSA.Media.Water,
    final m1_flow_nominal=mBoi_flow_nominal,
    final m2_flow_nominal=mDem_flow_design[1],
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
    final allowFlowReversal_HC2=allowFlowReversal) "Hydraulic separator"
    annotation (Placement(transformation(extent={{40,2},{24,22}})));

  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
                                                     pumBoi(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mBoi_flow_nominal,
    final dp_nominal=boi.dp_nominal + (parThrWayValBoi.dpValve_nominal +
        parThrWayValBoi.dpMax_nominal),
    externalCtrlTyp=parPumBoi.externalCtrlTyp,
    ctrlType=parPumBoi.ctrlType,
    dpVarBase_nominal=parPumBoi.dpVarBase_nominal,
    final addPowerToMedium=parPumBoi.addPowerToMedium,
    final use_riseTime=parPumBoi.use_riseTime,
    final riseTime=parPumBoi.riseTime) "Pump in supply line of boiler"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={112,-4})));

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
  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameterDPFixed
    resBoiToBoiVal(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mBoi_flow_nominal,
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPipBoi_design,
    final length=lengthPipBoiToBoiVal,
    final ReC=ReC,
    final v_nominal=vBoi_design,
    final roughness=roughness,
    disableComputeFlowResistance=true,
    final resCoe=resCoeBoiToBoiVal)
    "Pressure drop due to resistances between boiler valve and buffer storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,24})));
  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameterDPFixed
    resBoiValHydSep(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mBoi_flow_nominal,
    final show_T=show_T,
    final dh=dPipBoi_design,
    final length=lengthPipBoiValHydSep,
    final ReC=ReC,
    final v_nominal=vBoi_design,
    final from_dp=false,
    final linearized=false,
    final roughness=roughness,
    disableComputeFlowResistance=true,
    final resCoe=resCoeBoiValHydSep)
    "Pressure drop due to resistances between boiler valve and hydraulic sepearator"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameterDPFixed
    resBoiValDHW(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mBoi_flow_nominal,
    final dh=dPipBoi_design,
    final length=lengthPipBoiValDHW,
    final ReC=ReC,
    final v_nominal=vBoi_design,
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final roughness=roughness,
    disableComputeFlowResistance=true,
    final resCoe=resCoeBoiValDHW)
    "Pressure drop due to resistances between boiler valve and DHW storage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,-84})));
initial algorithm
  assert(use_dhw, "This system can only be simulated with use_dhw=true", AssertionLevel.error);
  assert(parStoDHW.qHC2_flow_nominal * 1000 > 0.25, "In " + getInstanceName() +
      ": Storage heat exchanger is probably to small and the calculated heat 
      transfer coefficient to high. VDI 4645 suggests at least 0.25 m2/kW, 
      you have " + String(parStoDHW.qHC2_flow_nominal * 1000) + "m2/W", AssertionLevel.warning);
equation
  connect(thrWayValBoiDHW.uBuf, sigBusDistr.uThrWayVal) annotation (Line(points={{70,22},
          {70,32},{0,32},{0,101}},                           color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senTBuiSup.port_b, portBui_out[1]) annotation (Line(points={{86,80},{96,
          80},{96,80},{100,80}},    color={0,127,255}));
  connect(hydSep.fluidportTop2, senTBuiSup.port_a) annotation (Line(points={{29.5,
          22.1},{29.5,80},{66,80}},                 color={0,127,255}));
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
  connect(boi.T_out, sigBusDistr.TBoiOut) annotation (Line(points={{142.8,16.8},
          {126,16.8},{126,101},{0,101}},           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boi.u_rel, sigBusDistr.yBoi) annotation (Line(points={{157,13},{166,13},
          {166,101},{0,101}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(stoDHW.portHC2Out, thrWayValBoiDHW.portDHW_a) annotation (Line(points={{-50.2,
          -61.4},{-52,-61.4},{-52,-76},{52,-76},{52,2.4},{60,2.4}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_a, stoBuf.fluidportBottom1)
    annotation (Line(points={{-40,154},{12,154},{12,86},{-54,86},{-54,-10},{-39.4,
          -10},{-39.4,-0.4}},
        color={0,127,255}));
  connect(stoBuf.fluidportTop1, resValToBufSto.port_b) annotation (Line(points={
          {-39.6,40.2},{-39.6,88},{16,88},{16,160},{0,160}}, color={0,127,255}));
  connect(thrWayValBoiDHW.portDHW_b, resBoiValDHW.port_a) annotation (Line(
        points={{60,6.4},{56,6.4},{56,-84},{0,-84}}, color={0,127,255}));
  connect(resBoiValDHW.port_b, stoDHW.portHC2In) annotation (Line(points={{-20,-84},
          {-58,-84},{-58,-55},{-50.2,-55}}, color={0,127,255}));
  connect(thrWayValBoiDHW.portBui_b, hydSep.fluidportTop1) annotation (Line(
        points={{60,18},{56,18},{56,28},{34.8,28},{34.8,22.1}},
                                                              color={0,127,255}));
  connect(resBoiValHydSep.port_a, thrWayValBoiDHW.portBui_a) annotation (Line(
        points={{0,-10},{-4,-10},{-4,-18},{50,-18},{50,14},{60,14}},
                                                  color={0,127,255}));
  connect(resBoiValHydSep.port_b, hydSep.fluidportBottom1) annotation (Line(
        points={{20,-10},{34.7,-10},{34.7,1.8}},                  color={0,127,
          255}));
  connect(pumTra.port_b, stoBuf.fluidportBottom2) annotation (Line(points={{60,40},
          {48,40},{48,48},{-12,48},{-12,-4},{-29.4,-4},{-29.4,-0.2}}, color={0,127,
          255}));
  connect(thrWayValBoiDHW.portGen_b, pumBoi.port_a) annotation (Line(points={{80,6.4},
          {92,6.4},{92,-4},{102,-4}},                      color={0,127,255}));
  connect(stoBuf.fluidportTop2, hydSep.fluidportBottom2) annotation (Line(
        points={{-29,40.2},{-30,40.2},{-30,44},{18,44},{18,-2},{30,-2},{30,0},{29.7,
          0},{29.7,1.9}}, color={0,127,255}));
  connect(boi.u_rel, pumBoi.y) annotation (Line(points={{157,13},{166,13},{166,
          4},{128,4},{128,8},{112,8}},
                              color={0,0,127}));
  connect(pumBoi.port_b, boi.port_a)
    annotation (Line(points={{122,-4},{168,-4},{168,20},{160,20}},
                                                 color={0,127,255}));
  connect(resBoiToBoiVal.port_a, boi.port_b)
    annotation (Line(points={{120,24},{130,24},{130,20},{140,20}},
                                                 color={0,127,255}));
  connect(resBoiToBoiVal.port_b, thrWayValBoiDHW.portGen_a) annotation (Line(
        points={{100,24},{86,24},{86,14.4},{80,14.4}}, color={0,127,255}));
  connect(pumBoi.P, multiSum.u[5]) annotation (Line(points={{123,2},{123,10},{
          124,10},{124,-94},{-76,-94},{-76,-111},{-58,-111}}, color={0,0,127}));
  connect(pumBoi.y, sigBusDistr.uPumBoi) annotation (Line(points={{112,8},{128,
          8},{128,4},{166,4},{166,104},{0,104},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumBoi.on, sigBusDistr.pumBoiOn) annotation (Line(points={{107,8},{
          128,8},{128,-4},{168,-4},{168,101},{0,101}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{180,180}})));
end TwoStoragesBoilerWithDHW;
