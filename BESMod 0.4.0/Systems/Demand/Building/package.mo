within BESMod.Systems.Demand;
package Building


annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Polygon(
          points={{-80,48},{80,48},{0,88},{-80,48}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,38},{-10,12}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-60,48},{60,-92}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{8,-26},{50,-92}},
          lineColor={0,0,0},
          lineThickness=0.5)}));
end Building;
