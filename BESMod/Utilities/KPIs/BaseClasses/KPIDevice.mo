within BESMod.Utilities.KPIs.BaseClasses;
expandable connector KPIDevice "Connector for KPIs of number of switches"

  extends PartialKPIConnector;

  Integer numSwi
      "Number of switches";
  Real sinOnTim(
    final unit="s",
    final displayUnit="h")
      "Time the device is on in a single on-cycle";
  Real totOnTim(
    final unit="s",
    final displayUnit="h")
      "Total time the device is on";
  annotation (Documentation(info="<html>
<p>Expandable connector for device key performance indicators (KPIs) 
focusing on switching behavior and operation times. 
The connector inherits base definitions from <a href=\"modelica://BESMod.Utilities.KPIs.BaseClasses.PartialKPIConnector\">BESMod.Utilities.KPIs.BaseClasses.PartialKPIConnector</a>.</p>

<h4>KPIs</h4>
<ul>
<li><code>numSwi</code>: Integer value counting the number of device switches</li>
<li><code>sinOnTim</code>: Duration the device operates in a single on-cycle (unit: s, display unit: h)</li> 
<li><code>totOnTim</code>: Accumulated time the device has been operating (unit: s, display unit: h)</li>
</ul>
</html>"));
end KPIDevice;
