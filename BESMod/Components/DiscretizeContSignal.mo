within BESMod.Components;
model DiscretizeContSignal
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Integer discretizationSteps(min=0) = 0 "Number of steps to dicretize. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1";

equation
  if discretizationSteps <> 0 then
    y = 1 / discretizationSteps * ceil(u * discretizationSteps);
  else
    y = u;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DiscretizeContSignal;
