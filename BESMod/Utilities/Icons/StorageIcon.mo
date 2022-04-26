within BESMod.Utilities.Icons;
partial model StorageIcon
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-74,22},{-22,-12},{-22,22},{-74,-12},{-74,22}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-48,6},{-64,-26},{-32,-26},{-48,6}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{6,68},{88,22}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,22},{88,-24}},
          lineThickness=0.5,
          fillColor={255,213,2},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{6,-24},{88,-70}},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
                              Text(
          extent={{-100,-72},{104,-168}},
          lineColor={0,0,0},
          textString="%name%")}),Diagram(coordinateSystem(preserveAspectRatio=false)));
end StorageIcon;
