within BESMod.Systems.Hydraulical.Control.Components.OnOffController.Utilities;
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
        coordinateSystem(preserveAspectRatio=false)));
end CountTimeBelowThreshold;
