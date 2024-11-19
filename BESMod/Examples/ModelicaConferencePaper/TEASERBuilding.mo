within BESMod.Examples.ModelicaConferencePaper;
model TEASERBuilding
  extends PartialModelicaConferenceUseCase(
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      AZone={185.9548},
      hZone={483.48248/185.9548},
      ABui=sum(building.zoneParam.VAir)^(2/3),
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ARoo=building.oneZoneParam.ARoof, redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam, use_verboseEnergyBalance=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles
      userProfiles,
    systemParameters(use_hydraulic=true, use_ventilation=true));
  extends Modelica.Icons.Example;


annotation(experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/ModelicaConferencePaper/TEASERBuilding.mos"
        "Simulate and plot"), Documentation(info="<html>
<h4>Information</h4>
<p>
This model represents a TEASER building model example. It uses a single thermal zone configuration with parameters based on a reference building in Aachen.
</p>
<h4>Model Components</h4>
<ul>
  <li>Building: <a href=\"modelica://BESMod.Systems.Demand.Building.TEASERThermalZone\">TEASERThermalZone</a></li>
  <li>User Profiles: <a href=\"modelica://BESMod.Systems.UserProfiles.TEASERProfiles\">TEASERProfiles</a></li>
  <li>Building Parameters: <a href=\"modelica://BESMod.Systems.Demand.Building.RecordsCollection.RefAachen\">RefAachen</a></li>
</ul>
</html>"));
end TEASERBuilding;
