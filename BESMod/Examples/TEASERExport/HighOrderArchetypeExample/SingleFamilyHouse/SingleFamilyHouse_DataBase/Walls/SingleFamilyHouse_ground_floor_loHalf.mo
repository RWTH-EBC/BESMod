

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_ground_floor_loHalf
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=3,
        d={0.15, 0.04, 0.06},
        rho={2300.0, 120.0, 2000.0},
        lambda={2.3, 0.055, 1.4},
        c={1000.0, 1030.0, 1000.0},
        eps=0.95);
end SingleFamilyHouse_ground_floor_loHalf;
