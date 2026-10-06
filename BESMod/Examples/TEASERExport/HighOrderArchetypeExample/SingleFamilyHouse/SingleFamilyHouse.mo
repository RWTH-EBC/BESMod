
within BESMod.Examples.TEASERExport.HighOrderArchetypeExample.SingleFamilyHouse;
model SingleFamilyHouse
  extends BESMod.Systems.Demand.Building.TEASERThermalSingleZone(
    zoneParam = {
      SingleFamilyHouse_DataBase.SingleFamilyHouse_single_zone_heated()
      },
      hBui=5.2,
      ABui=86.74356192798571,
      ARoo=172.03676007302482,
      nZones=1);

end SingleFamilyHouse;
