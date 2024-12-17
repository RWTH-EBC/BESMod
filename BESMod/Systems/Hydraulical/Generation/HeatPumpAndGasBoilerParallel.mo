within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndGasBoilerParallel
  "Parallel connection of heat pump and gas boiler"
  extends BaseClasses.PartialHeatPumpAndGasBoiler(
    dp_design={resGen.dp_nominal + resGenOut.dp_nominal + parThrWayVal.dpValve_nominal
         + max(parThrWayVal.dp_nominal)},
    final use_old_design=fill(false, nParallelDem), resGen(final length=
          lengthPipValIn, final resCoe=resCoeValIn));
  parameter Modelica.Units.SI.Length lengthPipValIn=3.5
    "Length of all pipes between inlet and three way valve"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeValIn=facPerBend*1
    "Factor for resistance due to bends, fittings etc. between inlet and three way valve"
    annotation (Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length lengthPipValBoi=1.5 "Length of all pipes between three way valve and boiler"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeValBoi=2*facPerBend
    "Factor for resistance due to bends, fittings etc. between three way valve and boiler"
    annotation (Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length lengthPipValHeaPum=1.5 "Length of all pipes between three way valve and heat pump"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeValHeaPum=2*facPerBend
    "Factor for resistance due to bends, fittings etc. between three way valve and heat pump"
    annotation (Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length lengthPipValOut=3.5
    "Length of the pipe between outlet and three way valve"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoeValOut=facPerBend*1
    "Factor for resistance due to bends, fittings etc. between outlet and three way valve"
    annotation (Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length dPipBoi_design=
     sqrt(4*mBoi_flow_nominal/rho/v_design[1]/Modelica.Constants.pi)
      "Hydraulic diameter of pipes"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    parThrWayVal constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={
      parHeaPum.dpCon_nominal + resValHeaPum.dp_nominal,
      boi.dp_nominal + resValBoi.dp_nominal},
    final m_flow_nominal=2*m_flow_nominal[1],
    final fraK=1) "Parameters for three-way-valve" annotation (Placement(
        transformation(extent={{24,-38},{38,-24}})),
                                                  choicesAllMatching=true,
        Dialog(group="Component data"));

  Distribution.Components.Valves.ThreeWayValveWithFlowReturn thrWayVal(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters=parThrWayVal)
    "Three-way-valve to either run heat pump or gas boiler"
    annotation (Placement(transformation(extent={{40,20},{20,0}})));

  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameter resGenOut(
    length=lengthPipValOut,
    resCoe=resCoeValOut,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPip_design[1],
    final ReC=ReC,
    final v_nominal=v_design[1],
    final roughness=roughness) "Pressure drop for valve to outlet"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameter resValBoi(
    length=lengthPipValBoi,
    resCoe=resCoeValBoi,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mBoi_flow_nominal,
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPipBoi_design,
    final ReC=ReC,
    final v_nominal=v_design[1],
    final roughness=roughness) "Pressure drop for valve to boiler"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameter resValHeaPum(
    length=lengthPipValHeaPum,
    resCoe=resCoeValHeaPum,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPip_design[1],
    final ReC=ReC,
    final v_nominal=v_design[1],
    final roughness=roughness) "Pressure drop for valve to heat pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,-20})));
equation
  connect(thrWayVal.portDHW_b, boi.port_a) annotation (Line(points={{20,13.6},{20,
          14},{6,14},{6,50},{20,50}}, color={0,127,255}));
  connect(heatPump.port_b1, thrWayVal.portBui_a) annotation (Line(points={{-30,35},
          {-30,44},{-6,44},{-6,6},{20,6}},   color={0,127,255}));
  connect(thrWayVal.uBuf, sigBusGen.uPriOrSecGen) annotation (Line(points={{30,-2},
          {30,-16},{2,-16},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(resGen.port_a, thrWayVal.portGen_a) annotation (Line(points={{60,-10},
          {50,-10},{50,5.6},{40,5.6}},
                                     color={0,127,255}));
  connect(thrWayVal.portGen_b, resGenOut.port_a) annotation (Line(points={{40,13.6},
          {52,13.6},{52,20},{60,20}}, color={0,127,255}));
  connect(resGenOut.port_b, senTGenOut.port_a) annotation (Line(points={{80,20},
          {86,20},{86,34},{50,34},{50,80},{60,80}}, color={0,127,255}));
  connect(resValBoi.port_b, boi.port_b) annotation (Line(points={{40,30},{44,30},
          {44,50},{40,50}}, color={0,127,255}));
  connect(resValBoi.port_a, thrWayVal.portDHW_a) annotation (Line(points={{20,30},
          {16,30},{16,17.6},{20,17.6}}, color={0,127,255}));
  connect(resValHeaPum.port_b, heatPump.port_a1)
    annotation (Line(points={{-20,-20},{-30,-20},{-30,0}}, color={0,127,255}));
  connect(resValHeaPum.port_a, thrWayVal.portBui_b) annotation (Line(points={{0,
          -20},{10,-20},{10,2},{20,2}}, color={0,127,255}));
end HeatPumpAndGasBoilerParallel;
