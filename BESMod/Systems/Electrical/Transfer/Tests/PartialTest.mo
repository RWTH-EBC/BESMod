within BESMod.Systems.Electrical.Transfer.Tests;
partial model PartialTest
  replaceable
  BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer
    transfer constrainedby BaseClasses.PartialTransfer(nParallelDem=1,
      Q_flow_nominal={1000})
    annotation (Placement(transformation(extent={{-44,-32},{48,52}})),
      choicesAllMatching=true);
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureRad[transfer.nParallelDem](
     each T=293.15)
    annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureCon[transfer.nParallelDem](
     each T=293.15)
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
equation
  connect(fixedTemperatureRad.port, transfer.heatPortRad) annotation (Line(
        points={{80,-10},{58,-10},{58,6.64},{48,6.64}}, color={191,0,0}));
  connect(fixedTemperatureCon.port, transfer.heatPortCon) annotation (Line(
        points={{80,30},{58,30},{58,26.8},{48,26.8}}, color={191,0,0}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>This model represents a partial test model for electrical transfer systems. 
It contains a replaceable transfer component that is constrained by 
<a href=\"modelica://BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer\">BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer</a>.</p>

<p>The model includes fixed temperature boundary conditions for radiative and convective 
heat ports connected to the transfer component.</p>
</html>"));
end PartialTest;
