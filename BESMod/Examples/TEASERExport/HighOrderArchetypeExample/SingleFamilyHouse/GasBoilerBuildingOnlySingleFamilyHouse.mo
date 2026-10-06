
within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse;
model GasBoilerBuildingOnlySingleFamilyHouse
  extends BESMod.Systems.BaseClasses.TEASERExport.PartialGasBoilerBuildingOnly(
    redeclare SingleFamilyHouse building(
        use_absIntGai=true,
        useUserProfileNatVent=true),
    redeclare BESMod.Systems.UserProfiles.TEASERHOMtoROM userProfiles(
        facRoomTSet={0.17468698380704986, 0.08322671120658269, 0.0555587873130947, 0.07245165902327433, 0.12493180878483798, 0.13052820963564465, 0.09265523279554892, 0.04562006976532737, 0.1156892860223285, 0.10465125164631094},
        facRoomNatVent={0.1480400568034674, 0.08305814232016348, 0.09845686275173347, 0.08305814232016348, 0.12010231802304878, 0.12985696445645678, 0.07285648538629966, 0.08636385045312032, 0.07285648538629966, 0.10535069209924688},
        fac_conv=0.6024590163934426,
        fileNameIntGains=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/InternalGainsHighOrderArchetypeExample.txt"),
        gain=1,
        redeclare BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.SingleFamilyHouse_TSetProfile TSetProfile),
    hydraulic(control(use_TZoneSetHeaCur=true)),
    systemParameters(nZones=1,
                     TSetZone_nominal={293.6127571440893},
                     QBui_flow_nominal={9299.611700485448},
                     TOda_nominal=260.54999999999995,
                     THydSup_nominal=fill(328.15,systemParameters.nZones),
                     QBuiOld_flow_design=systemParameters.QBui_flow_nominal,
                     THydSupOld_design=systemParameters.THydSup_nominal));

  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file=
        "modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERExport/HighOrderArchetypeExample/SingleFamilyHouse/GasBoilerBuildingOnlySingleFamilyHouse.mos"
        "Simulate and plot"));

end GasBoilerBuildingOnlySingleFamilyHouse;