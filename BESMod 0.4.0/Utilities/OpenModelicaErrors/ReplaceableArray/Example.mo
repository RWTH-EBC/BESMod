within BESMod.Utilities.OpenModelicaErrors.ReplaceableArray;
model Example
  extends Modelica.Icons.Example;

  parameter Real extArr[5] = {1, 2, 3, 4, 5};

  UseReplaceableModel repArrSouldWork[5](
  redeclare ReplaceableModel rep(each a1=1, a2=extArr));

  UseReplaceableModel repArrWorks[5](
  redeclare ReplaceableModel rep(each a1=1, each a2=5));

  UseReplaceableModel repArrShouldNotWork[5](
  redeclare ReplaceableModel rep(each a1=1, each a2=5));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Example;
