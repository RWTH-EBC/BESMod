within BESMod.FMI.BaseClasses;
partial block PartialNPort
  "Partial block to be used as a container to export a thermofluid flow model with n ports"

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

  IBPSA.Fluid.FMI.Interfaces.Inlet inlet[n](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) "Fluid inlet"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  IBPSA.Fluid.FMI.Interfaces.Outlet outlet[n](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) "Fluid outlet"
                   annotation (Placement(transformation(extent={{100,-10},{120,10}}),
                   iconTransformation(extent={{100,-10},{120,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialNPort;
