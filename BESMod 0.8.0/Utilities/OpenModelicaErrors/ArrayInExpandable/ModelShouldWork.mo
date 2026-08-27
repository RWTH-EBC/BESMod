within BESMod.Utilities.OpenModelicaErrors.ArrayInExpandable;
model ModelShouldWork
  extends Modelica.Icons.Example;

  Bus bus;

  Modelica.Blocks.Sources.Constant con[3](each k=1);
equation
  connect(con.y, bus.arr);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ModelShouldWork;
