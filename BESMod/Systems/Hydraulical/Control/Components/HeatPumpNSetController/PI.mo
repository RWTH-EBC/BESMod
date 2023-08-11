within BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController;
model PI "PI-Controller for inverter controlled devices"
  extends HeatPumpNSetController.BaseClasses.PartialInverterHeatPumpController(
      PID(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      final Ti=timeInt,
      final Ni=Ni));
  parameter Modelica.Units.SI.Time timeInt "Time constant of Integrator block";
  parameter Real Ni=0.9 "Ni*Ti is time constant of anti-windup compensation";
  annotation (Icon(graphics={
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
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Line(points={{-80,-80},{-80,-20},{-80,-20},{52,80}},
                                                           color={0,0,127})}));
end PI;
