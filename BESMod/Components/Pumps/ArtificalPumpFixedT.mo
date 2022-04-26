within BESMod.Components.Pumps;
model ArtificalPumpFixedT
  "Temperature of source is a given fixed value"
  extends BaseClasses.PartialArtificalPumpT(final bou_sink(nPorts=1),
      bou_source(final T=T_fixed));
  parameter Modelica.Media.Interfaces.Types.Temperature T_fixed=Medium.T_default
    "Fixed value of temperature for outlet of pump";
equation
  connect(bou_sink.ports[1], port_a)
    annotation (Line(points={{-62,0},{-100,0}}, color={0,127,255}));
end ArtificalPumpFixedT;
