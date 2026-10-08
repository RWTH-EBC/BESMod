

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_wallTypes
    extends AixLib.DataBase.Walls.Collections.OFD.BaseDataMultiInnerWalls(
        OW=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_OW(),
        IW_vert_half_a=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_IW_vert_half(),
        IW_vert_half_b=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_IW_vert_half(),
        IW_hori_upp_half=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_IW_hori_upHalf(),
        IW_hori_low_half=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_IW_hori_loHalf(),
        IW_hori_att_upp_half=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_IW_hori_att_upHalf(),
        IW_hori_att_low_half=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_IW_hori_att_loHalf(),
        groundPlate_upp_half=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_ground_floor_upHalf(),
        groundPlate_low_half=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_ground_floor_loHalf(),
        IW2_vert_half_a=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_IW2_vert_half(),
        IW2_vert_half_b=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_IW2_vert_half(),
        roof=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_roof_attic(),
        roofRoomUpFloor=BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls.SingleFamilyHouse_roof());
end SingleFamilyHouse_wallTypes;
