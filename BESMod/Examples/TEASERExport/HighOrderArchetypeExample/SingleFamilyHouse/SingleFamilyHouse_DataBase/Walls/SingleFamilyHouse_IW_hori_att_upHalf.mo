

within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase.Walls;
record SingleFamilyHouse_IW_hori_att_upHalf
    extends AixLib.DataBase.Walls.WallBaseDataDefinition(
        n=2,
        d={0.08, 0.02},
        rho={156.0, 900.0},
        lambda={0.09, 0.18},
        c={1366.0, 1700.0},
        eps=0.95);
end SingleFamilyHouse_IW_hori_att_upHalf;
