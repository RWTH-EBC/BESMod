within BESMod.Systems.Electrical.Transfer;
model NoElectricalTransfer "No transfer system"
  extends BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer(final
      use_elecHeating=false);
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{16,64},{36,84}})));
equation
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{36,74},{48,74},{48,100}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NoElectricalTransfer;
