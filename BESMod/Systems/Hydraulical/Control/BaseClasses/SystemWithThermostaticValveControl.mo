within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model SystemWithThermostaticValveControl
  extends PartialControl;
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses.PartialThermostaticValveController
    thermostaticValveController constrainedby
    BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses.PartialThermostaticValveController(
      final nZones=transferParameters.nParallelDem, final leakageOpening=
        thermostaticValveParameters.leakageOpening) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{112,-94},{138,
            -64}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
    thermostaticValveParameters annotation (choicesAllMatching=true, Placement(
        transformation(extent={{178,-80},{198,-60}})));
equation
  connect(thermostaticValveController.opening, sigBusTra.opening) annotation (
      Line(points={{140.6,-79},{174,-79},{174,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(thermostaticValveController.TZoneMea, buiMeaBus.TZoneMea) annotation (
     Line(points={{109.4,-70},{104,-70},{104,-42},{238,-42},{238,103},{65,103}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(thermostaticValveController.TZoneSet, useProBus.TZoneSet) annotation (
     Line(points={{109.4,-88},{102,-88},{102,-40},{236,-40},{236,103},{-119,103}},
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
end SystemWithThermostaticValveControl;
