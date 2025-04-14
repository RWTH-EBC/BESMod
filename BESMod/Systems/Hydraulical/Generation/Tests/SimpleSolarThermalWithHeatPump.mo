within BESMod.Systems.Hydraulical.Generation.Tests;
model SimpleSolarThermalWithHeatPump
  "Test for SolarThermalAndHeatPumpSimple"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.SimpleSolarThermalWithHeatPump
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
      TBiv=265.15,
      QPriAtTOdaNom_flow_nominal=8201,
      redeclare package MediumEva = IBPSA.Media.Air,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.DefaultSolarThermal
        parSolThe,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
        parEleHea));

  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant     const1(k=1)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,80})));

equation
  connect(pulse.y, genControlBus.yHeaPumSet) annotation (Line(points={{-19,70},{
          -12,70},{-12,74},{10,74}},          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const1.y, genControlBus.uEleHea) annotation (Line(points={{39,80},{34,
          80},{34,74},{10,74}},              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Generation/Tests/SimpleSolarThermalWithHeatPump.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for  
  <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.SimpleSolarThermalWithHeatPump\">BESMod.Systems.Hydraulical.Generation.SimpleSolarThermalWithHeatPump</a>.
</p>
<p>
The system is designed at -8 °C bivalence temperature. 
A seperate simulation yielded 8201 W for <code>QPriAtTOdaNom_flow_nominal</code>.
As the collector is not sized automatically and the components are
already tested in the component libraries, the heat flow rate and temperature is not 
of interest to this test.
</p>

<p>
As the set compressor speed <code>yHeaPumSet</code> actuates faster 
than the internal safety control, the device sometimes runs longer than set. 
Search for <code>yMea</code> in results to see the actual compressor 
speed applied.
</p>

</html>"));
end SimpleSolarThermalWithHeatPump;
