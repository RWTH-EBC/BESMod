within BESMod.Systems.UserProfiles.Tests;
model NoUserTest
  extends PartialTest(redeclare
      BESMod.Systems.RecordsCollection.ExampleSystemParameters systemParameters,
      redeclare BESMod.Systems.UserProfiles.NoUser userProfiles);
end NoUserTest;
