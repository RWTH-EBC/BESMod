within BESMod.Systems.Demand.Building.RecordsCollection.TABULA;
record B1918_retrofit_SingleDwelling "B1918_retrofit_SingleDwelling"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 355.0,
    AZone = 142.0,
    hRad = 5.000000000000001,
    lat = 0.88645272708792,
    nOrientations = 4,
    AWin = {5.5735, 5.5735, 5.5735, 5.5735},
    ATransparent = {5.5735, 5.5735, 5.5735, 5.5735},
    hConWin = 2.6999999999999997,
    RWin = 0.020409078675876918,
    gWin = 0.6,
    UWin= 1.6003325366309882,
    ratioWinConRad = 0.02,
    AExt = {48.493, 48.493, 48.493, 48.493},
    hConExt = 2.7,
    nExt = 1,
    RExt = {0.0006591106624035085},
    RExtRem = 0.019883527717914743,
    CExt = {102104099.23731989},
    AInt = 437.83333333333337,
    hConInt = 2.3756756756756756,
    nInt = 1,
    RInt = {0.0001560317933342658},
    CInt = {67434090.99055417},
    AFloor = 78.2988,
    hConFloor = 1.7,
    nFloor = 1,
    RFloor = {0.0016813102894708031},
    RFloorRem =  0.03579503004392397,
    CFloor = {3283483.922631063},
    ARoof = 83.07,
    hConRoof = 1.7,
    nRoof = 1,
    RRoof = {0.0006532686872346659},
    RRoofRem = 0.030948634142032343,
    CRoof = {1589441.7386139221},
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
    specificPeople = 0.028169014084507043,
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
    hHeat = 4548.435437436546,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = false,
    hCool = 0,
    lCool = -4548.435437436546,
    heaLoadFacOut = 136.58457074115967 + (VAir*(0.5 - baseACH)/3600*1014.54*1.2),
    heaLoadFacGrd = 25.389881959919506,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false,
    withIdealThresholds = false,
    TThresholdHeater = 288.15,
    TThresholdCooler = 295.15);
end B1918_retrofit_SingleDwelling;
