within BESMod.Systems.Electrical.Transfer;
model NoElectricalTransfer "No transfer system"
  extends BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer;
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{16,64},{36,84}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlowCon[
    nParallelDem](each final Q_flow=0)
    annotation (Placement(transformation(extent={{52,28},{72,48}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlowRad[
    nParallelDem](each final Q_flow=0)
    annotation (Placement(transformation(extent={{42,-48},{62,-28}})));
equation
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{36,74},{48,74},{48,100}},
      color={0,0,0},
      thickness=1));
  connect(fixedHeatFlowCon.port, heatPortCon)
    annotation (Line(points={{72,38},{100,38}}, color={191,0,0}));
  connect(fixedHeatFlowRad.port, heatPortRad)
    annotation (Line(points={{62,-38},{100,-38}}, color={191,0,0}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NoElectricalTransfer;
