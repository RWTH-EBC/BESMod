within BESMod.Systems.Hydraulical.Distribution.Components.Valves;
model ArtificialThreeWayValve
  "Ideal valve either for either side, no in between"

  /******************************* Parameters *******************************/
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.SIunits.Pressure p_hydr = 2e5 "Hydraulic pressure in pipes" annotation(Dialog(group = "Demand"));

  /******************************* Components *******************************/

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium,
     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-50},{-110,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_dhw_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Port connecting from dhw demand"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_dhw_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Port connecting into dhw demand"
    annotation (Placement(transformation(extent={{110,-50},{90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_buf_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Port connecting from heating demand"
    annotation (Placement(transformation(extent={{90,26},{110,46}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_buf_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Port connecting to heating demand"
    annotation (Placement(transformation(extent={{110,66},{90,86}})));
  Modelica.Blocks.Sources.Constant       dummyZero(k=0)
                                                   annotation (Placement(transformation(extent={{-30,28},
            {-18,40}})));
  Modelica.Blocks.Sources.RealExpression dummyMassFlow(y=port_a.m_flow)
                                                                    annotation (Placement(transformation(extent={{-44,0},
            {-16,20}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-38,-26},{-50,-14}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-40,-60},{-52,-48}})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{24,-66},{36,-54}})));
  Modelica.Blocks.Logical.Switch switch4
    annotation (Placement(transformation(extent={{32,78},{44,90}})));
  Modelica.Blocks.Sources.RealExpression dummyEnthalpyDhw(y=inStream(port_buf_a.h_outflow))
    annotation (Placement(transformation(extent={{-8,-80},{-28,-60}})));
  Modelica.Blocks.Sources.RealExpression dummyEnthalpyBuf(y=inStream(port_dhw_a.h_outflow))
    annotation (Placement(transformation(extent={{-8,-56},{-28,-36}})));
  BESMod.Components.Pumps.ArtificalPump_h_in artificalPump_h_in_gen(
      redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-78,0})));
  BESMod.Components.Pumps.ArtificalPump_h_in artificalPump_h_in_buf(
      redeclare package Medium = Medium, p=p_hydr) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={68,-60})));
  BESMod.Components.Pumps.ArtificalPump_h_in artificalPump_h_in_dhw(
      redeclare final package Medium = Medium, final p=p_hydr) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={66,60})));
  Modelica.Blocks.Sources.RealExpression dummyEnthalpy_hgen(y=inStream(port_a.h_outflow))
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={38,6})));
  Modelica.Blocks.Interfaces.BooleanInput dhw_on
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Logical.Not or2
                                 annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={14,84})));
  Modelica.Blocks.Sources.RealExpression dummyEnthalpyBuf1(y=port_dhw_a.m_flow)
    annotation (Placement(transformation(extent={{-8,-20},{-28,0}})));
  Modelica.Blocks.Sources.RealExpression dummyEnthalpyBuf2(y=port_buf_a.m_flow)
    annotation (Placement(transformation(extent={{-6,-38},{-26,-18}})));
