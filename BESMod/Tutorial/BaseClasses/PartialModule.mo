within BESMod.Tutorial.BaseClasses;
partial model PartialModule "The partial base-class"

  parameter Real yMax "A top-down parameter. Example: Maximum value for y"  annotation (Dialog(group=
          "Top-Down"));
  parameter Real timePeriod
    "A bottom-up parameter. Example: The estimated period time"                          annotation (Dialog(group=
          "Bottom-Up"));

  Modelica.Blocks.Interfaces.RealOutput y "Output signal connector"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-60,52},{64,-30}},
          textColor={28,108,200},
          textString="%name%")}),                                Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>This is a partial base class for modules. It defines common parameters and a real output signal.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>yMax</code>: A top-down parameter that sets the maximum value for output y</li>
  <li><code>timePeriod</code>: A bottom-up parameter that specifies the estimated period time</li>
</ul>

<h4>Connectors</h4>
<ul>
  <li>Output <code>y</code>: Real output signal from <a href=\"modelica://Modelica.Blocks.Interfaces.RealOutput\">Modelica.Blocks.Interfaces.RealOutput</a></li>
</ul>

<h4>Annotation Features</h4>
<ul>
  <li>Parameters are organized in dialog groups \"Top-Down\" and \"Bottom-Up\"</li>
  <li>Icon shows a white rectangle with blue border and model name in center</li>
</ul>
</html>"));
end PartialModule;
