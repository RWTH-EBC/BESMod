within BESMod.Systems.Demand.DHW.TappingProfiles;
model calcmFlowEquStatic "Static way to calc m_flow_equivalent"
  extends Systems.Demand.DHW.TappingProfiles.BaseClasses.PartialcalcmFlowEqu;
  Modelica.Blocks.Sources.Constant constTSet(final k=TSetDHW)
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
equation
  connect(constTSet.y, dTIs.u1)
    annotation (Line(points={{-61,0},{-44,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Static calculation of equivalent mass flow rates with constant temperature setpoint of <i>TSetDHW</i>. Extends from <a href=\"modelica://BESMod.Systems.Demand.DHW.TappingProfiles.BaseClasses.PartialcalcmFlowEqu\">BESMod.Systems.Demand.DHW.TappingProfiles.BaseClasses.PartialcalcmFlowEqu</a>.</p>

<h4>Important Parameters</h4>
<p>TSetDHW - Target DHW temperature setpoint value in K (defined in base class)</p>
</html>"));
end calcmFlowEquStatic;
