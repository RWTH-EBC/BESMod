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
end MyOwnSystem;
