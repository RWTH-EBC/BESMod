within BESMod.Tutorial.BaseClasses;
model PartialSystem
  parameter Real yMax "A top-down parameter. Example: Maximum value for y";

  replaceable BESMod.Tutorial.BaseClasses.PartialModule module constrainedby
    BESMod.Tutorial.BaseClasses.PartialModule(final yMax=yMax)
    "Correct overwrite of top-down parameters" annotation (Placement(
        transformation(extent={{-22,-24},{24,24}})), choicesAllMatching=true);
  replaceable BESMod.Tutorial.BaseClasses.PartialModule moduleWrong(final yMax=
        yMax) constrainedby BESMod.Tutorial.BaseClasses.PartialModule
    "Wrong overwrite of top-down parameters" annotation (Placement(
        transformation(extent={{-22,-90},{24,-42}})), choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealOutput y "Output signal connector" annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput yWrong "Output signal connector" annotation (Placement(transformation(extent={{100,-76},{120,-56}})));

equation
  connect(module.y, y) annotation (Line(points={{26.3,0},{110,0}}, color={0,0,127}));
  connect(moduleWrong.y, yWrong) annotation (Line(points={{26.3,-66},{110,-66}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSystem;
