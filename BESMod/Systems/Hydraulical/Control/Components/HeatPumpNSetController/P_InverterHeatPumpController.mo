within BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController;
model P_InverterHeatPumpController
  "P-Controller for inverter controlled heat pumps"
  extends BaseClasses.PartialInverterHeatPumpController(PID(controllerType=
          Modelica.Blocks.Types.SimpleController.P));

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
        Line(points={{-80,-80},{-80,-20},{-80,2},{76,2}},  color={0,0,127})}));
end P_InverterHeatPumpController;
