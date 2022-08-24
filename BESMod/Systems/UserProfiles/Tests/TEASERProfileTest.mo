within BESMod.Systems.UserProfiles.Tests;
model TEASERProfileTest
  extends PartialTest(redeclare BESMod.Systems.UserProfiles.TEASERProfiles
      userProfiles(redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile));
  extends Modelica.Icons.Example;

end TEASERProfileTest;
