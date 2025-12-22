within BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController;
model OnOff "On off controller"
  extends BaseClasses.PartialControler;

  Modelica.Blocks.Math.BooleanToReal booToRea(final realTrue=yMax, final
      realFalse=0) "Convert boolean signal to real" annotation (Placement(
        transformation(extent={{12,-12},{-12,12}}, rotation=180)));
equation
  connect(setOn, booToRea.u) annotation (Line(points={{-120,0},{-67.1,0},{-67.1,
          2.10942e-15},{-14.4,2.10942e-15}}, color={255,0,255}));
  connect(booToRea.y, ySet) annotation (Line(points={{13.2,-1.33227e-15},{60.55,
          -1.33227e-15},{60.55,0},{110,0}}, color={0,0,127}));
  annotation (Icon(graphics={
      Line(points={{-100.0,0.0},{-45.0,0.0}},
        color={0,0,127}),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{-45.0,-10.0},{-25.0,10.0}}),
      Line(points={{-35.0,0.0},{30.0,35.0}},
        color={0,0,127}),
      Line(points={{45.0,0.0},{100.0,0.0}},
        color={0,0,127}),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{25.0,-10.0},{45.0,10.0}})}));
end OnOff;
