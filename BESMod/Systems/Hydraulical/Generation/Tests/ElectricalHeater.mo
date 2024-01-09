within BESMod.Systems.Hydraulical.Generation.Tests;
model ElectricalHeater
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.ElectricalHeater
      generation(  redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        parPum,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
        parEleHea));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant     const1(k=1)
    annotation (Placement(transformation(extent={{-52,64},{-32,84}})));
equation
  connect(const1.y, genControlBus.uEleHea) annotation (Line(points={{-31,74},{
          10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end ElectricalHeater;
