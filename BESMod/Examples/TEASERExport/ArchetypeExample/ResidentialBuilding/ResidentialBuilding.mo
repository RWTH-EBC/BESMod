within BESMod.Examples.TEASERExport.ArchetypeExample.ResidentialBuilding;
model ResidentialBuilding
  extends BESMod.Systems.Demand.Building.TEASERThermalZone(
    zoneParam = {
      ResidentialBuilding_DataBase.ResidentialBuilding_SingleDwelling()},
      hBui=6.4,
      ABui=133.0,
      ARoo=133.0,
      nZones=1);

end ResidentialBuilding;
