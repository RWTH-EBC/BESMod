within BESMod.Systems.Ventilation.Distribution;
model FMIReplaceableDistribution
  "FMI export container for ventilation distribution models"


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

  parameter Boolean use_p_in=true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean use_p_in_Supply=use_p_in
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean use_p_in_Exh=use_p_in
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  BESMod.Systems.Hydraulical.Interfaces.DistributionControlBus sigBus
    annotation (Placement(transformation(extent={{-10,92},{10,112}})));
  BESMod.Systems.Hydraulical.Interfaces.DistributionOutputs outBus
    annotation (Placement(transformation(extent={{-60,-112},{-40,-92}})));
  output
  BESMod.Systems.Electrical.Interfaces.InternalElectricalPinOut
    internalElectricalPin1
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  replaceable BaseClasses.PartialDistribution distribution
    constrainedby
    BESMod.Systems.Ventilation.Distribution.BaseClasses.PartialDistribution(
      redeclare final package Medium=Medium)
    annotation (Placement(transformation(extent={{-38,-38},{38,38}})));
  IBPSA.Fluid.FMI.Adaptors.Inlet bouInlSupply[distribution.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_Supply) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={70,20})));
  IBPSA.Fluid.FMI.Adaptors.Outlet bouOutSupply[distribution.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_Supply)
    annotation (Placement(transformation(extent={{-60,30},{-80,10}})));
  IBPSA.Fluid.FMI.Adaptors.Outlet bouOutExh[distribution.nParallelDem](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_Exh)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  IBPSA.Fluid.FMI.Adaptors.Inlet bouInlExh[distribution.nParallelDem](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_Exh)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  IBPSA.Fluid.FMI.Interfaces.Inlet portExh_in[distribution.nParallelDem](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_Exh)
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  IBPSA.Fluid.FMI.Interfaces.Inlet portSupply_in[distribution.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_Supply)
    annotation (Placement(transformation(extent={{120,10},{100,30}})));
  IBPSA.Fluid.FMI.Interfaces.Outlet portExh_out[distribution.nParallelDem](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_Exh)
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  IBPSA.Fluid.FMI.Interfaces.Outlet portSupply_out[distribution.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_Supply)
    annotation (Placement(transformation(extent={{-100,10},{-120,30}})));
  Modelica.Blocks.Math.Feedback pOutSupply[distribution.nParallelSup]
    if use_p_in_Supply "Pressure at component outlet" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-70,60})));
  Modelica.Blocks.Sources.RealExpression dpDistSupply[distribution.nParallelSup](
     y=distribution.portSupply_in.p - distribution.portSupply_out.p)
    if use_p_in_Supply "Pressure drop of the component"
    annotation (Placement(transformation(extent={{-20,50},{-40,70}})));
  Modelica.Blocks.Math.Feedback pOutExh[distribution.nParallelDem]
    if use_p_in_Exh "Pressure at component outlet" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,-60})));
  Modelica.Blocks.Sources.RealExpression dpDistExh[distribution.nParallelDem](y=
       distribution.portExh_in.p - distribution.portExh_out.p) if use_p_in_Exh
    "Pressure drop of the component"
    annotation (Placement(transformation(extent={{30,-90},{10,-70}})));
equation

  connect(distribution.internalElectricalPin, internalElectricalPin1)
    annotation (Line(
      points={{26.6,-37.24},{50,-37.24},{50,-100}},
      color={0,0,0},
      thickness=1));
  connect(distribution.outBusDist, outBus) annotation (Line(
      points={{6.66134e-16,-37.62},{-50,-37.62},{-50,-102}},
      color={255,204,51},
      thickness=0.5));
  connect(distribution.sigBusDistr, sigBus) annotation (Line(
      points={{0,38},{0,102}},
      color={255,204,51},
      thickness=0.5));
  connect(bouOutSupply.port_a, distribution.portSupply_out) annotation (
      Line(points={{-60,20},{-44,20},{-44,15.2},{-38,15.2}}, color={0,127,255}));
  connect(bouInlSupply.port_b, distribution.portSupply_in) annotation (
      Line(points={{60,20},{44,20},{44,15.2},{38,15.2}}, color={0,127,255}));
  connect(bouOutExh.port_a, distribution.portExh_out) annotation (Line(
        points={{60,-20},{44,-20},{44,-15.2},{38,-15.2}}, color={0,127,255}));
  connect(bouInlExh.port_b, distribution.portExh_in) annotation (Line(
        points={{-60,-20},{-44,-20},{-44,-15.2},{-38,-15.2}}, color={0,127,255}));
  connect(portExh_in, bouInlExh.inlet)
    annotation (Line(points={{-110,-20},{-81,-20}}, color={0,0,255}));
  connect(bouOutExh.outlet, portExh_out)
    annotation (Line(points={{81,-20},{110,-20}}, color={0,0,255}));
  connect(bouOutSupply.outlet, portSupply_out)
    annotation (Line(points={{-81,20},{-110,20}}, color={0,0,255}));
  connect(portSupply_in, bouInlSupply.inlet)
    annotation (Line(points={{110,20},{81,20}}, color={0,0,255}));
  connect(bouInlSupply.p, pOutSupply.u1) annotation (Line(points={{70,31},{70,74},
          {-70,74},{-70,68}}, color={0,127,127}));
  connect(dpDistSupply.y, pOutSupply.u2)
    annotation (Line(points={{-41,60},{-62,60}}, color={0,0,127}));
  connect(pOutSupply.y, bouOutSupply.p)
    annotation (Line(points={{-70,51},{-70,32}}, color={0,0,127}));
  connect(bouInlExh.p, pOutExh.u1) annotation (Line(points={{-70,-31},{-70,-60},
          {-8,-60}}, color={0,127,127}));
  connect(dpDistExh.y, pOutExh.u2) annotation (Line(points={{9,-80},{-1.11022e-15,
          -80},{-1.11022e-15,-68}}, color={0,0,127}));
  connect(pOutExh.y, bouOutExh.p)
    annotation (Line(points={{9,-60},{70,-60},{70,-32}}, color={0,0,127}));
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
        Rectangle(
          extent={{-74,46},{60,36}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,82},{-58,46}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,36},{54,0}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,56},{-38,20}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{62,14},{72,-22}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,20},{78,10}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FMIReplaceableDistribution;
