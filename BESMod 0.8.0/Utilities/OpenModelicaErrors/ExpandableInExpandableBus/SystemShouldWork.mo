within BESMod.Utilities.OpenModelicaErrors.ExpandableInExpandableBus;
model SystemShouldWork
  extends Modelica.Icons.Example;

  Subsystem subSys;

  Bus2 busOut;

equation
  connect(subSys.bus, busOut.subSys);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SystemShouldWork;
