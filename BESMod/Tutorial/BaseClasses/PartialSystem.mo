within BESMod.Tutorial.BaseClasses;
partial model PartialSystem
  parameter Real yMax "A top-down parameter. Example: Maximum value for y";

  replaceable BESMod.Tutorial.BaseClasses.PartialModule module
    constrainedby BESMod.Tutorial.BaseClasses.PartialModule(
      final yMax=yMax)
    "Correct overwrite of top-down parameters" annotation (Placement(
        transformation(extent={{-18,-18},{20,18}})), choicesAllMatching=true);

  replaceable BESMod.Tutorial.BaseClasses.PartialModule moduleWrong(final yMax=
        yMax) constrainedby BESMod.Tutorial.BaseClasses.PartialModule
    "Wrong overwrite of top-down parameters" annotation (Placement(
        transformation(extent={{-18,-78},{20,-42}})), choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealOutput y "Output signal connector" annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput yWrong "Output signal connector" annotation (Placement(transformation(extent={{100,-70},
            {120,-50}})));

equation
  connect(module.y, y) annotation (Line(points={{21.9,0},{110,0}}, color={0,0,127}));
  connect(moduleWrong.y, yWrong) annotation (Line(points={{21.9,-60},{110,-60}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<h4>Information</h4>
<p>
This model demonstrates the correct and wrong way of handling top-down parameter propagation in Modelica.
It contains two instances of a replaceable partial module:
</p>
<ul>
<li><code>module</code>: Shows the correct way of parameter propagation by placing the parameter redeclaration after <code>constrainedby</code></li>
<li><code>moduleWrong</code>: Shows the wrong way by placing the parameter redeclaration before <code>constrainedby</code></li>
</ul>

<p>Both modules are constrained by <a href=\"modelica://BESMod.Tutorial.BaseClasses.PartialModule\">BESMod.Tutorial.BaseClasses.PartialModule</a>.</p>

<h4>Important Parameters</h4>
<ul>
<li><code>yMax</code>: Maximum value for y, used as top-down parameter</li>
</ul>

<h4>Connections</h4>
<ul>
<li>Module outputs <code>y</code> and <code>yWrong</code> are connected to system outputs</li>
</ul>
</html>"));
end PartialSystem;
