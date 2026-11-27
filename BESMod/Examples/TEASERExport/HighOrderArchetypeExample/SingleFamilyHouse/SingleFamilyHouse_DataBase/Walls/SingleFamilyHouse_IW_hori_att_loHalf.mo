

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_IW_hori_att_loHalf
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=3,
        d={0.08, 0.0125, 0.015},
        rho={155.0, 800.0, 1200.0},
        lambda={0.09, 0.25, 0.51},
        c={1367.0, 1000.0, 1000.0},
        eps=0.95);
end SingleFamilyHouse_IW_hori_att_loHalf;
