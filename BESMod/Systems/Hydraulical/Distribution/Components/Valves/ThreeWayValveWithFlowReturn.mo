within BESMod.Systems.Hydraulical.Distribution.Components.Valves;
model ThreeWayValveWithFlowReturn

  extends IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations;

  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve parameters constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,-96},{-78,-76}})));
  Modelica.Fluid.Interfaces.FluidPort_a portGen_a(
    redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,34},{-90,54}})));
  Modelica.Fluid.Interfaces.FluidPort_b portGen_b(
    redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-46},{-110,-26}})));
  Modelica.Fluid.Interfaces.FluidPort_a portDHW_a(
    redeclare package Medium = Medium)
    "Port connecting from dhw demand"
    annotation (Placement(transformation(extent={{90,-86},{110,-66}})));
  Modelica.Fluid.Interfaces.FluidPort_b portDHW_b(
    redeclare package Medium = Medium)
    "Port connecting into dhw demand"
    annotation (Placement(transformation(extent={{110,-46},{90,-26}})));
  Modelica.Fluid.Interfaces.FluidPort_a portBui_a(
    redeclare package Medium = Medium)
    "Port connecting from heating demand"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b portBui_b(
    redeclare package Medium = Medium)
    "Port connecting to heating demand"
    annotation (Placement(transformation(extent={{110,70},{90,90}})));
  IBPSA.Fluid.Actuators.Valves.ThreeWayLinear threWayValFlow(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final tau=parameters.tau,
    final from_dp=true,
    final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    final verifyFlowReversal=false,
    final use_strokeTime=parameters.use_strokeTime,
    final strokeTime=parameters.strokeTime,
    final init=parameters.init,
    final y_start=parameters.y_start,
    final CvData=IBPSA.Fluid.Types.CvTypes.OpPoint,
    final deltaM=parameters.deltaM,
    final m_flow_nominal=parameters.m_flow_nominal,
    final dpValve_nominal=parameters.dpValve_nominal,
    final dpFixed_nominal=parameters.dpHydBal_nominal .+ parameters.dpFixedExtra_nominal,
    final fraK=parameters.fraK,
    final l=parameters.l,
    final linearized={false,false})
    annotation (Placement(transformation(extent={{22,24},{-22,64}})));

  Modelica.Blocks.Interfaces.RealInput uBuf
    "Actuator position (0: DHW Loading, 1: Buffer / Space heating loading)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

equation
  connect(threWayValFlow.y, uBuf)
    annotation (Line(points={{0,68},{0,120}}, color={0,0,127}));
  connect(threWayValFlow.port_1, portBui_b) annotation (Line(points={{22,44},{
          56,44},{56,80},{100,80}},                 color={0,127,255}));
  connect(threWayValFlow.port_3, portDHW_b) annotation (Line(points={{0,24},{0,
          14},{84,14},{84,-36},{100,-36}}, color={0,127,255}));
  connect(threWayValFlow.port_2, portGen_a) annotation (Line(points={{-22,44},{
          -62,44},{-62,44},{-100,44}}, color={0,127,255}));
  connect(portDHW_a, portGen_b) annotation (Line(points={{100,-76},{70,-76},{70,
          -36},{-100,-36}}, color={0,127,255}));
  connect(portBui_a, portGen_b) annotation (Line(points={{100,40},{70,40},{70,-36},
          {-100,-36}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{72,82},{72,28},{18,56},{72,82}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-28,0},{-4,0},{-4,56},{20,56}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-4,-2},{-4,-50},{20,-50}},
          color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{27,27},{27,-27},{-27,1},{27,27}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-57,1},
          rotation=180),
        Polygon(
          points={{74,-24},{74,-78},{20,-50},{74,-24}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThreeWayValveWithFlowReturn;
