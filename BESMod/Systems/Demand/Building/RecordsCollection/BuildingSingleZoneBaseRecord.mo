within BESMod.Systems.Demand.Building.RecordsCollection;
record BuildingSingleZoneBaseRecord
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    RExtRem=TotalRExt*FacRExtRem,
    RExt={TotalRExt*(1 - FacRExtRem)},
    RRoofRem=TotalRRoof*FacRRoofRem,
    RRoof={TotalRRoof*(1 - FacRRoofRem)},
    RFloorRem=TotalRFloor*FacRFloorRem,
    RFloor={TotalRFloor*(1 - FacRFloorRem)});

  parameter Modelica.Units.SI.ThermalResistance TotalRExt
    "Total Resistance of exterior walls" annotation(Evaluate=false);
  parameter Real FacRExtRem
  "Facotr of Resistance of remaining resistor RExtRem between capacity n and outside from total Resistance";
  parameter Modelica.Units.SI.ThermalResistance TotalRRoof
    "Total Resistance of exterior walls" annotation(Evaluate=false);
  parameter Real FacRRoofRem
  "Facotr of Resistance of remaining resistor RExtRem between capacity n and outside from total Resistance" annotation(Evaluate=false);
  parameter Modelica.Units.SI.ThermalResistance TotalRFloor
    "Total Resistance of exterior walls" annotation(Evaluate=false);
  parameter Real FacRFloorRem
  "Facotr of Resistance of remaining resistor RExtRem between capacity n and outside from total Resistance" annotation(Evaluate=false);
  parameter Integer nFloorLevels = 1;
  parameter Integer nRooms = 1;
  parameter Real roomVolumes[nRooms] = fill(0, nRooms);
  parameter Real RoofAreaAtticFactor = 1;
  parameter Real ratioExtWallAreaTopFloor = 1/nFloorLevels;
  parameter Real ratioExtWallAreaBottomFloor = 1/nFloorLevels;
  parameter Real ratioIntWallAreaTopFloor = 1/nFloorLevels;
  parameter Real ratioIntWallAreaBottomFloor = 1/nFloorLevels;
  parameter Real ratioWinAreaTopFloor = 1/nFloorLevels;
  parameter Real ratioWinAreaBottomFloor = 1/nFloorLevels;
  parameter Real ratioWinAreaExtWall = 1;
  parameter Real ratioWinAreaIntWall = 1;
  parameter Real FacATransparentPerRoom[nOrientations, nRooms] = fill({1}, nOrientations);
  parameter Real splitFactorSolRad[5,nOrientations] =  AixLib.ThermalZones.ReducedOrder.RC.BaseClasses.splitFacVal(
                            5, nOrientations, {sum(AExt),
        sum(AWin),AInt,AFloor,ARoof}, AExt, AWin);

end BuildingSingleZoneBaseRecord;
