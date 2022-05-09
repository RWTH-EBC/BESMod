within BESMod.Systems.Electrical;
model ElectricalSystem "Example of electrical system"
  extends
    BESMod.Systems.Electrical.BaseClasses.PartialElectricalSystem;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ElectricalSystem;
