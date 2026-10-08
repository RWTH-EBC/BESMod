within BESMod.Systems.UserProfiles.Tests;
model HOMUserTest "Test case for the HOM user profiles"
  extends PartialTest(redeclare
      BESMod.Systems.UserProfiles.AixLibHighOrderProfiles userProfiles(
        redeclare
        BESMod.Systems.UserProfiles.RecordsCollectionHOM.Ventilation.Const0_5
        venPro, redeclare
        BESMod.Systems.UserProfiles.RecordsCollectionHOM.SetTemperatures.Const20
        TSetProfile));
  extends Modelica.Icons.Example;

end HOMUserTest;
