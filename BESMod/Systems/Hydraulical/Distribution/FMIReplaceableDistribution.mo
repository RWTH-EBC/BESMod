within BESMod.Systems.Hydraulical.Distribution;
block FMIReplaceableDistribution
  "FMI export container for hydraulic distribution models"

  replaceable package MediumGen =
    Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the generation"
                                            annotation (
      __Dymola_choicesAllMatching=true);
  replaceable package MediumDHW =
    Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the DHW"
                                            annotation (
      __Dymola_choicesAllMatching=true);
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the building"
                                            annotation (
      __Dymola_choicesAllMatching=true);

  parameter Boolean allowFlowReversal = distribution.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)
    Adds an input to specify the Temperatur of the backwards flow."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  parameter Boolean use_dhw=distribution.use_dhw;

  IBPSA.Fluid.FMI.Interfaces.Inlet portGen_in[distribution.nParallelSup](
    redeclare each final package Medium = MediumGen,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) "Inlet from the generation"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  IBPSA.Fluid.FMI.Interfaces.Outlet portGen_out[distribution.nParallelSup](
    redeclare each final package Medium = MediumGen,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) "Outlet to the generation"
    annotation (Placement(transformation(extent={{-100,-30},{-120,-10}})));
  IBPSA.Fluid.FMI.Adaptors.Inlet bouInlGen[distribution.nParallelSup](
    redeclare each final package Medium = MediumGen,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in)
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  IBPSA.Fluid.FMI.Adaptors.Outlet bouOutGen[distribution.nParallelSup](
    redeclare each final package Medium = MediumGen,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in)
    annotation (Placement(transformation(extent={{-40,-10},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression dpDisGen[distribution.nParallelSup](y=distribution.portGen_in.p -
        distribution.portGen_out.p) if use_p_in
    "Pressure drop of the component"
    annotation (Placement(transformation(extent={{-96,2},{-76,22}})));
  IBPSA.Fluid.FMI.Adaptors.Inlet bouInlBui[distribution.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in)
    annotation (Placement(transformation(extent={{60,36},{40,16}})));
  IBPSA.Fluid.FMI.Adaptors.Outlet bouOutBui[distribution.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Sources.RealExpression dpDisBui[distribution.nParallelSup](y=
        distribution.portBui_in.p - distribution.portBui_out.p) if use_p_in
    "Pressure drop of the component"
    annotation (Placement(transformation(extent={{94,42},{74,62}})));
  IBPSA.Fluid.FMI.Interfaces.Inlet portBui_in[distribution.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in)
    "Inlet for the distribution from the building"
    annotation (Placement(transformation(extent={{120,16},{100,36}})));
  IBPSA.Fluid.FMI.Interfaces.Outlet portBui_out[distribution.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) "Outlet for the distribution to the building"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  IBPSA.Fluid.FMI.Adaptors.Inlet bouInlDHW(
    redeclare each final package Medium = MediumDHW,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) if use_dhw
    annotation (Placement(transformation(extent={{60,-70},{40,-90}})));
  IBPSA.Fluid.FMI.Adaptors.Outlet bouOutDHW(
    redeclare each final package Medium = MediumDHW,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) if use_dhw
    annotation (Placement(transformation(extent={{40,-36},{60,-16}})));
  Modelica.Blocks.Sources.RealExpression dpDisDHW(y=
       distribution.portDHW_in.p - distribution.portDHW_out.p) if use_p_in and use_dhw
    "Pressure drop of the component"
    annotation (Placement(transformation(extent={{94,-64},{74,-44}})));
  IBPSA.Fluid.FMI.Interfaces.Inlet portDHW_in(
    redeclare each final package Medium = MediumDHW,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) if use_dhw
    "Inet for the distribution from the DHW"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  IBPSA.Fluid.FMI.Interfaces.Outlet portDHW_out(
    redeclare each final package Medium = MediumDHW,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) if use_dhw
    "Outlet for the distribution to the DHW"
    annotation (Placement(transformation(extent={{100,-36},{120,-16}})));
  BESMod.Systems.Hydraulical.Interfaces.DistributionControlBus sigBus
    annotation (Placement(transformation(extent={{-10,92},{10,112}})));
  BESMod.Systems.Hydraulical.Interfaces.DistributionOutputs outBus
    annotation (Placement(transformation(extent={{-30,-112},{-10,-92}})));
  output
  BESMod.Systems.Electrical.Interfaces.InternalElectricalPinOut
    internalElectricalPin1
    annotation (Placement(transformation(extent={{2,-110},{22,-90}})));
protected
  Modelica.Blocks.Math.Feedback pOutGen[distribution.nParallelSup] if use_p_in
    "Pressure at component outlet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,12})));
protected
  Modelica.Blocks.Math.Feedback pOutBui[distribution.nParallelSup] if use_p_in
    "Pressure at component outlet" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={50,52})));
protected
  Modelica.Blocks.Math.Feedback pOutDHW if use_p_in and use_dhw
    "Pressure at component outlet" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={50,-54})));
