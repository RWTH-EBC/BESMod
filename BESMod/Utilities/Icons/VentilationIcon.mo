within BESMod.Utilities.Icons;
partial model VentilationIcon
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-12,12},{12,-12}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,8},{18,96}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,-44},{18,44}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={46,-26},
          rotation=60),
        Ellipse(
          extent={{-18,-44},{18,44}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-42,-26},
          rotation=-60),      Text(
          extent={{-100,-74},{104,-170}},
          lineColor={0,0,0},
          textString="%name%")}),Diagram(coordinateSystem(preserveAspectRatio=false)));
end VentilationIcon;
