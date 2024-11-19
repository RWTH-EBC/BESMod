within BESMod.Systems.Control.BaseClasses;
partial model PartialControl "Model for a partial HEMS control"
  extends BESMod.Utilities.Icons.ControlIcon;
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  BESMod.Systems.Hydraulical.Interfaces.SystemControlBus sigBusHyd annotation (Placement(
        transformation(extent={{-94,-114},{-64,-88}}), iconTransformation(
          extent={{-94,-114},{-64,-88}})));
  BESMod.Systems.Ventilation.Interfaces.SystemControlBus sigBusVen annotation (Placement(
        transformation(extent={{64,-114},{96,-86}}), iconTransformation(extent=
            {{64,-114},{96,-86}})));
  BESMod.Systems.Interfaces.ControlOutputs outBusCtrl if not use_openModelica
                                       annotation (Placement(transformation(
          extent={{84,-16},{118,16}}), iconTransformation(extent={{84,-16},{118,
            16}})));
  BESMod.Systems.Electrical.Interfaces.SystemControlBus sigBusEle annotation (Placement(
        transformation(extent={{-116,-14},{-84,14}}), iconTransformation(extent=
           {{-116,-14},{-84,14}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-80,78},{-38,124}}),
        iconTransformation(extent={{-74,88},{-48,114}})));
  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (
      Placement(transformation(extent={{36,82},{82,120}}), iconTransformation(
          extent={{44,88},{72,114}})));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>
This is a partial model defining a Home Energy Management System (HEMS) control interface. 
It serves as a base class for implementing specific control strategies.
</p>

<h4>Connectors</h4>
<p>
<ul>
<li><code>sigBusHyd</code>: Control bus for hydraulic system (<a href=\"modelica://BESMod.Systems.Hydraulical.Interfaces.SystemControlBus\">BESMod.Systems.Hydraulical.Interfaces.SystemControlBus</a>)</li>
<li><code>sigBusVen</code>: Control bus for ventilation system (<a href=\"modelica://BESMod.Systems.Ventilation.Interfaces.SystemControlBus\">BESMod.Systems.Ventilation.Interfaces.SystemControlBus</a>)</li>
<li><code>sigBusEle</code>: Control bus for electrical system (<a href=\"modelica://BESMod.Systems.Electrical.Interfaces.SystemControlBus\">BESMod.Systems.Electrical.Interfaces.SystemControlBus</a>)</li>
<li><code>outBusCtrl</code>: Central control output bus, disabled when use_openModelica=true (<a href=\"modelica://BESMod.Systems.Interfaces.ControlOutputs\">BESMod.Systems.Interfaces.ControlOutputs</a>)</li>
<li><code>useProBus</code>: User profiles bus (<a href=\"modelica://BESMod.Systems.Interfaces.UseProBus\">BESMod.Systems.Interfaces.UseProBus</a>)</li>
<li><code>buiMeaBus</code>: Building measurements bus (<a href=\"modelica://BESMod.Systems.Interfaces.BuiMeaBus\">BESMod.Systems.Interfaces.BuiMeaBus</a>)</li>
</ul>
</p>
</html>"));
end PartialControl;
