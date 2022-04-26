within BESMod.Systems.Ventilation.Generation.Tests;
model ControlledDomesticVentilation
  extends PartialTest(redeclare
      BESMod.Systems.Ventilation.Generation.ControlledDomesticVentilation
      generation(
      redeclare
        BESMod.Systems.Ventilation.Generation.RecordsCollection.DummyHeatExchangerRecovery
        parameters(dpHex_nominal(displayUnit="Pa") = 100),
      redeclare IBPSA.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear
        threeWayValve_b,
      redeclare IBPSA.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear
        threeWayValve_a,
      redeclare
        BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        threeWayValveParas,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        fanData,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        tempSensorData));
  Interfaces.GenerationControlBus sigBusGen
    annotation (Placement(transformation(extent={{-4,54},{16,74}})));
equation
  connect(sigBusGen, generation.sigBusGen) annotation (Line(
      points={{6,64},{6,46.51},{5.52,46.51},{5.52,29.02}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end ControlledDomesticVentilation;
