within BESMod.Systems.Hydraulical.Distribution.Tests;
model TwoStoragesBoilerWithDHW "Test two storages boiler with DHW"
  extends BaseClasses.PartialTest(
                      redeclare
      BESMod.Systems.Hydraulical.Distribution.TwoStoragesBoilerWithDHW
      distribution(
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayVal,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        parStoBuf,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        parStoDHW,
      redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayValBoi,
      redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPumGen));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse pulseBoi(
    width=25,
    period=pulse.period,
    startTime=0)    "Boiler control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,60})));
equation
  connect(pulse.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-59,80},{-30,
          80},{-30,79},{0,79}},       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulseBoi.y, sigBusDistr.yBoi) annotation (Line(points={{-31,60},{-28,60},
          {-28,79},{0,79}},
                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(booleanConstant.y, sigBusDistr.pumGenOn) annotation (Line(points={{-59,
          50},{0,50},{0,79}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Distribution/Tests/TwoStoragesBoilerWithDHW.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.TwoStoragesBoilerWithDHW\">BESMod.Systems.Hydraulical.Distribution.TwoStoragesBoilerWithDHW</a>.
</p>
<p>
The tests show how all mass flow rates always are met even though 
the three way valve is switching. Furthermore, the building supply tempereature 
decreases over time as the storage gets colder due to switching to DHW mode.
However, every time the boiler is turned on, the temperature rises. Also,
the nominal mass flow rate of the boiler is met.
</p>  
</html>"));
end TwoStoragesBoilerWithDHW;
