within BESMod.Systems.Electrical.Transfer;
model NoElectricalTransfer "No transfer system"
  extends BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer;
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{16,64},{36,84}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow[
    nParallelDem](each final Q_flow=0)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{36,74},{48,74},{48,100}},
      color={0,0,0},
      thickness=1));
  connect(fixedHeatFlow.port, heatPortCon) annotation (Line(points={{60,0},{86,
          0},{86,38},{100,38}}, color={191,0,0}));
  connect(fixedHeatFlow.port, heatPortRad) annotation (Line(points={{60,0},{86,
          0},{86,-38},{100,-38}}, color={191,0,0}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NoElectricalTransfer;
