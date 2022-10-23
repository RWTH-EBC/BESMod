within BESMod.Systems.Electrical.Distribution.BaseClasses;
partial model PartialDistribution
  parameter Boolean use_openModelica=true
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  parameter Integer nSubSys(min=2)
    "Number of subsystems with electrical load / generation";
  Interfaces.DistributionOutputs OutputDistr if not use_openModelica
                                             annotation (Placement(
        transformation(extent={{-10,-108},{10,-88}}), iconTransformation(extent=
           {{-10,-108},{10,-88}})));
  Interfaces.DistributionControlBus sigBusDistr annotation (Placement(
        transformation(extent={{-16,78},{18,112}}), iconTransformation(extent={{
            -16,78},{18,112}})));
  Interfaces.InternalElectricalPinIn internalElectricalPin[nSubSys]
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Interfaces.ExternalElectricalPin externalElectricalPin
    annotation (Placement(transformation(extent={{40,-108},{60,-88}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                              Text(
          extent={{-100,-74},{104,-170}},
          lineColor={0,0,0},
          textString="%name%"),
        Rectangle(
          extent={{-60,34},{66,-42}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,14},{40,-24}},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-6,19},{6,-19}},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={33,-6},
          rotation=-90,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-6,19},{6,-19}},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-25,-6},
          rotation=-90,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,54},{-24,40}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{24,54},{46,40}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),                                  Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialDistribution;
