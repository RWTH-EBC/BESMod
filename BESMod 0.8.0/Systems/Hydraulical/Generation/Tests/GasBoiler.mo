within BESMod.Systems.Hydraulical.Generation.Tests;
model GasBoiler
  extends Generation.Tests.PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.GasBoiler generation(dTTra_nominal=
          {10},
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen));
  extends Modelica.Icons.Example;

equation
  connect(pulse.y, genControlBus.uBoiSet) annotation (Line(points={{-19,70},{
          -14,70},{-14,74},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Generation/Tests/GasBoiler.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.GasBoiler\">BESMod.Systems.Hydraulical.Generation.GasBoiler</a>.
</p>
</html>"));
end GasBoiler;
