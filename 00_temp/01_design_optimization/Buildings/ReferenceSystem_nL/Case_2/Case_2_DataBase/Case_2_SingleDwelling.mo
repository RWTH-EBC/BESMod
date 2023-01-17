

within ReferenceSystem_nL.Case_2.Case_2_DataBase;
record Case_2_SingleDwelling "Case_2_SingleDwelling"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 390.625,
    AZone = 156.25,
    hRad = 5.000000000000001,
    lat = 0.88645272708792,
    nOrientations = 4,
    AWin = {4.8828125, 4.8828125, 4.8828125, 4.8828125},
    ATransparent = {4.8828125, 4.8828125, 4.8828125, 4.8828125},
    hConWin = 2.7,
    RWin = 0.003202976744186046,
    gWin = 0.75,
    UWin= 4.302402640435568,
    ratioWinConRad = 0.02,
    AExt = {28.828125, 28.828125, 28.828125, 28.828125},
    hConExt = 2.7,
    nExt = 1,
    RExt = {0.0015859365764160764},
    RExtRem = 0.008018328847345654 ,
    CExt = {27308150.250833534},
    AInt = 481.7708333333333,
    hConInt = 2.375675675675676,
    nInt = 1,
    RInt = {0.00013015347323843437},
    CInt = {53342685.29149853},
    AFloor = 60.3125,
    hConFloor = 1.7000000000000002,
    nFloor = 1,
    RFloor = {0.0019728513255291382},
    RFloorRem =  0.02008642858073828,
    CFloor = {7138683.274600965},
    ARoof = 72.9171875,
    hConRoof = 1.7,
    nRoof = 1,
    RRoof = {0.0006832497704212155},
    RRoofRem = 0.024123570122556226,
    CRoof = {1365260.5804522675},
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
    hHeat = 7900.6642834489085,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = false,
    hCool = 0,
    lCool = -7900.6642834489085,
    heaLoadFacOut = 237.9795439100343,
    heaLoadFacGrd = 40.75983976111587,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false,
    withIdealThresholds = false,
    TThresholdHeater = 288.15,
    TThresholdCooler = 295.15);
end Case_2_SingleDwelling;
