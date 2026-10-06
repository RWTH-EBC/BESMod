

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse;
model SingleFamilyHouse_HOM
  extends BESMod.Systems.Demand.Building.AixLibHighOrder(
    calcMethodOut=AixLib.ThermalZones.HighOrder.Components.Types.CalcMethodConvectiveHeatTransfer.ASHRAE_Fundamentals,
    calcMethodIn=AixLib.ThermalZones.HighOrder.Components.Types.CalcMethodConvectiveHeatTransferInsideSurface.Bernd_Glueck,
    TIR=4,
    fraRadIntGai=0.39754098360655743,
    redeclare replaceable parameter
      BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_wallTypes wallTypes,
    redeclare replaceable parameter
      BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.SingleFamilyHouse_SurfaceOrientation SOD,
    redeclare model WindowModel =
       AixLib.ThermalZones.HighOrder.Components.WindowsDoors.WindowSimple,
    redeclare replaceable parameter BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_windowSimple Type_Win,
    redeclare model CorrSolarGainWin =
       AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorG_VDI6007,
    redeclare BESMod.Systems.Demand.Building.Components.AixLibHighOrderOFD
      HOMBuiEnv(wholeHouseBuildingEnvelope(
        groundFloor_Building(
            WC_Storage(withDoor2=false),
            Corridor(withDoor1=false),
            room_width=4.008188340197077,
            room_height=2.6,
            length1=3.37424018434958,
            length2=2.494892742367569,
            length3=1.359921043995437,
            length4=3.37424018434958,
            thickness_IWsimple=0.145,
            windowarea_11=8.625196584790608,
            windowarea_12=1.7689198542196285,
            windowarea_22=2.1895871574188486,
            windowarea_41=1.43149583578467,
            windowarea_51=3.5354759895442425,
            windowarea_52=1.7689198542196285),
        upperFloor_Building(
            room_width_long=4.008188340197077,
            room_width_short=2.4081883401970767,
            room_height_long=2.6,
            room_height_short=1,
            roof_width=2.262741699796952,
            length5=3.37424018434958,
            length6=2.494892742367569,
            length7=1.359921043995437,
            length8=3.37424018434958,
            thickness_IWsimple=0.145,
            windowarea_62=1.7689198542196285,
            windowarea_63=1.8272657142723434,
            windowarea_72=1.7689198542196285,
            windowarea_73=1.8272657142723434,
            windowarea_92=1.7689198542196285,
            windowarea_102=1.7689198542196285,
            windowarea_103=1.8272657142723434),
        attic_2Ro_5Rooms(
            length=10.893294155062167,
            width=4.961376680394153,
            roof_width1=3.5082230947275077,
            roof_width2=3.5082230947275077,
            room1_length=6.014132926717148,
            room2_length=3.37424018434958,
            room3_length=3.999813786363006,
            room4_length=3.37424018434958,
            room5_length=4.8791612283450165,
            room1_width=2.4081883401970767,
            room2_width=2.4081883401970767,
            room3_width=2.4081883401970767,
            room4_width=2.4081883401970767,
            room5_width=2.4081883401970767,
            alfa=1.5707963267948966))
      )
  );
end SingleFamilyHouse_HOM;