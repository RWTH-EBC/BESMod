within BESMod.Utilities.Icons;
partial model DistributionIcon
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                              Text(
          extent={{-100,-72},{104,-168}},
          lineColor={0,0,0},
          textString="%name%"),
        Line(
          points={{-72,74},{-70,20},{-198,40}},
          color={0,0,0},
          pattern=LinePattern.None,
          thickness=0.5),
        Rectangle(
          extent={{-80,80},{-70,28}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,32},{72,22}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,28},{58,-24}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{68,2},{78,-50}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,6},{92,-4}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,54},{-50,2}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),
                                 Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
This is a partial model that defines the graphical icon for distribution systems in the BESMod library. 
</html>"));
end DistributionIcon;
