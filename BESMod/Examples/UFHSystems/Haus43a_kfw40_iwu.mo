within BESMod.Examples.UFHSystems;
model Haus43a_kfw40_iwu
  extends BESMod.Systems.Demand.Building.TEASERThermalZone(
    zoneParam={
        BESMod.Examples.UFHSystems.Haus43a_kfw40_iwu_DataBase.Haus43a_kfw40_iwu_SingleDwelling()},
    hBui=5.4,
    ABui=94.8955,
    ARoo=94.8955,
    nZones=1);

end Haus43a_kfw40_iwu;
