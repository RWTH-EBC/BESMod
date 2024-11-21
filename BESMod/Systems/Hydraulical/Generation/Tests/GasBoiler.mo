within BESMod.Systems.Hydraulical.Generation.Tests;
model GasBoiler
  extends Generation.Tests.PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.GasBoiler generation(
      dTTra_nominal={10},
      redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW
        parBoi,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum));
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
  annotation (Documentation(info="<html>
<p>Test model for a gas boiler system <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.GasBoiler\">BESMod.Systems.Hydraulical.Generation.GasBoiler</a>.
This tests uses the Viessmann Vitogas 200-F 11kW boiler as heat generator.</p>

<h4>Control</h4>
<p>The model uses a pulse signal with a period of 1800s to control both 
the boiler setpoint temperature and pump operation through the control bus.</p>
</html>"));
end GasBoiler;
