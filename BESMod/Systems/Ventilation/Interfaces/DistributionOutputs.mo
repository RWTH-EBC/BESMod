within BESMod.Systems.Ventilation.Interfaces;
expandable connector DistributionOutputs
  "Bus with ouputs of the distribution system"
  extends BESMod.Utilities.Icons.KPIBus;

  annotation (
  defaultComponentName = "outBusDist",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end DistributionOutputs;
