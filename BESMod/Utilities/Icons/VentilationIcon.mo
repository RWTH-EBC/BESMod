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
          textString="%name%")}),Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<html>
<body>
<h4>Information</h4>
<p>
This icon shows a stylized ventilation fan symbol with three blades arranged radially around a central hub. It is used as a partial model to provide a consistent visual representation for ventilation-related components in the <a href=\"modelica://BESMod\">BESMod</a> library.
</p>

<h4>Important Parameters</h4>
<p>The icon contains the following graphical elements:</p>
<ul>
  <li>Circular white background with black outline</li>
  <li>Central black hub</li>
  <li>Three black fan blades at 120° angles</li>
  <li>Component name displayed below the icon</li>
</ul>

</body>
</html>
</html>"));
end VentilationIcon;
