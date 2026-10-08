
within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse.SingleFamilyHouse_DataBase;
record SingleFamilyHouse_SurfaceOrientation
    "Surfaces the building envelope is irradiated on, rotated by 0.0 deg against the AixLib HOM's own orientation"
    extends AixLib.DataBase.Weather.SurfaceOrientation.SurfaceOrientationBaseDataDefinition(
        nSurfaces=6,
        name={"N","O","S","W","Roof_N","Roof_S"},
        Azimut={180.0, -90.0, 0.0, 90.0, 180.0, 0.0},
        Tilt={90.0, 90.0, 90.0, 90.0, 45.0, 45.0});
end SingleFamilyHouse_SurfaceOrientation;
