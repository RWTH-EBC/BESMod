within BESMod.Systems.Hydraulical.Interfaces;
expandable connector DistributionOutputs
  "Bus with ouputs of the distribution system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusDist",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));

end DistributionOutputs;
