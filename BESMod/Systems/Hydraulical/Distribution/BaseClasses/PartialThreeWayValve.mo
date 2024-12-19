within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialThreeWayValve "Partial model to later extent"
  extends BaseClasses.PartialDistribution(
    Q_flow_design={if use_old_design[i] then QOld_flow_design[i] else
        Q_flow_nominal[i] for i in 1:nParallelDem},
    m_flow_design={if use_old_design[i] then mOld_flow_design[i] else
        m_flow_nominal[i] for i in 1:nParallelDem},
    mSup_flow_design={if use_old_design[i] then mSupOld_flow_design[i] else
        mSup_flow_nominal[i] for i in 1:nParallelSup},
    mDem_flow_design={if use_old_design[i] then mDemOld_flow_design[i] else
        mDem_flow_nominal[i] for i in 1:nParallelDem},
    final mOld_flow_design=mDemOld_flow_design,
    final dpDem_nominal={0},
    final dpSup_nominal={parThrWayVal.dpValve_nominal + max(parThrWayVal.dp_nominal)},
    final m_flow_nominal=mDem_flow_nominal,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    final nParallelSup=1,
    final nParallelDem=1);

  parameter Boolean use_old_design[nParallelDem]=fill(false, nParallelDem)
    "If true, design parameters of the building with no retrofit (old state) are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dpBufHCSto_nominal
    "Nominal pressure difference for possible buffer storage heating coil";
  final parameter Modelica.Units.SI.PressureDifference dpDHWHCSto_nominal
    "Nominal pressure difference for DHW storage heating coil";

  parameter Modelica.Units.SI.Length lengthPipValDHWSto=0.8
    "Length of all pipes between valve to DHW storage and back"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeValDHWSto=facPerBend*2
    "Factor for resistance due to bends, fittings etc. between valve to DHW storage and back"
    annotation (Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length lengthPipValBufSto=0.8
    "Length of all pipes between valve to buffer storage and back"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeValBufSto=facPerBend*2
    "Factor for resistance due to bends, fittings etc. between valve to buffer storage and back"
    annotation (Dialog(tab="Pressure losses"));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve parThrWayVal(iconName=
        "3WayValve")
    constrainedby BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={
      dpBufHCSto_nominal + resValToBufSto.dp_nominal,
      dpDHWHCSto_nominal + resValToDHWSto.dp_nominal},
    final m_flow_nominal=mSup_flow_design[1],
    final fraK=1,
    use_inputFilter=false) "Parameters for three way valve" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{64,164},{76,176}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPumGen(iconName="Pump Gen")
    "Parameters for pump feeding supply system (generation)" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{84,164},{96,176}})));
  Components.Valves.ThreeWayValveWithFlowReturn threeWayValveWithFlowReturn(
    redeclare package Medium = MediumGen,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters=parThrWayVal)
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));

  AixLib.Fluid.Interfaces.PassThroughMedium pasThrNoDHW(redeclare package
      Medium =
        Medium, allowFlowReversal=allowFlowReversal) if not use_dhw
    "Pass through if DHW is disabled" annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=270,
        origin={-34,144})));
  IBPSA.Fluid.Sources.Boundary_pT bouPum(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    nPorts=1)       "Pressure boundary for pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,170})));

  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled
    pumGen(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_design[1],
    final dp_nominal=dpSup_nominal[1] + (parThrWayVal.dpValve_nominal + max(
        parThrWayVal.dp_nominal)),
    final externalCtrlTyp=parPumGen.externalCtrlTyp,
    final ctrlType=parPumGen.ctrlType,
    final dpVarBase_nominal=parPumGen.dpVarBase_nominal,
    final addPowerToMedium=parPumGen.addPowerToMedium,
    final use_inputFilter=parPumGen.use_inputFilter,
    final riseTime=parPumGen.riseTime,
    final y_start=1) "Pump for supply system (generation)" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,120})));
  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameter resValToBufSto(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_design[1],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPip_design[1],
    final length=lengthPipValBufSto,
    final resCoe=resCoeValBufSto,
    final ReC=ReC,
    final v_nominal=v_design[1],
    final roughness=roughness)
    "Pressure drop due to resistances between valve+pump and buffer storage"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameter resValToDHWSto(
    redeclare final package Medium = MediumGen,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_design[1],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPip_design[1],
    final length=lengthPipValDHWSto,
    final resCoe=resCoeValDHWSto,
    final ReC=ReC,
    final v_nominal=v_design[1],
    final roughness=roughness)
    "Pressure drop due to resistances between valve+pump and DHW storage"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));

equation
  connect(portGen_in[1], threeWayValveWithFlowReturn.portGen_a) annotation (
      Line(points={{-100,80},{-90,80},{-90,154.4},{-60,154.4}},
                                                              color={0,127,255}));
  connect(threeWayValveWithFlowReturn.uBuf, sigBusDistr.uThrWayVal) annotation (
     Line(points={{-50,162},{-50,166},{8,166},{8,120},{0,120},{0,101}},
                                               color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(threeWayValveWithFlowReturn.portDHW_b, pasThrNoDHW.port_a) annotation (
      Line(points={{-40,146.4},{-37,146.4},{-37,146},{-34,146}},
                           color={0,127,255},
      pattern=LinePattern.Dash));
  connect(pasThrNoDHW.port_b, threeWayValveWithFlowReturn.portDHW_a) annotation (
      Line(points={{-34,142},{-37,142},{-37,142.4},{-40,142.4}},
                                    color={0,127,255},
      pattern=LinePattern.Dash));

  connect(pumGen.y, sigBusDistr.uPumGen) annotation (Line(points={{-68,120},{0,120},
          {0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(portGen_out[1], pumGen.port_b) annotation (Line(points={{-100,40},{-80,
          40},{-80,110}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portGen_b, pumGen.port_a) annotation (
      Line(points={{-60,146.4},{-80,146.4},{-80,130}}, color={0,127,255}));
  connect(bouPum.ports[1], pumGen.port_a)
    annotation (Line(points={{-80,160},{-80,130}}, color={0,127,255}));
  connect(resValToBufSto.port_a, threeWayValveWithFlowReturn.portBui_b)
    annotation (Line(points={{-20,160},{-22,160},{-22,158},{-40,158}}, color={0,
          127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, resValToDHWSto.port_a)
    annotation (Line(points={{-40,146.4},{-32,146.4},{-32,140},{-20,140}},
        color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,180}})));
end PartialThreeWayValve;
