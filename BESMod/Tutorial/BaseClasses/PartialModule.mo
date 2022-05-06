within BESMod.Tutorial.BaseClasses;
partial model PartialModule "The partial base-class"

  parameter Real yMax "A top-down parameter. Example: Maximum value for y"  annotation (Dialog(group=
          "Top-Down"));
  parameter Real timePeriod
    "A bottom-up parameter. Example: The estimated period time"                          annotation (Dialog(group=
          "Bottom-Up"));

  Modelica.Blocks.Interfaces.RealOutput y "Output signal connector"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-60,52},{64,-30}},
          textColor={28,108,200},
          textString="%name%")}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialModule;
