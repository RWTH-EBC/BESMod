within BESMod.Systems.Hydraulical.Distribution;
model TwoStoragesBoilerWithDHW
  "Two storages with a boiler after buffer and with DHW support"
  extends BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDistribution(
    final dpDem_nominal={0},
    final dpSup_nominal={2*(parThrWayVal1.dpValve_nominal + max(
        parThrWayVal1.dp_nominal))},
    final dTTraDHW_nominal=parStoDHW.dTLoadingHC1,
    final dTTra_nominal={parStoBuf.dTLoadingHC1},
    final m_flow_nominal=mDem_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    final nParallelSup=1,
    final nParallelDem=1);

     parameter Modelica.Units.SI.Power Q_nom=boiNoCtrl.paramBoiler.Q_nom
    "Nominal heating power";

     parameter Modelica.Units.SI.Volume V=boiNoCtrl.paramBoiler.volume "Volume";

   parameter Real mSup2_flow_nominal= 10;

 parameter Modelica.Units.SI.PressureDifference dpBufHCSto_nominal=0
   "Nominal pressure difference in buffer storage heating coil";
 final parameter Modelica.Units.SI.PressureDifference dpDHWHCSto_nominal=sum(
     stoDHW.heatingCoil1.pipe.res.dp_nominal)
   "Nominal pressure difference in DHW storage heating coil";
 parameter Modelica.Units.SI.HeatFlowRate QHRAftBuf_flow_nominal
   "Nominal heat flow rate of heating rod after DHW storage"
   annotation (Dialog(enable=use_heatingRodAfterBuffer));
 parameter Boolean use_heatingRodAfterBuffer "=false to disable the Boiler after the buffer storage";
 parameter Integer discretizationStepsDWHStoHR=0
   "Number of steps to dicretize. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1";
 parameter Integer discretizationStepsBufStoHR=0
   "Number of steps to dicretize. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1";
 replaceable parameter
   BESMod.Systems.RecordsCollection.TemperatureSensors.TemperatureSensorBaseDefinition
   parTemSen
   annotation (choicesAllMatching=true, Placement(transformation(extent={{126,116},
            {144,130}})));
 replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve parThrWayVal1
    constrainedby BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={dpBufHCSto_nominal,dpDHWHCSto_nominal},
    final m_flow_nominal=mSup_flow_nominal[1],
    final fraK=1,
    use_inputFilter=false) annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-182,110},{-162,130}})));

