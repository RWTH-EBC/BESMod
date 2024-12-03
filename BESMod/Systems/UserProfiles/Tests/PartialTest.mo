within BESMod.Systems.UserProfiles.Tests;
partial model PartialTest "Partial Test model"
  replaceable BaseClasses.PartialUserProfiles userProfiles constrainedby
    BaseClasses.PartialUserProfiles annotation (Placement(transformation(extent=
           {{-50,-54},{48,44}})), choicesAllMatching=true);
  annotation (experiment(
      StopTime=86400,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
  annotation (Documentation(info="<html>
<p>Partial test model for user profiles in building energy system simulations. 
The model contains a replaceable user profile component that must be constrained by 
<a href=\"modelica://BESMod.Systems.UserProfiles.BaseClasses.PartialUserProfiles\">BESMod.Systems.UserProfiles.BaseClasses.PartialUserProfiles</a>.
</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>userProfiles</code>: Replaceable component for user profiles with choices matching enabled</li>
</ul></html>"));
end PartialTest;
