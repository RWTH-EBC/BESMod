

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_IW_hori_loHalf
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=3,
        d={0.02, 0.16, 0.015},
        rho={120.0, 2300.0, 1200.0},
        lambda={0.055, 2.3, 0.51},
        c={1030.0, 1000.0, 1000.0},
        eps=0.95);
end SingleFamilyHouse_IW_hori_loHalf;
