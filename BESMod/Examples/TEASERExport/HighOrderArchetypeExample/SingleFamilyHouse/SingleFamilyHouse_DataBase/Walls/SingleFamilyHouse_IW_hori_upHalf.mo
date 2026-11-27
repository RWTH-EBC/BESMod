

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_IW_hori_upHalf
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=2,
        d={0.02, 0.06},
        rho={120.0, 2000.0},
        lambda={0.055, 1.4},
        c={1030.0, 1000.0},
        eps=0.95);
end SingleFamilyHouse_IW_hori_upHalf;
