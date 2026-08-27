within BESMod.Utilities.OpenModelicaErrors.ReplaceableArray;
model UseReplaceableModel

  replaceable ReplaceableModel rep constrainedby ReplaceableModel(a1=1, a2=1);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UseReplaceableModel;
