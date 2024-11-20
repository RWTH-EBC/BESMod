within BESMod.Systems.Electrical.Distribution;
model DirectlyToGrid "Direct grid connection, no own consumption"
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
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<h4>Information</h4>
<p>
This model represents a direct grid connection for electrical systems with no own consumption. 
It sums up the electrical power flows of all subsystems (nSubSys). 
The summed power is directly fed to/from the grid via the 
external electrical pin connection.
</p>
</html>"));
end DirectlyToGrid;
