within BESMod.Utilities.Icons;
record RecordWithName
  "A plain record icon which removes the par from the instance name"

  parameter String iconName = "%name" "Name displayed in the icon" annotation(Dialog(tab="Advanced"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          origin={0,-25},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-75.0},{100.0,75.0}},
          radius=25.0),
        Line(
          points={{-100,0},{100,0}},
          color={64,64,64}),
        Line(
          origin={0,-50},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0,-25},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64}),
        Text(
          textColor={0,0,255},
          extent={{-150,58},{150,98}},
          textString=iconName)}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RecordWithName;
