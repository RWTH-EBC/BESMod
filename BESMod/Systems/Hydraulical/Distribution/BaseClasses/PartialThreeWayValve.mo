within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialThreeWayValve "Partial model to later extent"
  extends BaseClasses.PartialDistribution(
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    final nParallelSup=1,
    final nParallelDem=1);

  parameter Modelica.Units.SI.PressureDifference dpBufHCSto_design
    "Design pressure difference for possible buffer storage heating coil";
  parameter Modelica.Units.SI.PressureDifference dpDHWHCSto_design
    "Design pressure difference for DHW storage heating coil";

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
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    parThrWayVal constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    iconName="3WayValve",
    final dp_nominal={dpBufHCSto_design + resValToBufSto.dp_nominal,
        dpDHWHCSto_design + resValToDHWSto.dp_nominal},
    final m_flow_nominal=mSup_flow_design[1],
    final fraK=1,
    use_strokeTime=false) "Parameters for three way valve" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{64,164},{76,176}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.DPVar parPumGen constrainedby
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition(iconName=
        "Pump Gen", externalCtrlTyp=BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.onOff)
    "Parameters for pump feeding supply system (generation)" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{84,164},{96,176}})));
  BESMod.Systems.Hydraulical.Distribution.Components.Valves.ThreeWayValveWithFlowReturn threeWayValveWithFlowReturn(
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
    final dp_nominal=dpSup_design[1] + (parThrWayVal.dpValve_nominal + max(
        parThrWayVal.dp_nominal)),
    final externalCtrlTyp=parPumGen.externalCtrlTyp,
    final ctrlType=parPumGen.ctrlType,
    final dpVarBase_nominal=parPumGen.dpVarBase_nominal,
    final addPowerToMedium=parPumGen.addPowerToMedium,
    final use_riseTime=parPumGen.use_riseTime,
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
    final dh=dPipSup_design[1],
    final length=lengthPipValBufSto,
    final resCoe=resCoeValBufSto,
    final ReC=ReC,
    final v_nominal=vSup_design[1],
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
    final dh=dPipSup_design[1],
    final length=lengthPipValDHWSto,
    final resCoe=resCoeValDHWSto,
    final ReC=ReC,
    final v_nominal=vSup_design[1],
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
  connect(pumGen.on, sigBusDistr.pumGenOn) annotation (Line(points={{-68,125},{-60,
          125},{-60,120},{0,120},{0,101}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,180}})));
end PartialThreeWayValve;
