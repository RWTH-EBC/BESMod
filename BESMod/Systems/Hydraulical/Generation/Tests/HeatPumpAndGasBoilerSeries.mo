within BESMod.Systems.Hydraulical.Generation.Tests;
model HeatPumpAndGasBoilerSeries
  "Test case for serial heat pump and gas boiler"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSerial
      generation(
      redeclare model PerDataMainHP =
          AixLib.Obsolete.Year2024.DataBase.HeatPump.PerformanceData.LookUpTable2D
          (dataTable=
              AixLib.Obsolete.Year2024.DataBase.HeatPump.EN255.Vitocal350AWI114
              ()),
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
        parHeaPum,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi));
   extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse        pulse(period=1800)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(pulse.y, genControlBus.yHeaPumSet) annotation (Line(points={{-19,90},
          {-14,90},{-14,98},{10,98},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulse.y, genControlBus.uPump) annotation (Line(points={{-19,90},{-14,
          90},{-14,98},{10,98},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulse.y, genControlBus.yBoi) annotation (Line(points={{-19,90},{-14,90},
          {-14,98},{10,98},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end HeatPumpAndGasBoilerSeries;
