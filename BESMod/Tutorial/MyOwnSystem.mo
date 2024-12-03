within BESMod.Tutorial;
model MyOwnSystem
  extends BESMod.Tutorial.BaseClasses.PartialSystem(
    yMax=5,
    redeclare BESMod.Tutorial.MyOwnModule moduleWrong(
      yMax=yMax,
      use_lim=true,
      redeclare BESMod.Tutorial.RecordsCollection.DefaultSineWave myComponentParameters),
    redeclare BESMod.Tutorial.MyOwnModule module(
      use_lim=true,
      redeclare BESMod.Tutorial.RecordsCollection.DefaultSineWave myComponentParameters));
  extends Modelica.Icons.Example;
  annotation (experiment(StopTime=10, __Dymola_Algorithm="Dassl"));
  annotation (Documentation(info="<html>
<p>
This model extends <a href=\"modelica://BESMod.Tutorial.BaseClasses.PartialSystem\">BESMod.Tutorial.BaseClasses.PartialSystem</a> 
and consists of two instances of <a href=\"modelica://BESMod.Tutorial.MyOwnModule\">BESMod.Tutorial.MyOwnModule</a>.
The model uses <a href=\"modelica://BESMod.Tutorial.RecordsCollection.DefaultSineWave\">DefaultSineWave</a> parameters for both module instances.
It serves as an example model.
</p>

<h4>Important Parameters</h4>
<ul>
  <li>yMax: Upper limit value set to 5 for the system and moduleWrong instance</li>
  <li>use_lim: Limitation is enabled for both module instances</li>
</ul></html>"));
end MyOwnSystem;
