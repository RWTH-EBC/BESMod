within BESMod.Utilities.Electrical;
model ZeroLoad "Zero Load model to be used if system is disabled"
  Systems.Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  internalElectricalPin.PElecLoa = 0;
  internalElectricalPin.PElecGen = 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-92,-52},{92,60}},
          lineColor={0,0,0},
          textString="0 W")}),                                   Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>Zero Load model that can be used if an electrical system is disabled. Sets both load and generation power to 0 W.</p>
</html>"));
end ZeroLoad;
