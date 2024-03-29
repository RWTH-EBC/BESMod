within BESMod.Systems.Electrical.Generation;
model NoGeneration "Don't generation electricity"
  extends BaseClasses.PartialGeneration(final f_design=fill(0.8, numGenUnits),
                                        final numGenUnits=1);
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
equation
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{30,70},{50,70},{50,98}},
      color={0,0,0},
      thickness=1));
end NoGeneration;
