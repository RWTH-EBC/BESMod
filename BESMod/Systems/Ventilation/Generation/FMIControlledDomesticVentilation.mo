within BESMod.Systems.Ventilation.Generation;
model FMIControlledDomesticVentilation
  extends FMIReplaceableGeneration(
    redeclare package Medium=IBPSA.Media.Air,
    redeclare BESMod.Systems.Ventilation.Generation.ControlledDomesticVentilation generation(
      m_flow_nominal={0.08225917194444445},
      Q_flow_nominal={10632.414942943078},
      TOda_nominal(displayUnit="K") = 265.35,
      TDem_nominal(displayUnit="K") = {293.15},
      TAmb(displayUnit="K") = 293.15,
      dpDem_nominal(displayUnit="Pa") = {100.0},
      redeclare
          BESMod.Systems.Ventilation.Generation.RecordsCollection.DummyHeatExchangerRecovery
          parameters,
        redeclare IBPSA.Fluid.Actuators.Valves.ThreeWayLinear threeWayValve_b,
        redeclare IBPSA.Fluid.Actuators.Valves.ThreeWayLinear threeWayValve_a,
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          threeWayValveParas,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover fanData,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          tempSensorData));
end FMIControlledDomesticVentilation;
