within BESMod.Examples.ModelicaConferencePaper;
model BuildingsLibraryRoom "System using the buildings libraries room model"
  extends PartialModelicaConferenceUseCase(
    redeclare
      BESMod.Systems.Demand.Building.BuildingsRoomCase600FF
      building(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.UserProfiles.Case600Profiles
      userProfiles,
    systemParameters(QBui_flow_nominal={2504}));
  extends Modelica.Icons.Example;

annotation(experiment(
      StopTime=864000,
      Interval=600,
   Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/ModelicaConferencePaper/BuildingsLibraryRoom.mos"
        "Simulate and plot"));
end BuildingsLibraryRoom;
