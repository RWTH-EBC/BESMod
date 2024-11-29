within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndGasBoilerSerial "serial arrangement of heatpump and boiler"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPumpAndGasBoiler(
    final use_old_design=fill(false, nParallelDem));


equation

  connect(boi.port_a, heatPump.port_b1) annotation (Line(points={{20,50},{14,50},
          {14,35},{-30,35}},   color={0,127,255}));
  connect(boi.port_b, senTGenOut.port_a) annotation (Line(points={{40,50},{54,50},
          {54,80},{60,80}}, color={0,127,255}));
  connect(portGen_in[1], heatPump.port_a1) annotation (Line(points={{100,-2},{
          -30.5,-2},{-30.5,-7}},
                            color={0,127,255}));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
end HeatPumpAndGasBoilerSerial;