replaceable
   BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
   parStoBuf(discretizationStepsHR=2)
                 constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
   final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
   final rho=rho,
   final c_p=cp,
   final TAmb=TAmb,
   T_m=TSup_nominal[1],
   final QHC1_flow_nominal=Q_flow_nominal[1]*f_design[1],
   final mHC1_flow_nominal=mSup_flow_nominal[1],
   redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1,
   final use_HC2=stoBuf.useHeatingCoil2,
   final use_HC1=stoBuf.useHeatingCoil1,
   final dTLoadingHC1=0,
   final dTLoadingHC2=9999999,
   final fHeiHC2=1,
   final fDiaHC2=1,
   final QHC2_flow_nominal=9999999,
   final mHC2_flow_nominal=9999999,
   redeclare final AixLib.DataBase.Pipes.Copper.Copper_10x0_6 pipeHC2)
   annotation (choicesAllMatching=true, Placement(transformation(extent={{18,26},
           {32,40}})));

  replaceable
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
    parStoDHW(redeclare final AixLib.DataBase.Pipes.Copper.Copper_28x1
      pipeHC1, redeclare final AixLib.DataBase.Pipes.Copper.Copper_28x1 pipeHC2)
    constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    final rho=rho,
    final c_p=cp,
    final TAmb=TAmb,
    final use_HC1=stoDHW.useHeatingCoil1,
    final QHC1_flow_nominal=Q_flow_nominal[1]*f_design[1],
    final V=VDHWDay,
    final Q_flow_nominal=QDHW_flow_nominal,
    final VPerQ_flow=0,
    T_m=TDHW_nominal,
    final mHC1_flow_nominal=mSup_flow_nominal[1],
    redeclare final AixLib.DataBase.Pipes.Copper.Copper_12x1 pipeHC1,
    final use_HC2=stoDHW.useHeatingCoil2,
    final dTLoadingHC2=5,
    final fHeiHC2=1,
    final fDiaHC2=1,
    final mHC2_flow_nominal=pumpBoiler.m_flow_nominal,
    final QHC2_flow_nominal=boiNoCtrl.paramBoiler.Q_nom,
    redeclare final AixLib.DataBase.Pipes.Copper.Copper_10x0_6 pipeHC2)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{20,-62},
            {34,-48}})));

 Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureBuf(final T=parStoBuf.TAmb)           annotation (Placement(transformation(
       extent={{-12,-12},{12,12}},
       rotation=0,
       origin={-82,2})));
 Modelica.Blocks.Sources.RealExpression T_stoDHWTop(final y(unit="K", displayUnit="degC")=stoDHW.layer[
       parStoDHW.nLayer].T) annotation (Placement(transformation(
       extent={{-17,-6},{17,6}},
       rotation=0,
       origin={-33,70})));
 Modelica.Blocks.Sources.RealExpression T_stoBufTop(final y(unit="K", displayUnit="degC")=stoBuf.layer[
       parStoBuf.nLayer].T) annotation (Placement(transformation(
       extent={{-16,-5},{16,5}},
       rotation=0,
       origin={-34,87})));
 Modelica.Blocks.Sources.RealExpression T_stoBufBot(final y(unit="K", displayUnit="degC")=stoBuf.layer[1].T)
   annotation (Placement(transformation(
       extent={{-16,-5},{16,5}},
       rotation=0,
       origin={-34,79})));
 Modelica.Blocks.Sources.RealExpression T_stoDHWBot(final y(unit="K", displayUnit="degC")=stoDHW.layer[1].T)
   annotation (Placement(transformation(
       extent={{-16,-5},{16,5}},
       rotation=0,
       origin={-34,95})));

 Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureDHW(final T=parStoDHW.TAmb)           annotation (Placement(transformation(
       extent={{-10,-10},{10,10}},
       rotation=0,
       origin={-72,-88})));

 AixLib.Fluid.Storage.BufferStorage stoBuf(
   redeclare final package Medium = Medium,
   final energyDynamics=energyDynamics,
   final p_start=p_start,
   final mSenFac=1,
   redeclare package MediumHC1 = MediumGen,
   redeclare package MediumHC2 = MediumGen,
   final m1_flow_nominal=mSup_flow_nominal[1],
   final m2_flow_nominal=m_flow_nominal[1],
   final mHC1_flow_nominal=parStoBuf.mHC1_flow_nominal,
   final mHC2_flow_nominal=parStoBuf.mHC2_flow_nominal,
    useHeatingCoil1=false,
   final useHeatingCoil2=false,
   final useHeatingRod=parStoBuf.use_hr,
   final TStart=T_start,
   redeclare final BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.bufferData
                                                              data(
     final hTank=parStoBuf.h,
     hHC1Low=0,
     hHR=parStoBuf.nLayerHR/parStoBuf.nLayer*parStoBuf.h,
     final dTank=parStoBuf.d,
     final sWall=parStoBuf.sIns/2,
     final sIns=parStoBuf.sIns/2,
     final lambdaWall=parStoBuf.lambda_ins,
     final lambdaIns=parStoBuf.lambda_ins,
     final rhoIns=373000,
     final cIns=1000,
     pipeHC1=parStoBuf.pipeHC1,
     pipeHC2=parStoBuf.pipeHC2,
     lengthHC1=parStoBuf.lengthHC1,
     lengthHC2=parStoBuf.lengthHC2),
   final n=parStoBuf.nLayer,
   final hConIn=parStoBuf.hConIn,
   final hConOut=parStoBuf.hConOut,
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
   final allowFlowReversal_HC2=allowFlowReversal)
   annotation (Placement(transformation(extent={{-36,14},{0,58}})));

 AixLib.Fluid.Storage.BufferStorage stoDHW(
   redeclare final package Medium = MediumDHW,
   final energyDynamics=energyDynamics,
   final p_start=p_start,
   final mSenFac=1,
   redeclare final package MediumHC1 = MediumGen,
   redeclare final package MediumHC2 = MediumGen,
   final m1_flow_nominal=mSup_flow_nominal[1],
   final m2_flow_nominal=mDHW_flow_nominal,
   final mHC1_flow_nominal=parStoDHW.mHC1_flow_nominal,
   final mHC2_flow_nominal=parStoDHW.mHC2_flow_nominal,
   final useHeatingCoil1=true,
    final useHeatingCoil2=true,
   final useHeatingRod=parStoDHW.use_hr,
   final TStart=T_start,
   redeclare final BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.bufferData
                                                              data(
     final hTank=parStoDHW.h,
     hHC1Low=0,
     hHR=parStoDHW.nLayerHR/parStoDHW.nLayer*parStoDHW.h,
     final dTank=parStoDHW.d,
     final sWall=parStoDHW.sIns/2,
     final sIns=parStoDHW.sIns/2,
     final lambdaWall=parStoDHW.lambda_ins,
     final lambdaIns=parStoDHW.lambda_ins,
     final rhoIns=373000,
     final cIns=1000,
     pipeHC1=parStoDHW.pipeHC1,
     pipeHC2=parStoDHW.pipeHC2,
     lengthHC1=parStoDHW.lengthHC1,
     lengthHC2=parStoDHW.lengthHC2),
   final n=parStoDHW.nLayer,
   final hConIn=parStoDHW.hConIn,
   final hConOut=parStoDHW.hConOut,
   final hConHC1=parStoDHW.hConHC1,
   final hConHC2=parStoDHW.hConHC2,
   final upToDownHC1=true,
   final upToDownHC2=true,
   final TStartWall=T_start,
   final TStartIns=T_start,
   redeclare model HeatTransfer =
       AixLib.Fluid.Storage.BaseClasses.HeatTransferBuoyancyWetter,
   final allowFlowReversal_layers=allowFlowReversal,
   final allowFlowReversal_HC1=allowFlowReversal,
   final allowFlowReversal_HC2=allowFlowReversal)
   annotation (Placement(transformation(extent={{-36,-74},{0,-28}})));

 Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHRStoDHWPre_flow(final
     T_ref=293.15, final alpha=0) if parStoDHW.use_hr annotation (
     Placement(transformation(
       extent={{-7,-7},{7,7}},
       rotation=0,
       origin={-69,-51})));
 Modelica.Blocks.Math.Gain gain(k=parStoDHW.QHR_flow_nominal)
