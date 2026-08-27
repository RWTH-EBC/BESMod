within BESMod.Utilities.OpenModelicaErrors.ExpandableInExpandableBus;
model Subsystem

  Bus1 bus;

  Modelica.Blocks.Sources.Constant con(k=1);
equation
  connect(con.y, bus.someVar);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Subsystem;
