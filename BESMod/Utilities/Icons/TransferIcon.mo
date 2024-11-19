within BESMod.Utilities.Icons;
partial model TransferIcon
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,40},{90,-82}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,40},{66,-82}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{24,40},{42,-82}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,40},{18,-82}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,40},{-6,-82}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-88,40},{-36,6},{-36,40},{-88,6},{-88,40}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-62,22},{-62,56}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-52,56},{-72,56}},
          color={0,0,0},
          thickness=0.5),     Text(
          extent={{-100,-76},{104,-172}},
          lineColor={0,0,0},
          textString="%name%")}),Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
A partial model defining an icon for heat transfer components. 

</html>"));
end TransferIcon;
