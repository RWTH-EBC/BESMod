within BESMod.Utilities.Electrical;
model MultiSumElec "Sum of all electrical inputs"

  parameter Integer nPorts(min=1) "Number of ports to sum up" annotation(Dialog(connectorSizing=true));

  Systems.Electrical.Interfaces.InternalElectricalPin internalElectricalPinOut
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Systems.Electrical.Interfaces.InternalElectricalPin internalElectricalPinIn[
    nPorts] annotation (Placement(transformation(extent={{-108,-8},{-88,12}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));


end MultiSumElec;
