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
end KPIDevice;
