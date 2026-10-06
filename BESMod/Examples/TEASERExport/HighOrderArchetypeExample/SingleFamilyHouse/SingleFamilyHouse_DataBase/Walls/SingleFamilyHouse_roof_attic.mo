

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_roof_attic
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=3,
        d={0.00731, 0.0005, 0.018},
        rho={500.0, 700.0, 400.0},
        lambda={0.75, 0.5, 0.09},
        c={840.0, 1000.0, 1500.0},
        eps=0.95);
end SingleFamilyHouse_roof_attic;
