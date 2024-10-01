within BESMod.Systems.Demand.Building.RecordsCollection.TABULA;
record B1859_retrofit_SingleDwelling "B1859_retrofit_SingleDwelling"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 547.5,
    AZone = 219.0,
    hRad = 4.999999999999999,
    lat = 0.88645272708792,
    nOrientations = 4,
    AWin = {7.199625, 7.199625, 7.199625, 7.199625},
    ATransparent = {7.199625, 7.199625, 7.199625, 7.199625},
    hConWin = 2.6999999999999997,
    RWin = 0.015799433998298522,
    gWin = 0.6,
    UWin= 1.6003325366309882,
    ratioWinConRad = 0.02,
    AExt = {42.447675, 42.447675, 42.447675, 42.447675},
    hConExt = 2.7,
    nExt = 1,
    RExt = {0.009233993964388523},
    RExtRem = 0.006400353174357467,
    CExt = {12174215.889660235},
    AInt = 675.25,
    hConInt = 2.3756756756756765,
    nInt = 1,
    RInt = {0.00010117129978751481},
    CInt = {104000464.27416456},
    AFloor = 85.4976,
    hConFloor = 1.7,
    nFloor = 1,
    RFloor = {0.003148024293651912},
    RFloorRem =  0.020916077730120393,
    CFloor = {5616921.559813438},
    ARoof = 134.24699999999999,
    hConRoof = 1.7,
    nRoof = 1,
    RRoof = {0.00040423271915635884},
    RRoofRem = 0.019150543685733216,
    CRoof = {2568650.356129808},
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
    hConRoofOut = 19.999999999999996,
    hRadRoof = 4.999999999999999,
    tiltExtWalls = {1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966},
    aziExtWalls = {0.0, 1.5707963267948966, -1.5707963267948966, 3.141592653589793},
    wfWall = {0.25, 0.25, 0.25, 0.25},
    wfWin = {0.25, 0.25, 0.25, 0.25},
    wfGro = 0.0,
    specificPeople = 0.0182648401826484,
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
    hHeat = 6415.16916878181,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = false,
    hCool = 0,
    lCool = -6415.16916878181,
    heaLoadFacOut = 191.9985765735018,
    heaLoadFacGrd = 38.744959775678986,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false,
    withIdealThresholds = false,
    TThresholdHeater = 288.15,
    TThresholdCooler = 295.15);
end B1859_retrofit_SingleDwelling;