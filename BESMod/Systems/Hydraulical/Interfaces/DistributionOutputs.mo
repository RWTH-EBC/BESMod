within BESMod.Systems.Hydraulical.Interfaces;
expandable connector DistributionOutputs
  "Bus with ouputs of the distribution system"
  extends BESMod.Systems.Interfaces.KPIBus;

  annotation (
  defaultComponentName = "outBusDist",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end DistributionOutputs;
