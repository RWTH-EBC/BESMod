within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestDirectLoading
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedDirectLoading
      distribution(
      QHRAftBuf_flow_nominal=0,
      use_heatingRodAfterBuffer=false,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        temperatureSensorData,
      redeclare
        BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        threeWayValveParameters,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        bufParameters,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        dhwParameters(dTLoadingHC1=5),
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
        heatingRodAftBufParameters));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=100) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,88})));
equation
  connect(booleanPulse.y, sigBusDistr.dhw_on) annotation (Line(points={{-57,88},
          {-42,88},{-42,81},{-14,81}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TestDirectLoading;
