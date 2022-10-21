within BESMod.Systems.Hydraulical.Interfaces;
expandable connector TransferOutputs "Bus with ouputs of the tramsfer system"
  extends BESMod.Systems.Interfaces.KPIBus;

  annotation (
  defaultComponentName = "outBusTra",
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false)),
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));

end TransferOutputs;
