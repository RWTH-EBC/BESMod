within BESMod.Systems.UserProfiles.Tests;
model HOMUserTest "Test case for the HOM user profiles"
  extends PartialTest(redeclare
      BESMod.Systems.UserProfiles.AixLibHighOrderProfiles userProfiles(
        redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
        redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile));
  extends Modelica.Icons.Example;

end HOMUserTest;
