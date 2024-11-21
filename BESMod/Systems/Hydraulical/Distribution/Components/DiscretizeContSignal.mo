within BESMod.Systems.Hydraulical.Distribution.Components;
model DiscretizeContSignal
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Integer discretizationSteps(min=0) = 0 "Number of steps to dicretize. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1";

equation
  if discretizationSteps <> 0 then
    y = 1 / discretizationSteps * ceil(u * discretizationSteps);
  else
    y = u;
  end if;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<h4>Information</h4>
<p>Model for discretizing a continuous signal into a defined number of steps. 
The model takes a continuous input signal and converts it into a discrete stepped 
output signal based on the specified number of discretization steps.</p>

<h4>Important Parameters</h4>
<p><code>discretizationSteps</code> (Integer, min=0): Number of discretization steps.
<ul>
<li>0: No discretization (modulating/continuous output)</li>
<li>1: On-off control (binary output 0 or 1)</li>
<li>2: Three-step output (0, 0.5, 1)</li>
<li>n: n+1 discrete output levels between 0 and 1</li>
</ul>
</p>
</html>"));
end DiscretizeContSignal;
