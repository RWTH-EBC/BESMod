within BESMod.Utilities.Icons;
expandable connector UseProBus "Icon for user bus"

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}, initialScale=0.2), graphics={
          Rectangle(
            lineColor={255,204,51},
            lineThickness=0.5,
            extent={{-20.0,-2.0},{20.0,2.0}}),
          Polygon(
            fillColor={0,127,0},
            fillPattern=FillPattern.Solid,
            points={{-80.0,50.0},{80.0,50.0},{100.0,30.0},{80.0,-40.0},{60.0,-50.0},{-60.0,-50.0},{-80.0,-40.0},{-100.0,30.0}},
            smooth=Smooth.Bezier,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65.0,15.0},{-55.0,25.0}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5.0,15.0},{5.0,25.0}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55.0,15.0},{65.0,25.0}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35.0,-25.0},{-25.0,-15.0}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25.0,-25.0},{35.0,-15.0}})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.2), graphics={
        Polygon(
          points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,-20},{-50,15}},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-32.5,7.5},{-27.5,12.5}},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-2.5,12.5},{2.5,7.5}},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{27.5,12.5},{32.5,7.5}},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-17.5,-7.5},{-12.5,-12.5}},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{12.5,-7.5},{17.5,-12.5}},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,70},{150,40}},
          textString="%name")}),
    Documentation(info="<html>
This icon is designed for a <strong>control bus</strong> connector.
</html>"));
end UseProBus;
