within BESMod.Examples.ModelicaConferencePaper;
model TEASERBuilding
  extends PartialModelicaConferenceUseCase(
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      AZone={185.9548},
      hZone={483.48248/185.9548},
      ABui=sum(building.zoneParam.VAir)^(2/3),
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ARoo=building.oneZoneParam.ARoof,                                                                 redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0),
                      use_verboseEnergyBalance=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles
      userProfiles,
    systemParameters(use_hydraulic=true, use_ventilation=true));
  extends Modelica.Icons.Example;
initial equation
  building.thermalZone[1].ROM.extWallRC.thermCapExt[1].T = 293.15;
  building.thermalZone[1].ROM.floorRC.thermCapExt[1].T = 293.15;
  building.thermalZone[1].ROM.intWallRC.thermCapInt[1].T = 293.15;
  building.thermalZone[1].ROM.roofRC.thermCapExt[1].T = 293.15;


annotation(experiment(
      StopTime=864000,
      Interval=600,
   Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/ModelicaConferencePaper/TEASERBuilding.mos"
        "Simulate and plot"));
end TEASERBuilding;
