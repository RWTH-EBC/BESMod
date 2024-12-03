within BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.Utilities;
block CountTimeBelowThreshold
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

algorithm
  when edge(u) then
    y:=time;
  end when;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>Block that stores the last time instance when the boolean input signal rises 
from false to true. The output y equals this time instance. This can be useful 
for tracking when certain conditions last occurred in a control system.</p>
</html>"));
end CountTimeBelowThreshold;
