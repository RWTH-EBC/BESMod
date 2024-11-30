within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndGasBoilerParallel
  "Parallel connection of heat pump and gas boiler"
  extends BaseClasses.PartialHeatPumpAndGasBoiler(
    final use_old_design=fill(false, nParallelDem), resGen(final dp_nominal=
          dpValIn),
    boi(dp_nominal=boi.m_flow_nominal^parBoi.a/(boi.rho_default^parBoi.n) +
          dpValBoi));
  parameter Modelica.Units.SI.PressureDifference dpValIn
    "Nominal pressure drop between inlet and three way valve"
    annotation (Dialog(tab="Pressure Drops"));
  parameter Modelica.Units.SI.PressureDifference dpValOut
    "Nominal pressure drop between outlet and three way valve joining"
    annotation (Dialog(tab="Pressure Drops"));
  parameter Modelica.Units.SI.PressureDifference dpValHeaPum
    "Nominal pressure drop between three way valve and heat pump"
    annotation (Dialog(tab="Pressure Drops"));
  parameter Modelica.Units.SI.PressureDifference dpValBoi
    "Nominal pressure drop between three way valve and boiler"
    annotation (Dialog(tab="Pressure Drops"));

  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    parThrWayVal constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={parHeaPum.dpCon_nominal,boi.dp_nominal},
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

  IBPSA.Fluid.FixedResistances.PressureDrop resGenOut(
    final dp_nominal=dpValOut,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final deltaM=0.3)
    "Pressure drop model between outlet and three way valve joining"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
equation
  connect(thrWayVal.portDHW_a, boi.port_b) annotation (Line(points={{20,17.6},{8,17.6},
          {8,26},{44,26},{44,50},{40,50}}, color={0,127,255}));
  connect(thrWayVal.portDHW_b, boi.port_a) annotation (Line(points={{20,13.6},{20,
          14},{6,14},{6,50},{20,50}}, color={0,127,255}));
  connect(heatPump.port_b1, thrWayVal.portBui_a) annotation (Line(points={{-30,35},
          {-30,42},{-6,42},{-6,6},{20,6}},   color={0,127,255}));
  connect(thrWayVal.portBui_b, heatPump.port_a1) annotation (Line(points={{20,2},{
          -6,2},{-6,0},{-30,0}},     color={0,127,255}));
  connect(thrWayVal.uBuf, sigBusGen.uPriOrSecGen) annotation (Line(points={{30,-2},
          {30,-16},{2,-16},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(resGen.port_a, thrWayVal.portGen_a) annotation (Line(points={{60,-2},{
          50,-2},{50,5.6},{40,5.6}}, color={0,127,255}));
  connect(resGenOut.port_a, thrWayVal.portGen_b) annotation (Line(points={{60,
          20},{46,20},{46,13.6},{40,13.6}}, color={0,127,255}));
  connect(resGenOut.port_b, senTGenOut.port_a) annotation (Line(points={{80,20},
          {88,20},{88,30},{52,30},{52,80},{60,80}}, color={0,127,255}));
end HeatPumpAndGasBoilerParallel;
