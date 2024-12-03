within BESMod.Systems.UserProfiles.Tests;
model Case600Profiles
  extends PartialTest(redeclare BESMod.Systems.UserProfiles.Case600Profiles
      userProfiles);
  extends Modelica.Icons.Example;
  annotation (Documentation(info="<html>
<p>Test model for Case 600 user profiles from ASHRAE 140.</p>
</html>"));
end Case600Profiles;
