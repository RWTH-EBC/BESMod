

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_OW
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=4,
        d={0.05, 0.06, 0.175, 0.015},
        rho={1800.0, 120.0, 1600.0, 1200.0},
        lambda={1.0, 0.05, 0.79, 0.51},
        c={1000.0, 1030.0, 1000.0, 1000.0},
        eps=0.95);
end SingleFamilyHouse_OW;
