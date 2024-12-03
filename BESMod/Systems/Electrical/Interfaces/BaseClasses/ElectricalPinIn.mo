within BESMod.Systems.Electrical.Interfaces.BaseClasses;
partial connector ElectricalPinIn
  input Modelica.Units.SI.Power PElecLoa
    "Electrical power flow; positive = power consumption; negative = power generation";
  input Modelica.Units.SI.Power PElecGen
    "Electrical power flow; positive = power generation; negative = power consumption";

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>Partial connector model used for linking power flows with unidirectional inputs 
for separate representation of electrical consumption and generation.</p>

<h4>Important Parameters</h4>
<p>The connector has two main variables:</p>
<ul>
<li><code>PElecLoa</code>: Power flow representing electrical loads (input). Positive values indicate power consumption, negative values indicate power generation.</li>
<li><code>PElecGen</code>: Power flow representing electrical generation (input). Positive values indicate power generation, negative values indicate power consumption.</li>
</ul>
</html>"));
end ElectricalPinIn;
