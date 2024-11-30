within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndGasBoilerSerial "serial arrangement of heatpump and boiler"
  extends
    BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPumpAndGasBoiler(
    final use_old_design=fill(false, nParallelDem), resGen(final dp_nominal=
          dpPipFit_nominal),
    boi(dp_nominal=boi.m_flow_nominal^parBoi.a/(boi.rho_default^parBoi.n)));
  parameter Modelica.Units.SI.PressureDifference dpPipFit_nominal
    "Nominal pressure drop between inlet and outlet for pipes and fittings"
    annotation (Dialog(tab="Pressure Drops"));

equation

  connect(boi.port_a, heatPump.port_b1) annotation (Line(points={{20,50},{14,50},
          {14,35},{-30,35}},   color={0,127,255}));
  connect(boi.port_b, senTGenOut.port_a) annotation (Line(points={{40,50},{54,50},
          {54,80},{60,80}}, color={0,127,255}));
  connect(resGen.port_a, heatPump.port_a1) annotation (Line(points={{60,-2},{6,-2},
          {6,-18},{-30,-18},{-30,0}}, color={0,127,255}));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
end HeatPumpAndGasBoilerSerial;
