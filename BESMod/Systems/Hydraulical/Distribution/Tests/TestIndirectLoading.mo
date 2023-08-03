within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestIndirectLoading
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedIndirectLoading
      distribution(
      QHRAftBuf_flow_nominal=0,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare
        BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayVal,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        parStoBuf,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        parStoDHW,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
        parHeaRodAftBuf,
      dTLoaHCBuf=10));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse        pulse(       period=100) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,90})));
equation
  connect(pulse.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-59,90},{
          -44,90},{-44,81},{-14,81}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TestIndirectLoading;
