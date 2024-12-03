within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialThermostaticValveControl
  "Only provide thermostatic valve control"
  extends PartialControl;
  parameter Boolean useOpeTemCtrl=false
    "=true to control the operative room temperature"
    annotation (Dialog(group="Building control"));
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlTypTheVal=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory valve control"
    annotation (Dialog(group="Building control"));
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses.PartialThermostaticValveController
    valCtrl constrainedby
    BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses.PartialThermostaticValveController(
     final nZones=parTra.nParallelDem)
    "Thermostatic valve controller" annotation (
      Dialog(group="Building control"), choicesAllMatching=true,
      Placement(transformation(extent={{82,-78},{98,-62}})));
  Utilities.SupervisoryControl.SupervisoryControl supCtrlTheVal[parTra.nParallelDem](
     each final ctrlType=supCtrlTypTheVal)
    "Supervisory control to possibly override local control"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
equation
  if useOpeTemCtrl then
    connect(valCtrl.TZoneMea, buiMeaBus.TZoneOpeMea) annotation (Line(points={{80.4,
            -65.2},{80.4,-66},{76,-66},{76,-116},{-250,-116},{-250,118},{65,118},
            {65,103}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  else
    connect(valCtrl.TZoneMea, buiMeaBus.TZoneMea) annotation (Line(points={{80.4,
            -65.2},{80.4,-66},{76,-66},{76,-116},{-250,-116},{-250,118},{65,118},
            {65,103}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  end if;
  connect(valCtrl.TZoneSet, useProBus.TZoneSet) annotation (Line(points={{80.4,-74.8},
          {76,-74.8},{76,-116},{-250,-116},{-250,102},{-119,102},{-119,103}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(supCtrlTheVal.y, sigBusTra.opening) annotation (Line(points={{142,-70},
          {174,-70},{174,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(valCtrl.opening, supCtrlTheVal.uLoc) annotation (Line(points={{99.6,-70},
          {110,-70},{110,-78},{118,-78}}, color={0,0,127}));
  annotation (Diagram(graphics={
        Rectangle(
          extent={{74,-58},{206,-100}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{76,-100},{180,-120}},
          lineColor={162,29,33},
          lineThickness=1,
          textString="Thermostatic Valve")}), Documentation(info="<html>
<p>Partial model providing base functionality for thermostatic valve control.</p>

<h4>Structure</h4>
<p>The model contains:</p>
<ul>
  <li>A supervisory control array for possible override of local control</li>
  <li>Conditional connections for either operative or air temperature measurement from building bus</li>
  <li>Temperature setpoint connection from profiles bus</li>
  <li>Signal routing for valve opening to transfer bus</li>
</ul>
</html>"));
end PartialThermostaticValveControl;
