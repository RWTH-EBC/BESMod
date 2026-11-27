
within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse;
model HeatPumpMonoenergeticSingleFamilyHouse
  extends BESMod.Systems.BaseClasses.TEASERExport.PartialHeatPumpMonoenergetic(
    redeclare SingleFamilyHouse building(
        use_absIntGai=true,
        useUserProfileNatVent=true),
    redeclare BESMod.Systems.UserProfiles.TEASERHOMtoROM userProfiles(
        facRoomTSet={0.1480400568034674, 0.08305814232016348, 0.09845686275173347, 0.08305814232016348, 0.12010231802304878, 0.12985696445645678, 0.07285648538629966, 0.08636385045312032, 0.07285648538629966, 0.10535069209924688},
        facRoomNatVent={0.1480400568034674, 0.08305814232016348, 0.09845686275173347, 0.08305814232016348, 0.12010231802304878, 0.12985696445645678, 0.07285648538629966, 0.08636385045312032, 0.07285648538629966, 0.10535069209924688},
        fac_conv=0.6024590163934426,
        fileNameIntGains=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/InternalGainsHighOrderArchetypeExample.txt"),
        gain=1,
        redeclare BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.SingleFamilyHouse_TSetProfile TSetProfile),
    hydraulic(control(use_TZoneSetHeaCur=true)),
    systemParameters(
        nZones=1,
        TSetZone_nominal={293.44142594154516},
        QBui_flow_nominal={9299.611700485448},
        TOda_nominal=260.54999999999995,
        THydSup_nominal=fill(328.15,systemParameters.nZones),
        QBuiOld_flow_design=systemParameters.QBui_flow_nominal,
        THydSupOld_design=systemParameters.THydSup_nominal));

  extends Modelica.Icons.Example;

annotation(experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file=
        "modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERExport/HighOrderArchetypeExample/SingleFamilyHouse/HeatPumpMonoenergeticSingleFamilyHouse.mos"
        "Simulate and plot"));
end HeatPumpMonoenergeticSingleFamilyHouse;