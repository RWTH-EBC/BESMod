within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestPressureBasedSystem
  extends BESMod.Systems.Hydraulical.Transfer.Tests.PartialTest(
      redeclare
      BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
      transfer(
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
        parTra,
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
        parRad), pumDis(each ctrlType=AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar));
  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=3600, __Dymola_Algorithm="Dassl"));
end TestPressureBasedSystem;
