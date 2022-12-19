within BESMod.Utilities.KPIs.BaseClasses;
expandable connector KPIIntegral "Connector for KPIs"

  extends PartialKPIConnector;

  Real value
   "Current value";
  Real integral
   "Integral of value";

end KPIIntegral;
