within BESMod.Utilities.KPIs.BaseClasses;
connector KPIDevice "Connector for KPIs of number of switches"

  extends PartialKPIConnector;

  Modelica.Blocks.Interfaces.IntegerOutput numSwi
      "Number of switches";
  Modelica.Blocks.Interfaces.RealOutput sinOnTim(
    final unit="s",
    final displayUnit="h")
      "Time the device is on in a single on-cycle";
  Modelica.Blocks.Interfaces.RealOutput totOnTim(
    final unit="s",
    final displayUnit="h")
      "Total time the device is on";
end KPIDevice;
