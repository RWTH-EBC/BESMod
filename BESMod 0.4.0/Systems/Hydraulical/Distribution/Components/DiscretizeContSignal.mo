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
        coordinateSystem(preserveAspectRatio=false)));
end DiscretizeContSignal;
