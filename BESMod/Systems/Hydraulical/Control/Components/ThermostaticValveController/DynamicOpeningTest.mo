within BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController;
model DynamicOpeningTest
  "Model with a constant opening of the valves"
  extends BaseClasses.PartialThermostaticValveController;
public
  parameter Real conOpe=1 "Constant opening";
  Modelica.Blocks.Sources.Trapezoid trapezoid[nZones](
    amplitude=-1,
    rising=30,
    width(displayUnit="d") = 1209600,
    falling=30,
    period(displayUnit="d") = 5184000,
    offset=1,
    startTime(displayUnit="d") = 5184000)
    annotation (Placement(transformation(extent={{-4,-58},{16,-38}})));
equation
  connect(trapezoid.y, opening) annotation (Line(points={{17,-48},{94,-48},{94,
          0},{120,0}}, color={0,0,127}));
end DynamicOpeningTest;
