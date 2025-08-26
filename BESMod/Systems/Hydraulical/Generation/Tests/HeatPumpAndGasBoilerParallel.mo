within BESMod.Systems.Hydraulical.Generation.Tests;
model HeatPumpAndGasBoilerParallel
  "Test case for parallel heat pump and gas boiler"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel
      generation(
      redeclare model RefrigerantCycleHeatPumpHeating =
          AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D
          (redeclare
            AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
            datTab),
      redeclare
        AixLib.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
        safCtrPar(minOffTime=200),
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
        parHeaPum,
      redeclare BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      mBoi_flow_nominal=generation.m_flow_design[1],
      redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayVal));
   extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse        pulse1(period=600, startTime=300)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,80})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    rising=0,
    width=300,
    falling=0,
    period=600)
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
equation
  connect(pulse.y, genControlBus.yHeaPumSet) annotation (Line(points={{-19,70},
          {-14,70},{-14,74},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulse1.y, genControlBus.yBoi) annotation (Line(points={{39,80},{34,80},
          {34,74},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(trapezoid.y, genControlBus.uPriOrSecGen) annotation (Line(points={{-59,
          32},{-16,32},{-16,70},{-14,70},{-14,74},{10,74}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Generation/Tests/HeatPumpAndGasBoilerParallel.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for  
  <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel\">BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel</a>.
</p>
<p>
The system is designed at outdoor air temperature as bivalence temperature. 
As the system is part parallel and both devices operate, the system supplies twice the heat demand.
Thus, both operate with 50 percent part load. As the boilers heat flow rate
depends on the part load, the nominal conditions is not met exactly.
</p>
<p>
Furthermore, as the set compressor speed <code>yHeaPumSet</code> turns off
more than three times in one our, than the internal safety control prevents further operation.
Search for <code>yMea</code> in results to see the actual compressor 
speed applied.
</p>

</html>"));
end HeatPumpAndGasBoilerParallel;
