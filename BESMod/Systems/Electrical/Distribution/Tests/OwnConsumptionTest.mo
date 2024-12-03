within BESMod.Systems.Electrical.Distribution.Tests;
model OwnConsumptionTest
  extends PartialTest(redeclare
      BESMod.Systems.Electrical.Distribution.OwnConsumption dis);

  extends Modelica.Icons.Example;
  Modelica.Blocks.Interfaces.RealOutput SOC if not dis.use_openModelica
    annotation (Placement(transformation(extent={{100,-96},{120,-76}})));
equation

  connect(SOC, outputsDis.SOCBat) annotation (Line(points={{110,-86},{4,-86},{4,
          -74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>Test model for <a href=\"modelica://BESMod.Systems.Electrical.Distribution.OwnConsumption\">BESMod.Systems.Electrical.Distribution.OwnConsumption</a> electrical distribution system.</p>
</html>"));
end OwnConsumptionTest;
