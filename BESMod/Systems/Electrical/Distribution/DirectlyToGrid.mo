within BESMod.Systems.Electrical.Distribution;
model DirectlyToGrid "Direct grid connection"
  import BESMod;
  extends
    BESMod.Systems.Electrical.Distribution.BaseClasses.PartialDistribution;

  BESMod.Utilities.Electrical.MultiSumElec multiSumElec(nPorts=nSubSys)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-2})));
equation
  connect(internalElectricalPin, multiSumElec.internalElectricalPinIn)
    annotation (Line(
      points={{50,100},{50,14},{50.2,14},{50.2,7.8}},
      color={0,0,0},
      thickness=1));
  connect(multiSumElec.internalElectricalPinOut, externalElectricalPin)
    annotation (Line(
      points={{50,-12},{50,-98}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end DirectlyToGrid;
