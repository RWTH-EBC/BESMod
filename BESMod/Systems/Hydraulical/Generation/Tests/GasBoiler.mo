within BESMod.Systems.Hydraulical.Generation.Tests;
model GasBoiler
  extends Generation.Tests.PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.GasBoiler generation(
      dTTra_nominal={10},
      redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse        pulse(period=1800)
    annotation (Placement(transformation(extent={{-42,68},{-22,88}})));
equation
  connect(pulse.y, genControlBus.uBoiSet) annotation (Line(points={{-21,78},{
          -18,78},{-18,74},{10,74}},
                color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulse.y, genControlBus.uPump) annotation (Line(points={{-21,78},{-18,
          78},{-18,74},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end GasBoiler;
