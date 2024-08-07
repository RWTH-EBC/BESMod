within BESMod.Systems.Hydraulical.Generation;
model HeatPump "Monovalent heat pump"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump;

equation
  connect(senTGenOut.port_a, heatPump.port_b1) annotation (Line(points={{60,80},{
          32,80},{32,44},{-30.5,44},{-30.5,37}}, color={0,127,255}));
  connect(heatPump.port_a1, portGen_in[1])  annotation (Line(points={{-30.5,-7},
          {-30.5,-2},{100,-2}},          color={0,127,255}));
end HeatPump;
