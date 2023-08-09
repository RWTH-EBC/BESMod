within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialThermostaticValveControl
  "Only provide thermostatic valve control"
  extends PartialControl;
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses.PartialThermostaticValveController
    thermostaticValveController constrainedby
    BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses.PartialThermostaticValveController(
      final nZones=transferParameters.nParallelDem, final leakageOpening=
        parTheVal.leakageOpening) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{122,-78},{138,
            -62}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
    parTheVal "Thermostatic valve parameters"
              annotation (choicesAllMatching=true, Placement(
        transformation(extent={{182,-78},{198,-62}})));
equation
  connect(thermostaticValveController.opening, sigBusTra.opening) annotation (
      Line(points={{139.6,-70},{174,-70},{174,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(thermostaticValveController.TZoneMea, buiMeaBus.TZoneMea) annotation (
     Line(points={{120.4,-65.2},{120.4,-66},{76,-66},{76,-116},{-250,-116},{-250,
          118},{65,118},{65,103}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(thermostaticValveController.TZoneSet, useProBus.TZoneSet) annotation (
     Line(points={{120.4,-74.8},{76,-74.8},{76,-116},{-250,-116},{-250,102},{-119,
          102},{-119,103}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(graphics={
        Rectangle(
          extent={{74,-58},{206,-100}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{76,-100},{180,-120}},
          lineColor={162,29,33},
          lineThickness=1,
          textString="Thermostatic Valve")}));
end PartialThermostaticValveControl;
