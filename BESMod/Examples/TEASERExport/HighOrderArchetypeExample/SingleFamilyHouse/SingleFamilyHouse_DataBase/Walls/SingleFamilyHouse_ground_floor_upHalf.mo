

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_ground_floor_upHalf
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=2,
        d={0.1, 0.02},
        rho={2300.0, 100.0},
        lambda={2.3, 0.05},
        c={1000.0, 1000.0},
        eps=0.95);
end SingleFamilyHouse_ground_floor_upHalf;
