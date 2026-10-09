
within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse;
model SingleFamilyHouse_Spawn
  extends BESMod.Systems.Demand.Building.SpawnHighOrder(
    idf_name=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/Spawn/HighOrderArchetypeExample_SingleFamilyHouse.idf"),
    epw_name=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.epw"),
    wea_name=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.mos"),
    zoneNames={"Livingroom", "Hobby", "Corridor_gf", "WC_Storage", "Kitchen", "Bedroom", "Children1", "Corridor_upp", "Bath", "Children2", "Attic"},
    VZone={62.67502143048379, 35.1639344262295, 41.68321815179526, 35.1639344262295, 50.84715257802478, 54.976931284285854, 30.84490699026204, 36.563456505250635, 30.844906990262054, 44.60182620574316, 67.92761618518055},
    AZone={24.105777473262997, 13.524590163934423, 16.03200698145972, 13.524590163934423, 19.556597145394143, 24.105777473262997, 13.524590163934423, 16.03200698145972, 13.524590163934423, 19.556597145394143},
    hZone={2.6, 2.6, 2.599999999999999, 2.6, 2.6000000000000005, 2.2806537289769517, 2.2806537289769513, 2.2806537289769517, 2.280653728976952, 2.2806537289769517},
    ABui=228.25225906822791,
    hBui=6.440344170098539,
    ARoo=126.41892128152608,
    ventRateAttic=2.5,
    AirExchangeCorridor=2);

  annotation (Documentation(info="<html>
<p>
  The AixLib high order archetype SingleFamilyHouse as Spawn of EnergyPlus model,
  with the envelope TEASER wrote into Resources/Spawn/HighOrderArchetypeExample_SingleFamilyHouse.idf.
</p>
</html>"));
end SingleFamilyHouse_Spawn;
