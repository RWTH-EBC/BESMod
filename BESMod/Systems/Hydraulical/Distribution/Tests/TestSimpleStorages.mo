within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestSimpleStorages
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
      distribution(redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
        parStoBuf(dTLoadingHC1=5), redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
        parStoDHW(dTLoadingHC1=5),
      redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayVal));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse        pulse(       period=100) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,88})));
equation
  connect(pulse.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-57,88},{
          -42,88},{-42,81},{-14,81}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TestSimpleStorages;
