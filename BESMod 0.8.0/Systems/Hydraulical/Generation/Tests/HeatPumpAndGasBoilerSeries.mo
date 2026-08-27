within BESMod.Systems.Hydraulical.Generation.Tests;
model HeatPumpAndGasBoilerSeries
  "Test case for serial heat pump and gas boiler"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSerial
      generation(
      redeclare model RefrigerantCycleHeatPumpHeating =
          AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D
          (redeclare
            AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
            datTab),
      redeclare
        AixLib.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
        safCtrPar,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
        parHeaPum,
      redeclare BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi), pulse(
        amplitude=0.5));
   extends Modelica.Icons.Example;


equation
  connect(pulse.y, genControlBus.yHeaPumSet) annotation (Line(points={{-19,70},{
          -14,70},{-14,98},{10,98},{10,74}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulse.y, genControlBus.yBoi) annotation (Line(points={{-19,70},{-14,70},
          {-14,98},{10,98},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Generation/Tests/HeatPumpAndGasBoilerSeries.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for  
  <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSeries\">BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSeries</a>.
</p>
<p>
The system is designed at outdoor air temperature as bivalence temperature. 
As the system is part parallel and both devices operate, the system supplies twice the heat demand.
Thus, both operate with 50 percent part load. As the boilers heat flow rate
depends on the part load, the nominal conditions is not met exactly.
</p>
<p>
Furthermore, as the set compressor speed <code>yHeaPumSet</code> actuates faster 
than the internal safety control, the device sometimes runs longer than set. 
Search for <code>yMea</code> in results to see the actual compressor 
speed applied.
</p>

</html>"));
end HeatPumpAndGasBoilerSeries;
