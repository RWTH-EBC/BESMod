within BESMod.Utilities.OpenModelicaErrors.VirtualVariable;
model Subsystem

  SomeConnector somCon;

  Modelica.Blocks.Sources.Constant con(k=1);
equation
  connect(con.y, somCon.y);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Subsystem;
