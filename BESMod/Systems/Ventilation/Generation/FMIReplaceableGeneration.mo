within BESMod.Systems.Ventilation.Generation;
model FMIReplaceableGeneration
  "FMI export container for venilation generation"
  extends BESMod.Utilities.FMI.PartialNPort(
    allowFlowReversal=generation.allowFlowReversal,
    use_p_in=true,
    final n=generation.nParallelDem,
    dpCom(y=generation.portGen_in.p - generation.portGen_out.p));

public
  replaceable BESMod.Systems.Ventilation.Generation.BaseClasses.PartialGeneration generation
    constrainedby
    BESMod.Systems.Ventilation.Generation.BaseClasses.PartialGeneration(
      redeclare final package Medium = Medium)
    "Component that holds the actual model"
    annotation (Placement(transformation(extent={{-20,-20},{20,22}})));
equation

  connect(bouInl.port_b, generation.portVent_in) annotation (Line(points={{-50,
          0},{-26,0},{-26,9.82},{-20,9.82}}, color={0,127,255}));
  connect(bouOut.port_a, generation.portVent_out) annotation (Line(points={{50,
          0},{28,0},{28,-32},{-28,-32},{-28,-7.4},{-20,-7.4}}, color={0,127,255}));
  connect(generation.internalElectricalPin, internalElectricalPin1) annotation
    (Line(
      points={{14,-19.58},{14,-20},{88,-20},{88,-30},{104,-30}},
      color={0,0,0},
      thickness=1));
  connect(generation.outBusGen, outBus) annotation (Line(
      points={{20.4,0.79},{22,0.79},{22,-60},{104,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(generation.sigBusGen, sigBus) annotation (Line(
      points={{-8.4,21.58},{-8.4,98},{1,98},{1,99}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(generation.weaBus, weaBus) annotation (Line(
      points={{0.4,22},{0.4,76},{-102,76}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
          Rectangle(
          extent={{-86,90},{86,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,40},{26,16},{40,28},{26,40}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{20,52},{102,4}},
          lineColor={238,46,47},
          textString="Q̇"),
                  Line(
          points={{-42,42},{-16,14},{0,50},{20,28},{34,28}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
        Text(
          extent={{-106,54},{-20,6}},
          lineColor={0,0,0},
          textString="P"),
                  Line(
          points={{-42,82},{-16,54},{0,90},{20,68},{34,68}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
        Polygon(
          points={{26,80},{26,56},{40,68},{26,80}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,-2},{26,-26},{40,-14},{26,-2}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
                  Line(
          points={{-44,2},{-18,-26},{-2,10},{18,-12},{32,-12}},
          color={238,46,47},
          thickness=3,
          smooth=Smooth.Bezier),
                 Bitmap(extent={{-64,-96},{56,-34}},fileName=
            "modelica://IBPSA/Resources/Images/Fluid/FMI/FMI_icon.png")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FMIReplaceableGeneration;
