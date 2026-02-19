within BESMod.Systems.Electrical.Generation.BaseClasses;
partial model PartialGeneration
  "Basic model with interfaces for electrical generation package"
  parameter Boolean use_openModelica=true
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  parameter Integer numGenUnits(min=1) "Number of generation (e.g. PV module) units"
  annotation(Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Real f_design[numGenUnits]=
    fill(0.8, numGenUnits)
    "Over-/undersizing factor relative to maximum capacity, e.g., roof area"
    annotation(Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Area ARoo(min=0) "Roof area of building"
    annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-120,44},{-80,84}}), iconTransformation(extent={{-110,66},
            {-90,86}})));
  Interfaces.GenerationOutputs outBusGen if not use_openModelica
                                         annotation (Placement(transformation(
          extent={{-14,-112},{14,-86}}), iconTransformation(extent={{-14,-112},
            {14,-86}})));
  Interfaces.GenerationControlBus controlBusGen annotation (Placement(
        transformation(extent={{-12,86},{14,110}}), iconTransformation(extent={
            {-12,86},{14,110}})));
  Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{40,88},{60,108}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                              Text(
          extent={{-98,-82},{106,-178}},
          lineColor={0,0,0},
          textString="%name%"),
        Ellipse(
          extent={{-90,66},{-56,30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
                  Line(
          points={{-38,70},{-12,30},{12,82},{36,44},{44,42}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.Bezier),
        Text(
          extent={{34,22},{120,-28}},
          lineColor={0,0,0},
          textString="P"),
        Polygon(
          points={{42,50},{42,34},{54,42},{42,50}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
                  Line(
          points={{-36,20},{-10,-20},{14,32},{38,-6},{46,-8}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.Bezier),
                  Line(
          points={{-32,-38},{-6,-78},{18,-26},{42,-64},{50,-66}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-54,58},{-52,48},{-46,54},{-42,52},{-40,48},{-38,42},{-38,36},
              {-46,26},{-76,18},{-92,26},{-98,32},{-98,42},{-96,46},{-86,46},{
              -72,40},{-74,52},{-66,58},{-58,60},{-54,58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.Bezier,
          fillColor={230,230,230},
          lineThickness=0.5),
        Line(
          points={{-74,-56},{-76,-94},{-66,-94},{-70,-56},{-74,-56}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Ellipse(
          extent={{-76,-48},{-68,-58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,-58},{-50,-66},{-68,-54}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-74,-48},{-72,-28},{-70,-48}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-74,-58},{-92,-66},{-76,-54}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Rectangle(
          extent={{-86,8},{-56,-26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,8},{-80,-26}},
          color={255,255,255},
          thickness=1),
        Line(
          points={{-74,8},{-74,-26}},
          color={255,255,255},
          thickness=1),
        Line(
          points={{-68,8},{-68,-26}},
          color={255,255,255},
          thickness=1),
        Line(
          points={{-62,8},{-62,-26}},
          color={255,255,255},
          thickness=1),
        Line(
          points={{-86,2},{-56,2}},
          color={255,255,255},
          thickness=1),
        Line(
          points={{-86,-4},{-56,-4}},
          color={255,255,255},
          thickness=1),
        Line(
          points={{-86,-12},{-56,-12}},
          color={255,255,255},
          thickness=1),
        Line(
          points={{-86,-20},{-56,-20}},
          color={255,255,255},
          thickness=1),
        Polygon(
          points={{46,0},{46,-16},{58,-8},{46,0}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,-58},{50,-74},{62,-66},{50,-58}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialGeneration;
