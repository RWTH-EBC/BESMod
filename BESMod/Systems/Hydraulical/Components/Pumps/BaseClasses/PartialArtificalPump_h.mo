within BESMod.Systems.Hydraulical.Components.Pumps.BaseClasses;
partial model PartialArtificalPump_h
  extends PartialArtificalPump;
  IBPSA.Fluid.Sources.MassFlowSource_h bou_source(
    redeclare package Medium = Medium,             use_m_flow_in=true, nPorts=1)
    annotation (Placement(transformation(extent={{52,-10},{72,10}})));
equation
  connect(bou_source.ports[1], port_b)
    annotation (Line(points={{72,0},{100,0}}, color={0,127,255}));
  connect(m_flow_in, bou_source.m_flow_in)
    annotation (Line(points={{0,120},{0,10},{50,10},{50,8}}, color={0,0,127}));
end PartialArtificalPump_h;
