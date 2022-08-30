within BESMod.Systems.Hydraulical.Distribution.Tests;
model TestSimpleStorages
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
      distribution(redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
        bufParameters(dTLoadingHC1=5), redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
        dhwParameters(dTLoadingHC1=5)));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=100) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,88})));
equation
  connect(booleanPulse.y, sigBusDistr.dhw_on) annotation (Line(points={{-57,88},
          {-42,88},{-42,81},{-14,81}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TestSimpleStorages;