if parStoDHW.use_hr
   annotation (Placement(transformation(extent={{-102,-60},{-86,-42}})));
 Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QHRStoBufPre_flow1(final
     T_ref=293.15, final alpha=0) if parStoBuf.use_hr annotation (
     Placement(transformation(
       extent={{-7,-7},{7,7}},
       rotation=0,
       origin={-47,35})));
 Modelica.Blocks.Math.Gain gainHRBuf(k=parStoBuf.QHR_flow_nominal)
if parStoBuf.use_hr
   annotation (Placement(transformation(extent={{-80,18},{-64,36}})));

  BESMod.Systems.Hydraulical.Distribution.Components.Valves.ThreeWayValveWithFlowReturn
    threeWayValveWithFlowReturn(
    redeclare package Medium = MediumGen,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters=parThrWayVal1)
    annotation (Placement(transformation(extent={{-84,54},{-64,74}})));

 IBPSA.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
   redeclare final package Medium = Medium,
   final allowFlowReversal=allowFlowReversal,
   m_flow_nominal=m_flow_nominal[1],
   tau=parTemSen.tau,
   initType=parTemSen.initType,
   T_start=T_start,
   final transferHeat=parTemSen.transferHeat,
   TAmb=parTemSen.TAmb,
   tauHeaTra=parTemSen.tauHeaTra)
   "Temperature at supply for building" annotation (Placement(transformation(
       extent={{5,6},{-5,-6}},
       rotation=180,
       origin={87,76})));

 BESMod.Utilities.Electrical.ZeroLoad zeroLoad
   annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
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
    annotation (Placement(transformation(extent={{26,84},{48,112}})));
  BESMod.Systems.Hydraulical.Distribution.Components.Valves.ThreeWayValveWithFlowReturn
    threeWayValveWithFlowReturn2(
    redeclare package Medium = MediumGen,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters(m_flow_nominal=m_flow_nominal[1], dp_nominal={0, sum(stoDHW.heatingCoil2.pipe.res.dp_nominal)}))
    annotation (Placement(transformation(extent={{38,48},{58,68}})));
  AixLib.Fluid.Storage.BufferStorage HydraulischeWeiche(
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
    useHeatingCoil1=false,
    final useHeatingCoil2=false,
    final useHeatingRod=false,
    final TStart=T_start,
    redeclare final
      BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.bufferData
      data(
      final hTank=hydParameters.h,
      hHC1Low=0,
      hHR=hydParameters.nLayerHR/hydParameters.nLayer*parStoBuf.h,
      final dTank=hydParameters.d,
      final sWall=hydParameters.sIns/2,
      final sIns=hydParameters.sIns/2,
      final lambdaWall=hydParameters.lambda_ins,
      final lambdaIns=hydParameters.lambda_ins,
      final rhoIns=373000,
      final cIns=1000,
      pipeHC1=hydParameters.pipeHC1,
      pipeHC2=hydParameters.pipeHC2,
      lengthHC1=hydParameters.lengthHC1,
      lengthHC2=hydParameters.lengthHC2),
    final n=hydParameters.nLayer,
    final hConIn=hydParameters.hConIn,
    final hConOut=hydParameters.hConOut,
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
    final allowFlowReversal_HC2=allowFlowReversal)
    "Hydraulische Weiche falls Radiator Ventil zu ist und Boiler eingeschaltet wird, (damit System nicht überhitzt)"
    annotation (Placement(transformation(extent={{66,58},{78,74}})));
