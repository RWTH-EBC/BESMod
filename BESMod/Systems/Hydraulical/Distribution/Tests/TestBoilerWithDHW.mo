within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestBoilerWithDHW "Test two storages boiler with DHW"
  extends PartialTest(redeclare
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

  Modelica.Blocks.Sources.Pulse        pulse(period=100) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,90})));
  Modelica.Blocks.Sources.Pulse pulseBoi(
    width=10,
    period=86400,
    startTime=3600) "Boiler control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,50})));
equation
  connect(pulse.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-59,90},{
          -44,90},{-44,81},{-14,81}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulseBoi.y, sigBusDistr.yBoi) annotation (Line(points={{-59,50},{-14,50},
          {-14,81}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TestBoilerWithDHW;
