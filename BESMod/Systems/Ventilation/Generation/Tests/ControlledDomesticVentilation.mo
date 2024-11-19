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
  extends Modelica.Icons.Example;


  Interfaces.GenerationControlBus sigBusGen
    annotation (Placement(transformation(extent={{-4,54},{16,74}})));
  Modelica.Blocks.Sources.Step step(height=1, startTime=1800)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(sigBusGen, generation.sigBusGen) annotation (Line(
      points={{6,64},{6,46.51},{5.52,46.51},{5.52,29.02}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(step.y, sigBusGen.uByPass) annotation (Line(points={{-79,10},{-26,10},
          {-26,64},{6,64}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Test model for a controlled domestic ventilation system with heat recovery. 
The model extends from <a href=\"modelica://BESMod.Systems.Ventilation.Generation.Tests.PartialTest\">PartialTest</a> 
and uses a <a href=\"modelica://BESMod.Systems.Ventilation.Generation.ControlledDomesticVentilation\">ControlledDomesticVentilation</a> system.
</p>

<h4>Important Parameters</h4>
<ul>
  <li>Heat exchanger pressure drop (dpHex_nominal): 100 Pa</li>
  <li>Three-way valves: Equal percentage linear characteristics</li>
  <li>Components configured using default records for:
    <ul>
      <li>Three-way valve parameters</li> 
      <li>Fan data</li>
      <li>Temperature sensors</li>
    </ul>
  </li>
</ul>
</html>"));
end ControlledDomesticVentilation;
