

within ReferenceSystem.RefAachen.RefAachen_DataBase;
record RefAachen_SingleDwelling "RefAachen_SingleDwelling"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 483.48248,
    AZone = 185.9548,
    hRad = 5.0,
    lat = 0.88645272708792,
    nOrientations = 4,
    AWin = {5.8110875, 5.8110875, 5.8110875, 5.8110875},
    ATransparent = {5.8110875, 5.8110875, 5.8110875, 5.8110875},
    hConWin = 2.7000000000000006,
    RWin = 0.002691326689491584,
    gWin = 0.75,
    UWin= 4.3024026404355675,
    ratioWinConRad = 0.02,
    AExt = {34.3086606, 34.3086606, 34.3086606, 34.3086606},
    hConExt = 2.7,
    nExt = 1,
    RExt = {0.001332595824711231},
    RExtRem = 0.006737464601063045 ,
    CExt = {32499722.35688769},
    AInt = 588.8568666666666,
    hConInt = 2.3842105263157896,
    nInt = 1,
    RInt = {0.00010788423601446622},
    CInt = {64378588.44158663},
    AFloor = 71.7785528,
    hConFloor = 1.7,
    nFloor = 1,
    RFloor = {0.0016577040206218277},
    RFloorRem =  0.01687778140569836,
    CFloor = {8495823.491787305},
    ARoof = 86.779526516,
    hConRoof = 1.7,
    nRoof = 1,
    RRoof = {0.0005741060549569836},
    RRoofRem = 0.020270021702313734,
    CRoof = {1624811.2523896664},
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
    maxIrr = {100.0, 100.0, 100.0, 100.0},
    shadingFactor = {1.0, 1.0, 1.0, 1.0},
    withAHU = false,
    minAHU = 0.3,
    maxAHU = 0.6,
    hHeat = 9444.071194320331,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = false,
    hCool = 0,
    lCool = -9444.071194320331,
    heaLoadFacOut = 284.51594183137587,
    heaLoadFacGrd = 48.508722245186235,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false,
    withIdealThresholds = false,
    TThresholdHeater = 288.15,
    TThresholdCooler = 295.15);
end RefAachen_SingleDwelling;
