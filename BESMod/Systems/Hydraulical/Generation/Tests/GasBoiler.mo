within BESMod.Systems.Hydraulical.Generation.Tests;
model GasBoiler
  extends Generation.Tests.PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.GasBoiler generation(
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant constBoi(k=1)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation
  connect(constBoi.y, genControlBus.uBoiSet) annotation (Line(points={{-19,70},{-14,
          70},{-14,74},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end GasBoiler;
