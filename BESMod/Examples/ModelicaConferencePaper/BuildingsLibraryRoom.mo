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

annotation(experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/ModelicaConferencePaper/BuildingsLibraryRoom.mos"
        "Simulate and plot"),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/ModelicaConferencePaper/BuildingsLibraryRoom.mos"
        "Simulate and plot"));
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>System model extending from <a href=\"modelica://BESMod.Examples.ModelicaConferencePaper.PartialModelicaConferenceUseCase\">PartialModelicaConferenceUseCase</a> using the Buildings library's room model. The model demonstrates the use case of a single zone building simulation based on the BESTEST Case 600 setup.</p>

<h4>Important Parameters</h4>
<ul>
  <li>Building model: <a href=\"modelica://BESMod.Systems.Demand.Building.BuildingsRoomCase600FF\">BESMod.Systems.Demand.Building.BuildingsRoomCase600FF</a> with fixed initial energy dynamics</li>
  <li>User profiles: <a href=\"modelica://BESMod.Systems.UserProfiles.Case600Profiles\">BESMod.Systems.UserProfiles.Case600Profiles</a></li>
  <li>Nominal building heat flow: 2504 W</li>
</ul>
</html>"));
end BuildingsLibraryRoom;
