within BESMod.Examples.TEASERExport.ArchetypeExample.ResidentialBuilding;
model HeatPumpMonoenergeticResidentialBuilding
  extends BESMod.Systems.BaseClasses.TEASERExport.PartialHeatPumpMonoenergetic(
    redeclare ResidentialBuilding building(
      use_verboseEnergyBalance=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    userProfiles(
      dTSetBack=0,
      startTimeSetBack=0,
      hoursSetBack=0),
    systemParameters(
        nZones=1,
        TSetZone_nominal={294.15},
        TOda_nominal=262.65,
        THydSup_nominal=fill(328.15,systemParameters.nZones),
        QBuiOld_flow_design=systemParameters.QBui_flow_nominal,
        THydSupOld_design=systemParameters.THydSup_nominal));

  extends Modelica.Icons.Example;

annotation(experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file=
        "modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERExport/ArchetypeExample/ResidentialBuilding/HeatPumpMonoenergeticResidentialBuilding.mos"
        "Simulate and plot"));
end HeatPumpMonoenergeticResidentialBuilding;
