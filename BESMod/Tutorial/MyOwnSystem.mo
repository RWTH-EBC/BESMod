within BESMod.Tutorial;
model MyOwnSystem
  extends BESMod.Tutorial.BaseClasses.PartialSystem(y_max=5, redeclare
      BESMod.Tutorial.MyOwnModule module(use_lim=true, redeclare
        BESMod.Tutorial.RecordsCollection.DefaultSineWave myComponentParameters));
end MyOwnSystem;
