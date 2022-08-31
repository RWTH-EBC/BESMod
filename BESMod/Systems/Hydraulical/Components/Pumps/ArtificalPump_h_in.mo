within BESMod.Systems.Hydraulical.Components.Pumps;
model ArtificalPump_h_in "Artifical pump with enthalpy as input"
  extends BaseClasses.PartialArtificalPump_h(bou_sink(nPorts=1), bou_source(
        use_h_in=true));
  Modelica.Blocks.Interfaces.RealInput h_flow_in(final unit="J/(kg)")
    "Prescribed enthaply flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-84,114})));
equation
  connect(port_a, bou_sink.ports[1])
    annotation (Line(points={{-100,0},{-62,0}}, color={0,127,255}));
  connect(h_flow_in, bou_source.h_in) annotation (Line(points={{-60,120},{-60,
          42},{-28,42},{-28,4},{50,4}},
                                    color={0,0,127}));
end ArtificalPump_h_in;
