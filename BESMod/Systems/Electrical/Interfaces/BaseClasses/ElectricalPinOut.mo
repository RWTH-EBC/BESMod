within BESMod.Systems.Electrical.Interfaces.BaseClasses;
partial connector ElectricalPinOut
  output Modelica.Units.SI.Power PElecLoa
    "Electrical power flow; positive = power consumption; negative = power generation";
  output Modelica.Units.SI.Power PElecGen
    "Electrical power flow; positive = power generation; negative = power consumption";

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>This is a partial connector model for electrical power flow signals with output variables. 
</p>

<h4>Important Parameters</h4>
<ul>
<li><code>PElecLoa</code>: Electrical power flow where positive values indicate power consumption and negative values indicate power generation</li>
<li><code>PElecGen</code>: Electrical power flow where positive values indicate power generation and negative values indicate power consumption</li>
</ul></html>"));
end ElectricalPinOut;
