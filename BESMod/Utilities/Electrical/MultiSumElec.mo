within BESMod.Utilities.Electrical;
model MultiSumElec "Sum of all electrical inputs"

  parameter Integer nPorts(min=1) "Number of ports to sum up" annotation(Dialog(connectorSizing=true));

  Systems.Electrical.Interfaces.InternalElectricalPin internalElectricalPinOut
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Systems.Electrical.Interfaces.InternalElectricalPin internalElectricalPinIn[
    nPorts] annotation (Placement(transformation(extent={{-108,-8},{-88,12}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{52,82},{-76,82},{28,6},{-66,-76},{52,-76}},
          color={0,0,0},
          thickness=0.5)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));


end MultiSumElec;