public
  replaceable BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDistribution distribution
    constrainedby
    BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDistribution(
      redeclare package MediumGen=Medium,
      redeclare package MediumDHW=MediumDHW,
      redeclare package Medium=Medium)
    "Component that holds the actual model"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-18,-18},{18,18}})));
equation
  connect(distribution.outBusDist, outBus) annotation (Line(
      points={{0,-18},{0,-80},{-20,-80},{-20,-102}},
      color={255,204,51},
      thickness=0.5));
  connect(distribution.internalElectricalPin, internalElectricalPin1)
    annotation (Line(
      points={{12.6,-17.64},{12.6,-100},{12,-100}},
      color={0,0,0},
      thickness=1));
  connect(portGen_in, bouInlGen.inlet)
    annotation (Line(points={{-110,40},{-61,40}}, color={0,0,255}));
  connect(bouInlGen.p, pOutGen.u1)
    annotation (Line(points={{-50,29},{-50,20}}, color={0,127,127}));
  connect(dpDisGen.y, pOutGen.u2)
    annotation (Line(points={{-75,12},{-58,12}}, color={0,0,127}));
  connect(pOutGen.y, bouOutGen.p)
    annotation (Line(points={{-50,3},{-50,-8}}, color={0,0,127}));
  connect(bouOutGen.outlet, portGen_out)
    annotation (Line(points={{-61,-20},{-110,-20}}, color={0,0,255}));
  connect(bouInlGen.port_b, distribution.portGen_in) annotation (Line(points={{-40,40},
          {-24,40},{-24,14.4},{-18,14.4}},     color={0,127,255}));
  connect(bouOutGen.port_a, distribution.portGen_out) annotation (Line(points={{-40,-20},
          {-24,-20},{-24,7.2},{-18,7.2}},          color={0,127,255}));
  connect(bouInlBui.port_b, distribution.portBui_in) annotation (Line(points={{40,26},
          {34,26},{34,7.2},{18,7.2}},     color={0,127,255}));
  connect(bouOutBui.port_a, distribution.portBui_out) annotation (Line(points={{40,80},
          {26,80},{26,14.4},{18,14.4}},        color={0,127,255}));
  connect(bouInlBui.p, pOutBui.u1)
    annotation (Line(points={{50,37},{50,44}}, color={0,127,127}));
  connect(pOutBui.y, bouOutBui.p)
    annotation (Line(points={{50,61},{50,68}}, color={0,0,127}));
  connect(dpDisBui.y, pOutBui.u2)
    annotation (Line(points={{73,52},{58,52}}, color={0,0,127}));
  connect(portBui_in, bouInlBui.inlet)
    annotation (Line(points={{110,26},{61,26}}, color={0,0,255}));
  connect(bouOutBui.outlet, portBui_out)
    annotation (Line(points={{61,80},{110,80}}, color={0,0,255}));
  connect(bouInlBui.p, pOutBui.u1)
    annotation (Line(points={{50,37},{50,44}},   color={0,127,127}));
  connect(pOutBui.y, bouOutBui.p)
    annotation (Line(points={{50,61},{50,68}},   color={0,0,127}));
  connect(bouOutDHW.port_a, distribution.portDHW_out) annotation (Line(points={{
          40,-26},{34,-26},{34,-3.6},{18,-3.6}}, color={0,127,255}));
  connect(bouInlDHW.port_b, distribution.portDHW_in) annotation (Line(points={{40,
          -80},{26,-80},{26,-10.8},{18,-10.8}}, color={0,127,255}));
  connect(distribution.sigBusDistr, sigBus) annotation (Line(
      points={{0,18.18},{0,102}},
      color={255,204,51},
      thickness=0.5));
  connect(bouOutDHW.outlet, portDHW_out)
    annotation (Line(points={{61,-26},{110,-26}}, color={0,0,255}));
  connect(pOutDHW.y, bouOutDHW.p)
    annotation (Line(points={{50,-45},{50,-38}}, color={0,0,127}));
  connect(bouInlDHW.p, pOutDHW.u1)
    annotation (Line(points={{50,-69},{50,-62}}, color={0,127,127}));
  connect(dpDisDHW.y, pOutDHW.u2)
    annotation (Line(points={{73,-54},{58,-54}}, color={0,0,127}));
  connect(portDHW_in, bouInlDHW.inlet)
    annotation (Line(points={{110,-80},{61,-80}}, color={0,0,255}));
   annotation (Placement(transformation(extent={{-60,66},
            {-40,86}})),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
                 Bitmap(extent={{-62,-94},{58,-32}},fileName=
            "modelica://IBPSA/Resources/Images/Fluid/FMI/FMI_icon.png"),
          Rectangle(
          extent={{-84,90},{88,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-62,62},{-10,28},{-10,62},{-62,28},{-62,62}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-36,46},{-52,14},{-20,14},{-36,46}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{8,78},{74,48}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,48},{74,18}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,18},{74,-12}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FMIReplaceableDistribution;
