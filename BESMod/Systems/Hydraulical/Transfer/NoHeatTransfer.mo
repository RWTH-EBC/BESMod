within BESMod.Systems.Hydraulical.Transfer;
model NoHeatTransfer "No heat tranfser to building"
  extends BaseClasses.PartialTransfer(
    dp_nominal=fill(0, nParallelDem),
    dTTra_nominal=fill(0, nParallelDem));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow[
    nParallelDem](each final Q_flow=0)
    annotation (Placement(transformation(extent={{54,-10},{74,10}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
equation
  connect(portTra_in, portTra_out) annotation (Line(points={{-100,38},{-74,38},
          {-74,-42},{-100,-42}}, color={0,127,255}));
  connect(fixedHeatFlow.port, heatPortCon)
    annotation (Line(points={{74,0},{100,0},{100,40}}, color={191,0,0}));
  connect(fixedHeatFlow.port, heatPortRad)
    annotation (Line(points={{74,0},{100,0},{100,-40}}, color={191,0,0}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{60,-70},{72,-70},{72,-98}},
      color={0,0,0},
      thickness=1));
  annotation (Documentation(info="<html>
<p>This class is meant to be used, when the building should not be supplied with heat.</p>
</html>"));
end NoHeatTransfer;
