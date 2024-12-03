within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestIndirectLoading
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedIndirectLoading
      distribution(
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare
        BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayVal,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        parStoBuf,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        parStoDHW,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
        parEleHeaAftBuf,
      dTLoaHCBuf=10,
      QHeaAftBuf_flow_nominal=
                             0));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse        pulse(       period=100) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,90})));
equation
  connect(pulse.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-59,90},{
          -44,90},{-44,81},{-14,81}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Test model for an indirect loading distribution system with two 
detailed storage tanks (buffer and DHW). 
This model tests <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedIndirectLoading\">BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedIndirectLoading</a> distribution system.</p>
<p>The model includes a pulse generator with period=100 that controls the 
three-way valve position through the signal bus.</p>
</html>"));
end TestIndirectLoading;
