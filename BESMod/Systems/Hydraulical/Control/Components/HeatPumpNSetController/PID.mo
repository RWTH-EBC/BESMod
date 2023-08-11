within BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController;
model PID "PID-Controller for inverter controlled devices"
  extends HeatPumpNSetController.PI(PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    final Td=timeDer,
    final Nd=Nd));
  parameter Modelica.Units.SI.Time timeDer "Time constant of Derivative block";
  parameter Real Nd=10 "The higher Nd, the more ideal the derivative block";
  annotation (Icon(graphics={
        Line(points={{-78,-80},{-78,52},{-78,-18},{-78,-80}},
                                                           color={0,0,127}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192})}));
end PID;
