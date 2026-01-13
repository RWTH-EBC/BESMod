within BESMod.Systems.Electrical.Transfer.BaseClasses;
partial model PartialTransfer "Partial model for transfer subsystems"
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  parameter Integer nParallelDem(min=1)
    "Number of parallel demand systems of this system" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal[nParallelDem](each min=Modelica.Constants.eps)
    "Nominal heat flow rate" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  Interfaces.TransferOutputs transferOutputs if not use_openModelica
                                             annotation (Placement(
        transformation(extent={{-16,-114},{16,-84}}), iconTransformation(extent=
           {{-16,-114},{16,-84}})));
  Interfaces.TransferControlBus transferControlBus annotation (Placement(
        transformation(extent={{-14,84},{14,112}}), iconTransformation(extent={
            {-14,84},{14,112}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon[nParallelDem]
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{90,28},{110,48}}),
        iconTransformation(extent={{90,30},{110,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad[nParallelDem]
    "Heat port for radiative heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{90,-48},{110,-28}}),
        iconTransformation(extent={{90,-18},{110,2}})));
  Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{38,90},{58,110}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                              Text(
          extent={{-100,-80},{104,-176}},
          lineColor={0,0,0},
          textString="%name%"),
        Line(
          points={{-58,92},{-98,34},{-72,34},{-86,-20},{-26,50},{-62,50},{-36,92},
              {-58,92}},
          color={0,0,0},
          thickness=1),
                  Line(
          points={{-30,30},{-28,-2},{-10,6},{-6,6},{-2,4}},
          color={238,46,47},
          thickness=1,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-18,-4},{-8,-10},{-8,-5.81411e-16},{-18,-4}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={4,-8},
          rotation=-90),
        Rectangle(
          extent={{18,-22},{88,-84}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{18,-22},{52,20},{88,-22}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{10,-32},{92,-80}},
          lineColor={238,46,47},
          textString="Q̇")}),                                   Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialTransfer;
