within BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController;
model ThermostaticValvePIControlled
  extends BaseClasses.PartialThermostaticValveController;

  parameter Real k[nZones]=fill(0.2, nZones)
                     "Gain of controller";
  parameter Modelica.Units.SI.Time Ti[nZones]=fill(1800, nZones)
    "Time constant of Integrator block";
  Modelica.Blocks.Continuous.LimPID PI[nZones](
    each final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    each final yMax=1,
    each final yMin=leakageOpening)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(TZoneMea, PI.u_m) annotation (Line(points={{-120,60},{-54,60},{-54,
          -26},{0,-26},{0,-12}}, color={0,0,127}));
  connect(PI.y, opening)
    annotation (Line(points={{11,0},{120,0}}, color={0,0,127}));
  connect(TZoneSet, PI.u_s) annotation (Line(points={{-120,-60},{-40,-60},{-40,
          0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,-20},{-80,-20},{52,80}},
                                                           color={0,0,127})}),
                                                                 Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ThermostaticValvePIControlled;
