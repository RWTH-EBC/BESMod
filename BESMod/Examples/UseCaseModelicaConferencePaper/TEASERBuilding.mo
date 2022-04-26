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
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[1](T=
        293.15)
    annotation (Placement(transformation(extent={{-26,-110},{-38,-98}})));
equation
  connect(fixedTemperature.port, electricalSystem.heatPortRad) annotation (Line(
        points={{-38,-104},{-44,-104},{-44,-86.8571},{-51.2235,-86.8571}},
        color={191,0,0}));
  annotation (experiment(
      StopTime=172800,
      Interval=600.0012,
      __Dymola_Algorithm="Dassl"));
end TEASERBuilding;
