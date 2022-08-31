within BESMod.Systems.Hydraulical.Components.Pumps;
model ArtificalPumpIsotermhal
  "Pump without temperature losses"
extends BaseClasses.PartialArtificalPumpT(bou_source(use_T_in=true), final
    bou_sink(final nPorts=1));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,                     m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow";
equation
  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(bou_sink.ports[1], senTem.port_b)
    annotation (Line(points={{-62,0},{-70,0}}, color={0,127,255}));
connect(senTem.T, bou_source.T_in) annotation (Line(points={{-80,11},{-78,11},
        {-78,26},{-40,26},{-40,24},{-16,24},{-16,4},{58,4}}, color={0,0,127}));
end ArtificalPumpIsotermhal;
