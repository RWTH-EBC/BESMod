within BESMod.Systems.Interfaces;
expandable connector HydraulicOutputs
  "Bus with ouputs of the hydraulic system"
  extends BESMod.Systems.Interfaces.KPIBus;

  annotation (
  defaultComponentName = "outBusHyd",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end HydraulicOutputs;
