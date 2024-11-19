within BESMod.Utilities.Electrical;
model ElecConToReal "Transfer from electrical connector to Real interface"
  parameter Boolean reverse = false "Whether electrical flow is inversed or not";
  Modelica.Blocks.Interfaces.RealOutput PElecLoa "Electrical power"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Systems.Electrical.Interfaces.InternalElectricalPinIn internalElectricalPin
    annotation (Placement(transformation(extent={{-108,-8},{-88,12}})));
  Modelica.Blocks.Interfaces.RealOutput PElecGen "Electrical power"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
equation
    PElecLoa = internalElectricalPin.PElecLoa;
    PElecGen = internalElectricalPin.PElecGen;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-86,0},{-1,0},{84,0}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.Bezier),
        Polygon(
          points={{66,14},{66,-14},{86,0},{66,14}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,-100},{98,-160}},
          lineColor={0,0,0},
          textString="%name")}),                                 Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>
    Model for transferring electrical power values from an electrical connector interface to Real output signals. 
    The model provides separate outputs for electrical load (PElecLoa) and generation (PElecGen).
</p>
</html>"));
end ElecConToReal;
