within BESMod.Systems.Electrical;
package Generation "Subsystems and models for electrical generation (e.g. PV system)"

annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
      Rectangle(extent={{-80,66},{-18,-42}}, lineColor={0,0,0}),
      Rectangle(extent={{24,66},{88,8}}, lineColor={0,0,0}),
      Rectangle(extent={{24,-24},{88,-82}}, lineColor={0,0,0}),
      Line(points={{-20,50},{24,50}}, color={0,0,0}),
      Line(points={{-20,24},{24,24}}, color={0,0,0}),
      Line(points={{74,-24},{74,8}}, color={0,0,0}),
      Line(points={{38,-24},{38,8}}, color={0,0,0})}));
end Generation;
