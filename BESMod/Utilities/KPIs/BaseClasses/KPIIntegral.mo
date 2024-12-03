within BESMod.Utilities.KPIs.BaseClasses;
expandable connector KPIIntegral "Connector for KPIs"

  extends PartialKPIConnector;

  Real value
   "Current value";
  Real integral
   "Integral of value";

  annotation (Documentation(info="<html>
<p>Expandable connector for Key Performance Indicators (KPIs) that provides both current values and 
their integral over time.
</p>

<h4>KPIs</h4>
<ul>
<li><code>value</code>: Current value of the KPI</li>
<li><code>integral</code>: Time integral of the KPI value</li>
</ul>
</html>"));
end KPIIntegral;
