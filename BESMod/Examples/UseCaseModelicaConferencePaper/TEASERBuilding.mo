within BESMod.Examples.UseCaseModelicaConferencePaper;
model TEASERBuilding
  extends PartialModelicaConferenceUseCase(
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      AZone={185.9548},
      hZone={483.48248/185.9548},                                                                       redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam, use_verboseEnergyBalance=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=293.15),
    scalingFactorHP=2.39038,
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles
      userProfiles);
  annotation (experiment(
      StopTime=1728000,
      Interval=600.0012,
      __Dymola_Algorithm="Dassl"));
end TEASERBuilding;
