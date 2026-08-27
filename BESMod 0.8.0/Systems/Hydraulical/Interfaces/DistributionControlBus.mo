within BESMod.Systems.Hydraulical.Interfaces;
expandable connector DistributionControlBus
  "data bus with control signals for generation model"
extends BESMod.Utilities.Icons.ControlBus;

annotation (
  defaultComponentName = "sigBusDistr",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end DistributionControlBus;
