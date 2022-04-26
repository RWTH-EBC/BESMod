within BESMod.Utilities.Electrical;
model RealToElecCon
  "Transfer from real interface to electrical connector"
  parameter Boolean reverse = false "Whether electrical flow is inversed or not";
  Modelica.Blocks.Interfaces.RealInput PElec "Electrical power"
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Systems.Electrical.Interfaces.InternalElectricalPin internalElectricalPin
    annotation (Placement(transformation(extent={{92,-8},{112,12}})));
equation
  if reverse then
    PElec = internalElectricalPin.PElec;
  else
    PElec = -1*internalElectricalPin.PElec;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-86,0},{-1,0},{84,0}},
          color={0,140,72},
          thickness=1,
          smooth=Smooth.Bezier),
        Polygon(
          points={{66,14},{66,-14},{86,0},{66,14}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RealToElecCon;
