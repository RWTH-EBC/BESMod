within BESMod.Components.Pumps.BaseClasses;
partial model PartialArtificalPump
  "Partial model a sink combined with a source to avoid calculation of pump characteristics (time-consuming)"
  extends IBPSA.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.Media.Interfaces.Types.AbsolutePressure p=Medium.p_default
  "Fixed value of pressure";

  IBPSA.Fluid.Sources.Boundary_ph bou_sink(redeclare package Medium = Medium,
      p=p)
    annotation (Placement(transformation(extent={{-42,-10},{-62,10}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s")
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}),                                                iconTransformation(extent={{-20,-20},
            {20,20}},
        rotation=270,
        origin={0,116})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Ellipse(extent = {{-100, 96}, {100, -104}},
  lineColor = {0, 0, 0}, fillColor = {0, 127, 0},
            fillPattern=FillPattern.Solid),
            Polygon(points = {{-42, 70}, {78, -4}, {-42, -78}, {-42, 70}},
            lineColor = {0, 0, 0}, fillColor = {175, 175, 175},
            fillPattern=FillPattern.Solid)}),                    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialArtificalPump;
