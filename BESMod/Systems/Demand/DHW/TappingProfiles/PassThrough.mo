within BESMod.Systems.Demand.DHW.TappingProfiles;
model PassThrough "Just extract the water from the DHW tank"
  extends Systems.Demand.DHW.TappingProfiles.BaseClasses.PartialDHW;
equation
  connect(m_flow_in, m_flow_out) annotation (Line(points={{-120,60},{-6,60},{
          -6,0},{110,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>This tapping profile directly extracts water from the DHW tank, without calculation of an equivalent mass flow. </p>
</html>"));
end PassThrough;
