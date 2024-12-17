within BESMod.Systems.Demand.Building.RecordsCollection.TABULA;
record B1980_standard_SingleDwelling "B1980_standard_SingleDwelling"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 540.0,
    AZone = 216.0,
    hRad = 5.0,
    lat = 0.88645272708792,
    nOrientations = 4,
    AWin = {6.75, 6.75, 6.75, 6.75},
    ATransparent = {6.75, 6.75, 6.75, 6.75},
    hConWin = 2.7,
    RWin = 0.0023169681309216186,
    gWin = 0.75,
    UWin= 4.3024026404355675,
    ratioWinConRad = 0.02,
    AExt = {39.852, 39.852, 39.852, 39.852},
    hConExt = 2.7,
    nExt = 1,
    RExt = {0.001147234213263944},
    RExtRem = 0.005800295751841475,
    CExt = {37750786.90675228},
    AInt = 666.0,
    hConInt = 2.375675675675676,
    nInt = 1,
    RInt = {9.415037126622853e-05},
    CInt = {73740928.1469676},
    AFloor = 83.376,
    hConFloor = 1.6999999999999997,
    nFloor = 1,
    RFloor = {0.0014271204611755917},
    RFloorRem =  0.014530113267316465,
    CFloor = {9868515.758808367},
    ARoof = 100.80072,
    hConRoof = 1.7,
    nRoof = 1,
    RRoof = {0.0004942489658718282},
    RRoofRem = 0.017450499220599124,
    CRoof = {1887336.2264171417},
    nOrientationsRoof = 2,
    tiltRoof = {0.6108652381980153, 0.6108652381980153},
    aziRoof = {3.141592653589793, -1.5707963267948966},
    wfRoof = {0.5, 0.5},
    aRoof = 0.5,
    aExt = 0.5,
    TSoil = 286.15,
    hConWallOut = 20.0,
    hRadWall = 5.0,
    hConWinOut = 20.0,
    hConRoofOut = 20.0,
    hRadRoof = 5.0,
    tiltExtWalls = {1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966},
    aziExtWalls = {0.0, 1.5707963267948966, -1.5707963267948966, 3.141592653589793},
    wfWall = {0.25, 0.25, 0.25, 0.25},
    wfWin = {0.25, 0.25, 0.25, 0.25},
    wfGro = 0.0,
    specificPeople = 0.018518518518518517,
    internalGainsMoistureNoPeople = 0.5,
    fixedHeatFlowRatePersons = 70,
    activityDegree = 1.2,
    ratioConvectiveHeatPeople = 0.5,
    internalGainsMachinesSpecific = 2.0,
    ratioConvectiveHeatMachines = 0.75,
    lightingPowerSpecific = 7.0,
    ratioConvectiveHeatLighting = 0.5,
    useConstantACHrate = false,
    baseACH = 0.2,
    maxUserACH = 1.0,
    maxOverheatingACH = {3.0, 2.0},
    maxSummerACH = {1.0, 283.15, 290.15},
    winterReduction = {0.2, 273.15, 283.15},
    maxIrr = {100.0, 100.0, 100.0, 100.0},
    shadingFactor = {1.0, 1.0, 1.0, 1.0},
    withAHU = false,
    minAHU = 0.3,
    maxAHU = 0.6,
    hHeat = 10921.87830543977,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = false,
    hCool = 0,
    lCool = -10921.87830543977,
    heaLoadFacOut = 328.9829215012314 + (VAir*(0.5 - baseACH)/3600*1014.54*1.2),
    heaLoadFacGrd = 56.34640248576658,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false,
    withIdealThresholds = false,
    TThresholdHeater = 288.15,
    TThresholdCooler = 295.15);
end B1980_standard_SingleDwelling;
