
within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse;
model HeatPumpMonoenergeticSingleFamilyHouse_HOM
  extends BESMod.Systems.BaseClasses.TEASERExport.PartialHeatPumpMonoenergeticHOM(
    redeclare SingleFamilyHouse_HOM building,
    userProfiles(
        fileNameIntGains=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/InternalGainsHighOrderArchetypeExample.txt"),
        gain=1,
        redeclare BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.SingleFamilyHouse_TSetProfile TSetProfile),
    systemParameters(
        nZones=10,
        QBui_flow_nominal={1624.521118534553, 773.9760973296598, 516.6751485616379, 673.772295972424, 1161.81731073829, 1213.8616655710584, 861.6576870166897, 424.24893456660084, 1075.8654379140537, 973.2160042804801},
        TSetZone_nominal={293.15, 293.15, 293.15, 293.15, 293.15, 293.15, 293.15, 293.15, 297.15, 293.15},
        TOda_nominal=260.54999999999995,
        THydSup_nominal=fill(328.15,systemParameters.nZones),
        QBuiOld_flow_design=systemParameters.QBui_flow_nominal,
        THydSupOld_design=systemParameters.THydSup_nominal));

  extends Modelica.Icons.Example;

annotation(experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file=
        "modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERExport/HighOrderArchetypeExample/SingleFamilyHouse/HeatPumpMonoenergeticSingleFamilyHouse_HOM.mos"
        "Simulate and plot"));
end HeatPumpMonoenergeticSingleFamilyHouse_HOM;