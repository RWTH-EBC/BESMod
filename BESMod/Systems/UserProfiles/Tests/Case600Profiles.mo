within BESMod.Systems.UserProfiles.Tests;
model Case600Profiles
  extends PartialTest(redeclare BESMod.Systems.UserProfiles.Case600Profiles
      userProfiles(redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.ProfileS DHWProfile));
  extends Modelica.Icons.Example;

end Case600Profiles;
