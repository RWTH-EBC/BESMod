within BESMod.Systems.Electrical;
model ElectricalSystem "Build your custom electical system"
  extends BESMod.Systems.Electrical.BaseClasses.PartialElectricalSystem;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>Build your custom electrical system using this model as a template. 
<\p></html>"));
end ElectricalSystem;
