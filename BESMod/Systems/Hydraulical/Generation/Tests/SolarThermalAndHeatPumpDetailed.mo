within BESMod.Systems.Hydraulical.Generation.Tests;
model SolarThermalAndHeatPumpDetailed "Test for SolarThermalAndHeatPumpDetailed"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.DetailedSolarThermalWithHeatPump
      generation(
      redeclare model PerDataMainHP =
          AixLib.DataBase.HeatPump.PerformanceData.LookUpTable2D (dataTable=
              AixLib.DataBase.HeatPump.EN14511.Vitocal200AWO201()),
      redeclare BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
        parHeaPum,
      redeclare BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultSolarThermal
        solarThermalParas,
      redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPumSolThe,
      redeclare BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
        parEleHea));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant     const1(k=0)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
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
  connect(const1.y, genControlBus.uEleHea) annotation (Line(points={{-79,50},{
          -32,50},{-32,48},{10,48},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end SolarThermalAndHeatPumpDetailed;
