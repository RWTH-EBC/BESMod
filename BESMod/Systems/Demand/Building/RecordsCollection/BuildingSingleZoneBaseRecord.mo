within BESMod.Systems.Demand.Building.RecordsCollection;
record BuildingSingleZoneBaseRecord
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord;

  parameter Integer nFloorLevels = 1;
  parameter Real RoofAreaAtticFactor = 1;
  parameter Real ratioExtWallAreaTopFloor = 1/nFloorLevels;
  parameter Real ratioExtWallAreaBottomFloor = 1/nFloorLevels;
  parameter Real ratioIntWallAreaTopFloor = 1/nFloorLevels;
  parameter Real ratioIntWallAreaBottomFloor = 1/nFloorLevels;
  parameter Real ratioWinAreaTopFloor = 1/nFloorLevels;
  parameter Real ratioWinAreaBottomFloor = 1/nFloorLevels;
  parameter Real ratioWinAreaExtWall = 1;
  parameter Real ratioWinAreaIntWall = 1;

end BuildingSingleZoneBaseRecord;
