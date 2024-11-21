within BESMod.Systems.Hydraulical.Generation.Tests;
model ElectricalHeater
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.ElectricalHeater generation(
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
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
  annotation (Documentation(info="<html>
<p>
  Test model for an electrical heater system. 
  The model uses an electrical heater as generation system with default parameter 
  settings for the pump and the electrical heater itself.
</p>

<h4>Control</h4>
<p>
  The model uses a constant control signal (value = 1) connected to the generation control bus 
variable <code>uEleHea</code> for the electrical heater operation.
</p>
</html>"));
end ElectricalHeater;
