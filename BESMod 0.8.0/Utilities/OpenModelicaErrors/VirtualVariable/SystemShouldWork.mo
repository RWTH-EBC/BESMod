within BESMod.Utilities.OpenModelicaErrors.VirtualVariable;
model SystemShouldWork
  extends Modelica.Icons.Example;

  Subsystem subSys;

  Bus bus;

equation
  connect(subSys.somCon, bus.subSys);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SystemShouldWork;
