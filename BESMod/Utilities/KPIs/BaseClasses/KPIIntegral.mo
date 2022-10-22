within BESMod.Utilities.KPIs.BaseClasses;
connector KPIIntegral "Connector for KPIs"

  extends PartialKPIConnector;

  Modelica.Blocks.Interfaces.RealOutput value
      "Current value";
  Modelica.Blocks.Interfaces.RealOutput integral
   "Integral of value";

end KPIIntegral;
