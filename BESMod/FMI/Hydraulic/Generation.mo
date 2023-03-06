within BESMod.FMI.Hydraulic;
block Generation
  "FMI export container for hydraulic generation"
  extends BESMod.FMI.BaseClasses.PartialNPort(
  final allowFlowReversal=generation.allowFlowReversal,
  use_p_in=true,
  final n=generation.nParallelDem);
  IBPSA.Fluid.FMI.Adaptors.Inlet bouInl[n](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  IBPSA.Fluid.FMI.Adaptors.Outlet bouOut[n](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Sources.RealExpression dpCom[n](y=generation.portGen_in.p - generation.portGen_out.p)
    if use_p_in "Pressure drop of the component"
    annotation (Placement(transformation(extent={{-40,-86},{-20,-66}})));
  BESMod.Systems.Hydraulical.Interfaces.GenerationControlBus sigBus
    annotation (Placement(transformation(extent={{-12,88},{14,110}}),
        iconTransformation(extent={{-12,88},{14,110}})));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-112,66},{-92,86}}),
        iconTransformation(extent={{-112,66},{-92,86}})));
  BESMod.Systems.Hydraulical.Interfaces.GenerationOutputs outBus
    annotation (Placement(transformation(extent={{94,-70},{114,-50}}),
        iconTransformation(extent={{94,-70},{114,-50}})));
  replaceable BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition systemParameters
    constrainedby
    BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    final use_hydraulic=true,
    final use_ventilation=false,
    use_dhw=false,
    final use_elecHeating=false)
    "Parameters relevant for the whole energy system"
    annotation (Placement(transformation(extent={{42,42},{78,78}})));
  BESMod.Systems.Electrical.Interfaces.InternalElectricalPinOut
    internalElectricalPin1
    annotation (Placement(transformation(extent={{94,-40},{114,-20}}),
        iconTransformation(extent={{94,-40},{114,-20}})));
protected
  Modelica.Blocks.Math.Feedback pOut[n]
    if use_p_in "Pressure at component outlet"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
public
  replaceable BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration generation
    constrainedby
    BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
      redeclare final package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      Q_flow_nominal=fill(sum(systemParameters.QBui_flow_nominal), generation.nParallelDem),
      TOda_nominal=systemParameters.TOda_nominal,
      TDem_nominal=fill(systemParameters.THydSup_nominal[1], generation.nParallelDem),
      TAmb=systemParameters.TAmbHyd,
      dpDem_nominal=fill(0, generation.nParallelDem))
    "Component that holds the actual model"
    annotation (Placement(transformation(extent={{-20,-20},{20,22}})));
equation
  connect(generation.internalElectricalPin, internalElectricalPin1)
    annotation (Line(
      points={{14.4,-20},{80,-20},{80,-30},{104,-30}},
      color={0,0,0},
      thickness=1));
  connect(bouInl.port_b, generation.portGen_in) annotation (Line(points={{-50,0},
          {-50,-40},{32,-40},{32,9.4},{20,9.4}},                       color={0,
          127,255}));
  connect(bouOut.port_a, generation.portGen_out) annotation (Line(points={{50,0},{
          40,0},{40,17.8},{20,17.8}},           color={0,127,255}));
  connect(inlet, bouInl.inlet) annotation (Line(points={{-110,0},{-71,0}},
                      color={0,0,255}));
  connect(bouOut.outlet, outlet)
    annotation (Line(points={{71,0},{110,0}}, color={0,0,255}));
  connect(bouInl.p, pOut.u1)
    annotation (Line(points={{-60,-11},{-60,-60},{-8,-60}},
                                                          color={0,127,127}));
  connect(pOut.y, bouOut.p)
    annotation (Line(points={{9,-60},{60,-60},{60,-12}},  color={0,0,127}));
  connect(dpCom.y, pOut.u2)
    annotation (Line(points={{-19,-76},{0,-76},{0,-68}}, color={0,0,127}));
  connect(generation.sigBusGen, sigBus) annotation (Line(
      points={{0.4,21.58},{0.4,99},{1,99}},
      color={255,204,51},
      thickness=0.5));
  connect(generation.weaBus, weaBus) annotation (Line(
      points={{-19.6,13.6},{-22,13.6},{-22,76},{-102,76}},
      color={255,204,51},
      thickness=0.5));
  connect(generation.outBusGen, outBus) annotation (Line(
      points={{0,-20},{80,-20},{80,-60},{104,-60}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
          Rectangle(
          extent={{-78,90},{82,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,40},{26,16},{40,28},{26,40}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{20,52},{102,4}},
          lineColor={238,46,47},
          textString="Q̇"),
                  Line(
          points={{-42,42},{-16,14},{0,50},{20,28},{34,28}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
        Text(
          extent={{-106,54},{-20,6}},
          lineColor={0,0,0},
          textString="P"),
                  Line(
          points={{-42,82},{-16,54},{0,90},{20,68},{34,68}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
        Polygon(
          points={{26,80},{26,56},{40,68},{26,80}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,-2},{26,-26},{40,-14},{26,-2}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
                  Line(
          points={{-44,2},{-18,-26},{-2,10},{18,-12},{32,-12}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
                 Bitmap(extent={{-64,-96},{56,-34}},fileName=
            "modelica://IBPSA/Resources/Images/Fluid/FMI/FMI_icon.png")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Generation;