replaceable
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition
    hydParameters constrainedby
    BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    final Q_flow_nominal=Q_flow_nominal[1]*f_design[1],
    final rho=rho,
    final c_p=cp,
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
    annotation (choicesAllMatching=true, Placement(transformation(extent={{134,26},
            {148,40}})));
  IBPSA.Fluid.Movers.SpeedControlled_y pumpBoiler(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=false,
    final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      final speed_rpm_nominal=parPum.speed_rpm_nominal,
      final m_flow_nominal=m_flow_nominal[1],
      final dp_nominal=boiNoCtrl.dp_nominal + 2*(threeWayValveWithFlowReturn2.parameters.dpValve_nominal
           + threeWayValveWithFlowReturn2.parameters.dp_nominal[1] +
          threeWayValveWithFlowReturn2.parameters.dpFixed_nominal[1]),
      final rho=rho,
      final V_flowCurve=parPum.V_flowCurve,
      final dpCurve=parPum.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=parPum.addPowerToMedium,
    final tau=parPum.tau,
    final use_inputFilter=parPum.use_inputFilter,
    final riseTime=parPum.riseTimeInpFilter,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1) annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=180,
        origin={9,65})));
  Modelica.Blocks.Sources.Constant const4(k=1)
    annotation (Placement(transformation(extent={{4,84},{10,90}})));
  parameter
    BESMod.Systems.RecordsCollection.Movers.DefaultMover
    parPum annotation (Dialog(group="Component data"),
    choicesAllMatching=true, Placement(transformation(extent={{52,152},{74,174}})));
  parameter BESMod.Systems.RecordsCollection.Movers.DefaultMover defaultMoverBA
    annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-64,158},{-30,180}})));
  Utilities.KPIs.EnergyKPICalculator KPIBoi(use_inpCon=true)
    annotation (Placement(transformation(extent={{108,164},{128,184}})));

    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemBuf(final T=
        parStoBuf.TAmb) "Constant ambient temperature of storage";

        Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTemDHW(final T=
        parStoDHW.TAmb) "Constant ambient temperature of storage";

  Utilities.KPIs.EnergyKPICalculator eneKPICalBuf(use_inpCon=false, y=fixTemBuf.port.Q_flow)
    annotation (Placement(transformation(extent={{-42,-118},{-22,-98}})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalDHW(use_inpCon=false, y=fixTemDHW.port.Q_flow)
    annotation (Placement(transformation(extent={{-42,-158},{-22,-138}})));
equation
 connect(T_stoDHWBot.y, sigBusDistr.TStoDHWBotMea) annotation (Line(points={{-16.4,
         95},{2.5,95},{2.5,101},{0,101}},              color={0,0,127}), Text(
     string="%second",
     index=1,
     extent={{-6,3},{-6,3}},
     horizontalAlignment=TextAlignment.Right));
 connect(T_stoDHWTop.y, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-14.3,
         70},{-2,70},{-2,101},{0,101}},              color={0,0,127}), Text(
     string="%second",
     index=1,
     extent={{-6,3},{-6,3}},
     horizontalAlignment=TextAlignment.Right));
 connect(T_stoBufBot.y, sigBusDistr.TStoBufBotMea) annotation (Line(points={{-16.4,
         79},{0,79},{0,101}},                      color={0,0,127}), Text(
     string="%second",
     index=1,
     extent={{-3,-6},{-3,-6}},
     horizontalAlignment=TextAlignment.Right));
 connect(T_stoBufTop.y, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-16.4,
         87},{0,87},{0,101}},                                  color={0,0,127}),
     Text(
     string="%second",
     index=1,
     extent={{-6,3},{-6,3}},
     horizontalAlignment=TextAlignment.Right));
 connect(fixedTemperatureDHW.port, stoDHW.heatportOutside) annotation (
     Line(points={{-62,-88},{14,-88},{14,-49.62},{-0.45,-49.62}},color={191,0,0}));
 connect(stoBuf.heatportOutside, fixedTemperatureBuf.port) annotation (
     Line(points={{-0.45,37.32},{12,37.32},{12,2},{-70,2}},color={191,0,0}));
 connect(portDHW_in, stoDHW.fluidportBottom2) annotation (Line(points={{100,
         -82},{-12,-82},{-12,-74.23},{-12.825,-74.23}}, color={0,127,255}));
 connect(stoDHW.heatingRod, QHRStoDHWPre_flow.port) annotation (Line(
     points={{-36,-51},{-62,-51}},
     color={191,0,0},
     pattern=LinePattern.Dash));
 connect(QHRStoDHWPre_flow.Q_flow, gain.y) annotation (Line(
     points={{-76,-51},{-85.2,-51}},
     color={0,0,127},
     pattern=LinePattern.Dash));
 connect(QHRStoBufPre_flow1.Q_flow, gainHRBuf.y) annotation (Line(
     points={{-54,35},{-58,35},{-58,27},{-63.2,27}},
     color={0,0,127},
     pattern=LinePattern.Dash));
 connect(QHRStoBufPre_flow1.port, stoBuf.heatingRod) annotation (Line(
     points={{-40,35},{-40,36},{-36,36}},
     color={191,0,0},
     pattern=LinePattern.Dash));
 connect(portGen_in[1], threeWayValveWithFlowReturn.portGen_a) annotation (
     Line(points={{-100,80},{-92,80},{-92,68.4},{-84,68.4}}, color={0,127,255}));
 connect(portGen_out[1], threeWayValveWithFlowReturn.portGen_b) annotation (
     Line(points={{-100,40},{-96,40},{-96,38},{-92,38},{-92,60},{-84,60},{-84,60.4}},
       color={0,127,255}));
 connect(threeWayValveWithFlowReturn.portDHW_b, stoDHW.portHC1In)
   annotation (Line(points={{-64,60.4},{-60,60.4},{-60,60},{-46,60},{-46,-37.89},
         {-36.45,-37.89}}, color={0,127,255}));
 connect(stoDHW.portHC1Out, threeWayValveWithFlowReturn.portDHW_a)
   annotation (Line(points={{-36.225,-45.02},{-52,-45.02},{-52,56.4},{-64,56.4}},
       color={0,127,255}));
 connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
    Line(points={{-74,76},{-74,101},{0,101}}, color={0,0,127}), Text(
     string="%second",
     index=1,
     extent={{-3,6},{-3,6}},
     horizontalAlignment=TextAlignment.Right));
 connect(senTBuiSup.T, sigBusDistr.TBuiSupMea) annotation (Line(points={{87,82.6},
          {86,82.6},{86,96},{32,96},{32,94},{28,94},{28,92},{0,92},{0,101}},
                                                                    color={0,0,
         127}), Text(
     string="%second",
     index=1,
     extent={{-3,6},{-3,6}},
     horizontalAlignment=TextAlignment.Right));
 connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
     Line(
     points={{50,-98},{70,-98}},
     color={0,0,0},
     thickness=1));
 connect(stoDHW.fluidportTop2, portDHW_out) annotation (Line(points={{-12.375,
         -27.77},{-12.375,-20},{100,-20},{100,-22}}, color={0,127,255}));
  connect(stoBuf.fluidportTop1, threeWayValveWithFlowReturn.portBui_b)
    annotation (Line(points={{-24.3,58.22},{-52,58.22},{-52,62},{-56,62},{-56,72},
          {-64,72}}, color={0,127,255}));
  connect(stoBuf.fluidportBottom1, threeWayValveWithFlowReturn.portBui_a)
    annotation (Line(points={{-24.075,13.56},{-24.075,6},{-42,6},{-42,68},{-64,68}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn2.portGen_b, stoBuf.fluidportBottom2)
    annotation (Line(points={{38,54.4},{10,54.4},{10,4},{-12.825,4},{-12.825,
          13.78}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn2.portDHW_b, stoDHW.portHC2In)
    annotation (Line(points={{58,54.4},{60,54.4},{60,-18},{-48,-18},{-48,-56.75},
          {-36.225,-56.75}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn2.portDHW_a, stoDHW.portHC2Out)
    annotation (Line(points={{58,50.4},{64,50.4},{64,-84},{-38,-84},{-38,-78},{
          -40,-78},{-40,-64.11},{-36.225,-64.11}},
                             color={0,127,255}));
  connect(threeWayValveWithFlowReturn2.portBui_a, HydraulischeWeiche.fluidportBottom1)
    annotation (Line(points={{58,62},{64,62},{64,54},{69.975,54},{69.975,57.84}},
        color={0,127,255}));
  connect(threeWayValveWithFlowReturn2.portBui_b, HydraulischeWeiche.fluidportTop1)
    annotation (Line(points={{58,66},{64,66},{64,78},{69.9,78},{69.9,74.08}},
        color={0,127,255}));
  connect(stoBuf.fluidportTop2, pumpBoiler.port_a) annotation (Line(points={{-12.375,
          58.22},{-12.375,65},{4,65}},           color={0,127,255}));
  connect(pumpBoiler.port_b, boiNoCtrl.port_a)
    annotation (Line(points={{14,65},{26,65},{26,98}}, color={0,127,255}));
  connect(const4.y, pumpBoiler.y) annotation (Line(points={{10.3,87},{10.3,80},
          {9,80},{9,71}}, color={0,0,127}));
  connect(boiNoCtrl.port_b, threeWayValveWithFlowReturn2.portGen_a) annotation (
     Line(points={{48,98},{54,98},{54,68},{32,68},{32,62.4},{38,62.4}}, color={
          0,127,255}));
  connect(threeWayValveWithFlowReturn2.uBuf, sigBusDistr.uThrWayVal)
    annotation (Line(points={{48,70},{50,70},{50,120},{0,120},{0,101}}, color={
          0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portBui_in[1], HydraulischeWeiche.fluidportBottom2) annotation (Line(
        points={{100,40},{73.725,40},{73.725,57.92}}, color={0,127,255}));
  connect(senTBuiSup.port_b, portBui_out[1]) annotation (Line(points={{92,76},{
          96,76},{96,80},{100,80}}, color={0,127,255}));
  connect(senTBuiSup.port_a, HydraulischeWeiche.fluidportTop2) annotation (Line(
        points={{82,76},{73.875,76},{73.875,74.08}}, color={0,127,255}));
  connect(gain.u, sigBusDistr.uHRStoDHW) annotation (Line(points={{-103.6,-51},{
          -138,-51},{-138,120},{0,120},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(gainHRBuf.u, sigBusDistr.uHRAftBuf) annotation (Line(points={{-81.6,27},
          {-118,27},{-118,101},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(boiNoCtrl.T_out, sigBusDistr.TBoilerOutDistribution) annotation (Line(
        points={{44.92,102.48},{68,102.48},{68,140},{0,140},{0,101}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boiNoCtrl.thermalPower, KPIBoi.u) annotation (Line(points={{44.92,
          109.76},{44.92,108},{106.2,108},{106.2,174}}, color={0,0,127}));
  connect(sigBusDistr.yBoilerDistribution, boiNoCtrl.u_rel) annotation (Line(
      points={{0,101},{0,136},{30,136},{30,118},{29.3,118},{29.3,107.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(eneKPICalDHW.KPI, outBusDist.QDHWLos_flow) annotation (Line(points={{-19.8,
          -148},{-19.8,-120},{-14,-120},{-14,-86},{0,-86},{0,-100}},
                                        color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(eneKPICalBuf.KPI, outBusDist.QBufLos_flow) annotation (Line(points={{-19.8,
          -108},{-18,-108},{-18,-86},{0,-86},{0,-100}},
                                        color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIBoi.KPI, outBusDist.QBoi_Distribution_flow) annotation (Line(
        points={{130.2,174},{176,174},{176,-156},{0,-156},{0,-100}}, color={135,
          135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TwoStoragesBoilerWithDHW;
