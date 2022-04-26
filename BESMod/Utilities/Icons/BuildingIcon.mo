within BESMod.Utilities.Icons;
partial model BuildingIcon
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-80,54},{80,54},{0,94},{-80,54}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,44},{-10,18}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-60,54},{60,-86}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{8,-20},{50,-86}},
          lineColor={0,0,0},
          lineThickness=0.5), Text(
          extent={{-102,-72},{102,-168}},
          lineColor={0,0,0},
          textString="%name%")}),
                                Diagram(coordinateSystem(preserveAspectRatio=false)));
end BuildingIcon;
