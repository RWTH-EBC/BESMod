within BESMod.Tutorial.BaseClasses;
model PartialSystem
  parameter Real yMax "A top-down parameter. Example: Maximum value for y";

  replaceable BESMod.Tutorial.BaseClasses.PartialModule module constrainedby
    BESMod.Tutorial.BaseClasses.PartialModule(final yMax=yMax)
    "Correct overwrite of top-down parameters" annotation (Placement(
        transformation(extent={{-18,-18},{20,18}})), choicesAllMatching=true);
  replaceable BESMod.Tutorial.BaseClasses.PartialModule moduleWrong(final yMax=
        yMax) constrainedby BESMod.Tutorial.BaseClasses.PartialModule
    "Wrong overwrite of top-down parameters" annotation (Placement(
        transformation(extent={{-18,-78},{20,-42}})), choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealOutput y "Output signal connector" annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput yWrong "Output signal connector" annotation (Placement(transformation(extent={{100,-70},
            {120,-50}})));

  replaceable PartialModule                             module1
                                                               constrainedby
    PartialModule(                            final yMax=yMax)
    "Correct overwrite of top-down parameters" annotation (Placement(
        transformation(extent={{-18,42},{18,78}})),  choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealOutput yPhase "Output signal connector"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
equation
  connect(module.y, y) annotation (Line(points={{21.9,0},{110,0}}, color={0,0,127}));
  connect(moduleWrong.y, yWrong) annotation (Line(points={{21.9,-60},{110,-60}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialSystem;
