within BESMod.Systems.Hydraulical.Generation.BaseClasses;
partial model PartialAggregatedPressureLoss
  "Aggregates serial pressure losses to reduce nonlinear equations"
  extends PartialGeneration(
      dp_design={resGenApp.dp_nominal});
  IBPSA.Fluid.FixedResistances.PressureDrop resGenApp(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[1],
    final show_T=show_T) "Sum of resistances applied"
    annotation (Placement(transformation(extent={{70,-20},{90,0}})));
equation
  connect(portGen_in[1], resGenApp.port_b)
    annotation (Line(points={{100,-2},{100,-10},{90,-10}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>This model is used to aggregate all later pressure losses (e.g. from heat pumps, boilers, pipes etc.) in a single one an actually apply it to the equation system.</p>
<p>Usefule to reduce nonlinear equation iterations.</p>
</html>"));
end PartialAggregatedPressureLoss;