equation
  connect(dummyZero.y, switch3.u3) annotation (Line(points={{-17.4,34},{14,34},
          {14,-64.8},{22.8,-64.8}},
                              color={0,0,127}));
  connect(dummyMassFlow.y, switch3.u1) annotation (Line(points={{-14.6,10},{16,
          10},{16,-55.2},{22.8,-55.2}},
                                  color={0,0,127}));
  connect(dummyMassFlow.y, switch4.u1) annotation (Line(points={{-14.6,10},{16,
          10},{16,88.8},{30.8,88.8}},
                                    color={0,0,127}));
  connect(dummyZero.y, switch4.u3) annotation (Line(points={{-17.4,34},{20,34},
          {20,79.2},{30.8,79.2}},
                                color={0,0,127}));
  connect(switch2.u3, dummyEnthalpyDhw.y) annotation (Line(points={{-38.8,-58.8},
          {-36,-58.8},{-36,-58},{-34,-58},{-34,-70},{-29,-70}},
                                           color={0,0,127}));
  connect(switch2.u1, dummyEnthalpyBuf.y) annotation (Line(points={{-38.8,-49.2},
          {-34,-49.2},{-34,-50},{-32,-50},{-32,-46},{-29,-46}},
                                              color={0,0,127}));
  connect(port_a, artificalPump_h_in_gen.port_a)
    annotation (Line(points={{-100,40},{-78,40},{-78,10}}, color={0,127,255}));
  connect(artificalPump_h_in_gen.port_b, port_b) annotation (Line(points={{-78,-10},
          {-78,-40},{-100,-40}}, color={0,127,255}));
  connect(port_dhw_a, artificalPump_h_in_buf.port_a) annotation (Line(points={{100,-80},
          {68,-80},{68,-70}},           color={0,127,255}));
  connect(artificalPump_h_in_buf.port_b, port_dhw_b) annotation (Line(points={{68,-50},
          {70,-50},{70,-40},{100,-40}},  color={0,127,255}));
  connect(artificalPump_h_in_dhw.port_b, port_buf_b) annotation (Line(points={{66,70},
          {68,70},{68,76},{100,76}},         color={0,127,255}));
  connect(port_buf_a, artificalPump_h_in_dhw.port_a)
    annotation (Line(points={{100,36},{66,36},{66,50}},    color={0,127,255}));
  connect(switch1.y, artificalPump_h_in_gen.m_flow_in) annotation (Line(points={{-50.6,
          -20},{-56,-20},{-56,0},{-66.4,0}},        color={0,0,127}));
  connect(switch4.y, artificalPump_h_in_dhw.m_flow_in) annotation (Line(points={{44.6,84},
          {44,84},{44,60},{54.4,60}},               color={0,0,127}));
  connect(switch3.y, artificalPump_h_in_buf.m_flow_in)
    annotation (Line(points={{36.6,-60},{56.4,-60}},         color={0,0,127}));
  connect(switch2.y, artificalPump_h_in_gen.h_flow_in) annotation (Line(points={{-52.6,
          -54},{-60,-54},{-60,8.4},{-66.6,8.4}},
        color={0,0,127}));
  connect(dummyEnthalpy_hgen.y, artificalPump_h_in_buf.h_flow_in) annotation (
      Line(points={{49,6},{60,6},{60,-16},{48,-16},{48,-68},{56.6,-68},{56.6,
          -68.4}}, color={0,0,127}));
  connect(dummyEnthalpy_hgen.y, artificalPump_h_in_dhw.h_flow_in) annotation (
      Line(points={{49,6},{60,6},{60,24},{44,24},{44,52},{48,52},{48,51.6},{
          54.6,51.6}}, color={0,0,127}));
  connect(dhw_on, switch3.u2) annotation (Line(points={{0,120},{0,-60},{22.8,
          -60}},                color={255,0,255}));
  connect(dhw_on, switch2.u2) annotation (Line(points={{0,120},{0,-54},{-38.8,
          -54}}, color={255,0,255}));
  connect(dhw_on, or2.u)
    annotation (Line(points={{0,120},{0,84},{6.8,84}}, color={255,0,255}));
  connect(switch4.u2, or2.y)
    annotation (Line(points={{30.8,84},{20.6,84}}, color={255,0,255}));
  connect(switch1.u1, dummyEnthalpyBuf1.y) annotation (Line(points={{-36.8,
          -15.2},{-32,-15.2},{-32,-10},{-29,-10}}, color={0,0,127}));
  connect(switch1.u3, dummyEnthalpyBuf2.y) annotation (Line(points={{-36.8,
          -24.8},{-32,-24.8},{-32,-28},{-27,-28}}, color={0,0,127}));
  connect(dhw_on, switch1.u2)
    annotation (Line(points={{0,120},{0,-20},{-36.8,-20}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-124,-106},{156,-154}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name"),
        Polygon(
          points={{72,82},{72,28},{18,56},{72,82}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{74,-24},{74,-78},{20,-50},{74,-24}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{27,27},{27,-27},{-27,1},{27,27}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-57,1},
          rotation=180),
        Line(
          points={{-28,0},{-4,0},{-4,56},{20,56}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-4,-2},{-4,-50},{20,-50}},
          color={0,0,0},
          thickness=0.5)}),                                      Diagram(coordinateSystem(preserveAspectRatio=false)));
end ArtificialThreeWayValve;
