within BESMod.Components.Pumps.BaseClasses;
partial model PartialArtificalPumpT "Setting m_flow and temperature possible"
  extends PartialArtificalPump;
  IBPSA.Fluid.Sources.MassFlowSource_T bou_source(
    redeclare package Medium = Medium,             final use_m_flow_in=true,
      nPorts=1)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(bou_source.ports[1], port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(m_flow_in, bou_source.m_flow_in)
    annotation (Line(points={{0,120},{0,8},{58,8}}, color={0,0,127}));
end PartialArtificalPumpT;
