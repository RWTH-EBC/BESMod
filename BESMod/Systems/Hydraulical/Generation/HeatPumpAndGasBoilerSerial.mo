within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndGasBoilerSerial "serial arrangement of heatpump and boiler"
  extends
    BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPumpAndGasBoiler(
    dp_design={heatPump.dpCon_nominal + boi.dp_nominal + resGen.dp_nominal},
    final use_old_design=fill(false, nParallelDem), resGen(
      final length=lengthPip,
      final fac=facFit));
  parameter Modelica.Units.SI.Length lengthPip=8 "Length of all pipes"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real facFit=4*facPerBend
    "Factor to take into account resistance of bends, fittings etc."
    annotation (Dialog(tab="Pressure losses"));
equation

  connect(boi.port_a, heatPump.port_b1) annotation (Line(points={{20,50},{14,50},
          {14,46},{-30,46},{-30,35}},
                               color={0,127,255}));
  connect(boi.port_b, senTGenOut.port_a) annotation (Line(points={{40,50},{54,50},
          {54,80},{60,80}}, color={0,127,255}));
  connect(resGen.port_a, heatPump.port_a1) annotation (Line(points={{60,-10},{6,
          -10},{6,-18},{-30,-18},{-30,0}},
                                      color={0,127,255}));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
end HeatPumpAndGasBoilerSerial;
