within BESMod.Systems.Electrical.Transfer;
model NoElectricalTransfer "No transfer system"
  extends BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer;
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow[
    nParallelDem](each final Q_flow=0)
    annotation (Placement(transformation(extent={{56,-10},{76,10}})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{16,64},{36,84}})));
equation
  connect(fixedHeatFlow.port, heatPortCon)
    annotation (Line(points={{76,0},{100,0},{100,38}}, color={191,0,0}));
  connect(fixedHeatFlow.port, heatPortRad)
    annotation (Line(points={{76,0},{100,0},{100,-38}}, color={191,0,0}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{36,74},{48,74},{48,100}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NoElectricalTransfer;
