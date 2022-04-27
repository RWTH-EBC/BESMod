within BESMod.Examples.UseCaseModelicaConferencePaper;
model BuildingsLibraryRoom "System using the buildings libraries room model"
  extends PartialModelicaConferenceUseCase(
    redeclare
      BESMod.Systems.Demand.Building.BuildingsRoomCase600FF
      building(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.UserProfiles.Case600Profiles
      userProfiles,
    systemParameters(QBui_flow_nominal={2504}));
end BuildingsLibraryRoom;
