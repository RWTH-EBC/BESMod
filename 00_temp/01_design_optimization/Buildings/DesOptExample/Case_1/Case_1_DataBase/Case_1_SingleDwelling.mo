

within DesOptExample.Case_1.Case_1_DataBase;
record Case_1_SingleDwelling "Case_1_SingleDwelling"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 349.15,
    AZone = 139.66,
    hRad = 4.999999999999999,
    lat = 0.88645272708792,
    nOrientations = 4,
    AWin = {5.481655, 5.481655, 5.481655, 5.481655},
    ATransparent = {5.481655, 5.481655, 5.481655, 5.481655},
    hConWin = 2.7000000000000006,
    RWin = 0.020751032306848938,
    gWin = 0.6,
    UWin= 1.6003325366309886,
    ratioWinConRad = 0.02,
    AExt = {47.69389, 47.69389, 47.69389, 47.69389},
    hConExt = 2.7000000000000006,
    nExt = 1,
    RExt = {0.0006701540459780769},
    RExtRem = 0.020216675755004247 ,
    CExt = {100421538.72876121},
    AInt = 430.6183333333333,
    hConInt = 2.375675675675676,
    nInt = 1,
    RInt = {0.0001586461023447354},
    CInt = {66322853.153104216},
    AFloor = 77.008524,
    hConFloor = 1.7,
    nFloor = 1,
    RFloor = {0.0017094806036435201},
    RFloorRem =  0.03639477492651585,
    CFloor = {3229375.8072862974},
    ARoof = 81.7011,
    hConRoof = 1.7,
    nRoof = 1,
    RRoof = {0.0006642141886533192},
    RRoofRem = 0.031467177775802616,
    CRoof = {1563249.529681784},
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
    specificPeople = 0.02,
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
    maxIrr = {99.99999999999999, 99.99999999999999, 99.99999999999999, 99.99999999999999},
    shadingFactor = {1.0, 1.0, 1.0, 1.0},
    withAHU = false,
    minAHU = 0.3,
    maxAHU = 0.6,
    hHeat = 4473.482346425267,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = false,
    hCool = 0,
    lCool = -4473.482346425267,
    heaLoadFacOut = 134.33381091345322,
    heaLoadFacGrd = 24.971485313537734,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false,
    withIdealThresholds = false,
    TThresholdHeater = 288.15,
    TThresholdCooler = 295.15);
end Case_1_SingleDwelling;
