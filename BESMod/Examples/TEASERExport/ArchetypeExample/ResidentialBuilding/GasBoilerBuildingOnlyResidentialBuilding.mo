within BESMod.Examples.TEASERExport.ArchetypeExample.ResidentialBuilding;
model GasBoilerBuildingOnlyResidentialBuilding
  extends BESMod.Systems.BaseClasses.TEASERExport.PartialGasBoilerBuildingOnly(
    redeclare ResidentialBuilding building,
    userProfiles(
        setBakTSetZone(
            amplitude={0},
            width={1e-50},
            startTime={0})),
    systemParameters(nZones=1,
                     TSetZone_nominal={294.15},
                     TOda_nominal=262.65,
                     THydSup_nominal=fill(328.15,systemParameters.nZones),
                     QBuiOld_flow_design=systemParameters.QBui_flow_nominal,
                     THydSupOld_design=systemParameters.THydSup_nominal));

  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file=
        "modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERExport/ArchetypeExample/ResidentialBuilding/GasBoilerBuildingOnlyResidentialBuilding.mos"
        "Simulate and plot"));

end GasBoilerBuildingOnlyResidentialBuilding;
