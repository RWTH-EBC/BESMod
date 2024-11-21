within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndGasBoilerSerial "serial arrangement of heatpump and boiler"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPumpAndGasBoiler(
    final use_old_design=fill(false, nParallelDem));


equation

  connect(boi.port_a, heatPump.port_b1) annotation (Line(points={{20,50},{14,50},
          {14,35},{-30,35}},   color={0,127,255}));
  connect(boi.port_b, senTGenOut.port_a) annotation (Line(points={{40,50},{54,50},
          {54,80},{60,80}}, color={0,127,255}));
  connect(pump.port_b, heatPump.port_a1) annotation (Line(points={{0,-70},{-30,-70},
          {-30,0}},         color={0,127,255}));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
  annotation (Documentation(info="<html>
<p>Model for heating system with serial arrangement of heat pump and boiler. 
The heat pump is the primary heat generator and can be boosted by the boiler connected in 
series for higher temperatures.</p>
<p>Extends <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPumpAndGasBoiler\">BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPumpAndGasBoiler</a></p>
</html>"));
end HeatPumpAndGasBoilerSerial;
