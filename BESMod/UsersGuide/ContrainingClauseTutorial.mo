within BESMod.UsersGuide;
package ContrainingClauseTutorial

  partial model PartialModule

    parameter Real topDownParameter "A top-down parameter"
      annotation (Dialog(group="Top-Down"));
    parameter Real bottomUpParameter "A bottom-up parameter"
      annotation (Dialog(group="Bottom-Up"));

  end PartialModule;

  model MyOwnModule
     extends PartialModule(bottomUpParameter=5);



  end MyOwnModule;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<h4>Information</h4>
<p>
This package demonstrates the contraining clause methodology in Modelica. The methodology consists of two parts:
</p>
<ul>
<li>A partial model defining parameters with either top-down or bottom-up characteristics</li>
<li>An inheriting model that extends the partial model and sets bottom-up parameters</li>
</ul>

<h4>Important Parameters</h4>
<ul>
<li><code>topDownParameter</code>: Parameter intended to be set from top level (Dialog group: Top-Down)</li>
<li><code>bottomUpParameter</code>: Parameter intended to be set from bottom level, pre-set to 5 in MyOwnModule (Dialog group: Bottom-Up)</li>
</ul></html>"));
end ContrainingClauseTutorial;
