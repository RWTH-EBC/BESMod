within BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController;
model PID_InverterHeatPumpController
  "PID-Controller for inverter controlled heat pumps"
  extends
    HeatPumpNSetController.BaseClasses.PartialInverterHeatPumpController(PID(
      controllerType=Modelica.Blocks.Types.SimpleController.PID,
      final Ti=T_I,
      final Td=T_D,
      final Ni=Ni,
      final Nd=Nd));
  parameter Modelica.SIunits.Time T_I "Time constant of Integrator block";
  parameter Modelica.SIunits.Time T_D "Time constant of Derivative block";
  parameter Real Ni=0.9 "Ni*Ti is time constant of anti-windup compensation";
  parameter Real Nd=10 "The higher Nd, the more ideal the derivative block";
  annotation (Icon(graphics={
        Line(points={{-78,-80},{-78,52},{-76,-52},{68,76}},color={0,0,127}),
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
end PID_InverterHeatPumpController;
