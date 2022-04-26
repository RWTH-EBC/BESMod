within BESMod.Examples.UseCaseModelicaConferencePaper;
model TEASERBuilding
  extends PartialModelicaConferenceUseCase(
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      AZone={185.9548},
      hZone={483.48248/185.9548},                                                                       redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam, use_verboseEnergyBalance=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles
      userProfiles,
    systemParameters(use_hydraulic=true, use_ventilation=true));
initial equation
  building.thermalZone[1].ROM.extWallRC.thermCapExt[1].T = 293.15;
  building.thermalZone[1].ROM.floorRC.thermCapExt[1].T = 293.15;
  building.thermalZone[1].ROM.intWallRC.thermCapInt[1].T = 293.15;
  building.thermalZone[1].ROM.roofRC.thermCapExt[1].T = 293.15;

end TEASERBuilding;
