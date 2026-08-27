within BESMod.Utilities.OpenModelicaErrors.VirtualVariable;
model SystemWorks
  extends Modelica.Icons.Example;

  Subsystem subSys;

  BusWithVar bus;

equation
  connect(subSys.somCon.y, bus.subSys.y);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SystemWorks;
