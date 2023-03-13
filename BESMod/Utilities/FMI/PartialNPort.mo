within BESMod.Utilities.FMI;
partial model PartialNPort
  "Partial model to be used as a container to export a thermofluid flow model with n ports"

  parameter Integer n(min=1);
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  IBPSA.Fluid.FMI.Interfaces.Inlet portGen_in[n](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) "Inputs for Fluid inlet in the generation"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  IBPSA.Fluid.FMI.Interfaces.Outlet portGen_out[n](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) "Outputs of fluid outlet from the generation"
                   annotation (Placement(transformation(extent={{100,-10},{120,10}}),
                   iconTransformation(extent={{100,-10},{120,10}})));
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
  Modelica.Blocks.Sources.RealExpression dpCom[n]
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
  BESMod.Systems.Electrical.Interfaces.InternalElectricalPinOut
    internalElectricalPin1
    annotation (Placement(transformation(extent={{94,-40},{114,-20}}),
        iconTransformation(extent={{94,-40},{114,-20}})));
protected
  Modelica.Blocks.Math.Feedback pOut[n]
    if use_p_in "Pressure at component outlet"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(portGen_in, bouInl.inlet)
    annotation (Line(points={{-110,0},{-71,0}}, color={0,0,255}));
  connect(bouOut.outlet, portGen_out)
    annotation (Line(points={{71,0},{110,0}}, color={0,0,255}));
  connect(bouInl.p, pOut.u1) annotation (Line(points={{-60,-11},{-60,-60},{-8,-60}},
        color={0,127,127}));
  connect(pOut.y, bouOut.p)
    annotation (Line(points={{9,-60},{60,-60},{60,-12}}, color={0,0,127}));
  connect(dpCom.y, pOut.u2)
    annotation (Line(points={{-19,-76},{0,-76},{0,-68}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialNPort;
