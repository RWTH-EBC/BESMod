within BESMod.Systems.UserProfiles.Tests;
model TEASERProfileTest
  extends PartialTest(redeclare BESMod.Systems.UserProfiles.TEASERProfiles
      userProfiles);
  extends Modelica.Icons.Example;

  annotation (Documentation(info="<html>
<p>
Test model for the TEASER user profiles model used in building energy simulation. 
Uses <a href=\"modelica://BESMod.Systems.UserProfiles.TEASERProfiles\">BESMod.Systems.UserProfiles.TEASERProfiles</a> model for the user profiles.
</p>
</html>"));
end TEASERProfileTest;
