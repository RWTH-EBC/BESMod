within BESMod.Systems.Hydraulical.Generation;
model HeatPump "Monovalent heat pump"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump;

equation
  connect(senTGenOut.port_a, heatPump.port_b1) annotation (Line(points={{60,80},{
          32,80},{32,44},{-30.5,44},{-30.5,37}}, color={0,127,255}));
  connect(heatPump.port_a1, pump.port_b) annotation (Line(points={{-30.5,-7},{
          -30.5,-70},{1.77636e-15,-70}}, color={0,127,255}));
end HeatPump;
