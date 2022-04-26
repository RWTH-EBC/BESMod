within BESMod.Utilities.Icons;
partial model GenerationIcon
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                              Text(
          extent={{-100,-78},{104,-174}},
          lineColor={0,0,0},
          textString="%name%"),
                  Line(
          points={{-66,60},{-32,10},{8,70},{38,30},{48,30}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
        Polygon(
          points={{46,44},{46,16},{66,30},{46,44}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{46,0},{46,-28},{66,-14},{46,0}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
                  Line(
          points={{-66,16},{-32,-34},{8,26},{38,-14},{48,-14}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
        Polygon(
          points={{46,-42},{46,-70},{66,-56},{46,-42}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
                  Line(
          points={{-66,-26},{-32,-76},{8,-16},{38,-56},{48,-56}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
        Text(
          extent={{42,24},{124,-24}},
          lineColor={238,46,47},
          textString="Q̇"),
        Text(
          extent={{-126,26},{-40,-24}},
          lineColor={0,0,0},
          textString="P")}),     Diagram(coordinateSystem(preserveAspectRatio=false)));
end GenerationIcon;
