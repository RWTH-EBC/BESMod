within BESMod.Systems.Electrical.Transfer;
model FMIReplaceableTransfer
  "FMI export container for electric transfer models"
  extends Utilities.FMI.PartialHeatPorts(final nHeatPorts=transfer.nParallelDem);
  replaceable BaseClasses.PartialTransfer transfer
    annotation (Placement(transformation(extent={{-36,-38},{38,38}})));
  Interfaces.TransferOutputs transferOutputs
    annotation (Placement(transformation(extent={{28,-124},{68,-84}})));
  Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Interfaces.TransferControlBus transferControlBus
    annotation (Placement(transformation(extent={{-42,92},{-22,112}})));
equation
  connect(transfer.heatPortCon, heatPortCon_TtoQ.heatPort) annotation (Line(
        points={{38,15.2},{38,14},{56,14},{56,90},{76,90}}, color={191,0,0}));
  connect(transfer.heatPortRad, heatPortRad_TtoQ.heatPort) annotation (Line(
        points={{38,-3.04},{38,-2},{62,-2},{62,22},{76,22}},   color={191,0,0}));
  connect(transfer.transferOutputs, transferOutputs) annotation (Line(
      points={{1,-37.62},{0,-37.62},{0,-40},{48,-40},{48,-104}},
      color={255,204,51},
      thickness=0.5));
  connect(transfer.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{18.76,38},{18.76,40},{40,40},{40,100}},
      color={0,0,0},
      thickness=1));
  connect(transfer.transferControlBus, transferControlBus) annotation (Line(
      points={{1,37.24},{1,40},{-32,40},{-32,102}},
      color={255,204,51},
      thickness=0.5));
  connect(transfer.heatPortRad, heatPortRad_QtoT.heatPort) annotation (Line(
        points={{38,-3.04},{38,-2},{62,-2},{62,-12},{76,-12}}, color={191,0,0}));
  connect(transfer.heatPortCon, heatPortCon_QtoT.heatPort) annotation (Line(
        points={{38,15.2},{38,14},{56,14},{56,56},{76,56}}, color={191,0,0}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
          Rectangle(
          extent={{-88,90},{86,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                 Bitmap(extent={{-66,-96},{54,-34}},fileName=
            "modelica://IBPSA/Resources/Images/Fluid/FMI/FMI_icon.png"),
        Line(
          points={{-42,86},{-82,28},{-60,28},{-80,-20},{-26,44},{-50,44},{-22,
              86},{-42,86}},
          color={0,0,0},
          thickness=1),
                  Line(
          points={{-38,22},{-28,0},{-20,24},{-10,18},{0,14}},
          color={238,46,47},
          thickness=1,
          smooth=Smooth.Bezier),
        Polygon(
          points={{16,-4},{8,-10},{8,0},{16,-4}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-14,20},
          rotation=360),
        Rectangle(
          extent={{12,30},{76,-24}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{12,30},{44,72},{76,30}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{2,26},{84,-22}},
          lineColor={238,46,47},
          textString="Q̇")}));
end FMIReplaceableTransfer;
