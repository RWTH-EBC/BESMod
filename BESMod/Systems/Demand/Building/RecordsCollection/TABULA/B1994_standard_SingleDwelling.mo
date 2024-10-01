within BESMod.Systems.Demand.Building.RecordsCollection.TABULA;
record B1994_standard_SingleDwelling "B1994_standard_SingleDwelling"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 375.0,
    AZone = 150.0,
    hRad = 5.0,
    lat = 0.88645272708792,
    nOrientations = 4,
    AWin = {7.425000000000001, 7.425000000000001, 7.425000000000001, 7.425000000000001},
    ATransparent = {7.425000000000001, 7.425000000000001, 7.425000000000001, 7.425000000000001},
    hConWin = 2.6999999999999993,
    RWin = 0.004797979797979797,
    gWin = 0.75,
    UWin= 3.2013304230329487,
    ratioWinConRad = 0.02,
    AExt = {52.8375, 52.8375, 52.8375, 52.8375},
    hConExt = 2.7,
    nExt = 1,
    RExt = {0.001497265097748756},
    RExtRem = 0.007492562202937309,
    CExt = {8454199.790403917},
    AInt = 462.5,
    hConInt = 2.375675675675676,
    nInt = 1,
    RInt = {0.0001336340138456164},
    CInt = {51200270.26756811},
    AFloor = 75.3,
    hConFloor = 1.7,
    nFloor = 1,
    RFloor = {0.0016018787338735148},
    RFloorRem =  0.02105934528964327,
    CFloor = {8893608.444040682},
    ARoof = 123.19500000000001,
    hConRoof = 1.7,
    nRoof = 1,
    RRoof = {0.00044049701569530983},
    RRoofRem = 0.020868566404307207,
    CRoof = {2357184.0013066344},
    nOrientationsRoof = 2,
    tiltRoof = {0.6108652381980153, 0.6108652381980153},
    aziRoof = {3.141592653589793, -1.5707963267948966},
    wfRoof = {0.5, 0.5},
    aRoof = 0.5,
    aExt = 0.5,
    TSoil = 286.15,
    hConWallOut = 19.999999999999996,
    hRadWall = 4.999999999999999,
    hConWinOut = 20.0,
    hConRoofOut = 20.0,
    hRadRoof = 5.0,
    tiltExtWalls = {1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966},
    aziExtWalls = {0.0, 1.5707963267948966, -1.5707963267948966, 3.141592653589793},
    wfWall = {0.25, 0.25, 0.25, 0.25},
    wfWin = {0.25, 0.25, 0.25, 0.25},
    wfGro = 0.0,
    specificPeople = 0.02666666666666667,
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
    hHeat = 8829.775363719697,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = false,
    hCool = 0,
    lCool = -8829.775363719697,
    heaLoadFacOut = 267.05384435804797,
    heaLoadFacGrd = 40.57890632316592,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false,
    withIdealThresholds = false,
    TThresholdHeater = 288.15,
    TThresholdCooler = 295.15);
end B1994_standard_SingleDwelling;