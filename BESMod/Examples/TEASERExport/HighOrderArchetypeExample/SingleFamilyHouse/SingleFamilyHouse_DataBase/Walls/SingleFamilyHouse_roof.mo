

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_roof
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=3,
        d={0.18, 0.0125, 0.015},
        rho={160.0, 800.0, 1200.0},
        lambda={0.084, 0.25, 0.51},
        c={1358.0, 1000.0, 1000.0},
        eps=0.95);
end SingleFamilyHouse_roof;
