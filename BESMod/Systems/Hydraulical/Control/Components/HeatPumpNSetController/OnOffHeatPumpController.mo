within BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController;
model OnOffHeatPumpController
  "Controller for a on off heat pump, either zero or one"
  extends BaseClasses.PartialHPNSetController;

  parameter Real n_opt "Frequency of the heat pump map with an optimal isentropic efficiency. Necessary, as on-off HP will be optimized for this frequency and only used there.";

  Modelica.Blocks.Math.BooleanToReal hp_on_to_n_hp
    annotation (Placement(transformation(extent={{22,-22},{-22,22}},
        rotation=180,
        origin={-4,3.55271e-15})));
  Modelica.Blocks.Math.Gain gain(final k=n_opt)
    annotation (Placement(transformation(extent={{56,-10},{76,10}})));
equation
  connect(HP_On, hp_on_to_n_hp.u) annotation (Line(points={{-120,0},{-76,0},{
          -76,7.54952e-15},{-30.4,7.54952e-15}}, color={255,0,255}));
  connect(hp_on_to_n_hp.y, gain.u) annotation (Line(points={{20.2,1.55431e-15},
          {28,1.55431e-15},{28,0},{54,0}},
                                   color={0,0,127}));
  connect(gain.y, n_Set) annotation (Line(points={{77,0},{110,0}},
                       color={0,0,127}));
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
end OnOffHeatPumpController;
