within BESMod.Examples.UFHSystems;
model test_old_ufh
  extends PartialConstSupplyUFH(hydraulic(redeclare
        BESMod.Systems.Hydraulical.Transfer.UFHTransferSystem transfer(
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData
          UFHParameters)));
  annotation (experiment(
      StopTime=10000000,
      Interval=900,
      __Dymola_Algorithm="Dassl"));
end test_old_ufh;
