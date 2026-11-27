

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_IW_vert_half
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=2,
        d={0.0575, 0.015},
        rho={1600.0, 1200.0},
        lambda={0.79, 0.51},
        c={1000.0, 1000.0},
        eps=0.95);
end SingleFamilyHouse_IW_vert_half;
