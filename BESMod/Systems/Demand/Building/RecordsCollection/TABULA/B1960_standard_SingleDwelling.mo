within BESMod.Systems.Demand.Building.RecordsCollection.TABULA;
record B1960_standard_SingleDwelling "B1960_standard_SingleDwelling"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 302.5,
    AZone = 121.0,
    hRad = 4.999999999999999,
    lat = 0.88645272708792,
    nOrientations = 4,
    AWin = {6.776, 6.776, 6.776, 6.776},
    ATransparent = {6.776, 6.776, 6.776, 6.776},
    hConWin = 2.7000000000000006,
    RWin = 0.0069046213526733,
    gWin = 0.75,
    UWin= 2.8010185522008006,
    ratioWinConRad = 0.02,
    AExt = {37.479749999999996, 37.479749999999996, 37.479749999999996, 37.479749999999996},
    hConExt = 2.700000000000001,
    nExt = 1,
    RExt = {0.0007642133834660376},
    RExtRem = 0.003723513931215582,
    CExt = {30867535.05522987},
    AInt = 373.08333333333337,
    hConInt = 2.3756756756756756,
    nInt = 1,
    RInt = {0.00018745340394042914},
    CInt = {50108076.320227064},
    AFloor = 115.797,
    hConFloor = 1.6999999999999997,
    nFloor = 1,
    RFloor = {0.000974252852073266},
    RFloorRem =  0.004139044164991941,
    CFloor = {14692659.202720912},
    ARoof = 168.916,
    hConRoof = 1.7,
    nRoof = 1,
    RRoof = {0.00027420347202903255},
    RRoofRem = 0.005601598742105336,
    CRoof = {3075139.723318416},
    nOrientationsRoof = 2,
    tiltRoof = {0.6108652381980153, 0.6108652381980153},
    aziRoof = {3.141592653589793, -1.5707963267948966},
    wfRoof = {0.5, 0.5},
    aRoof = 0.5,
    aExt = 0.5,
    TSoil = 286.15,
    hConWallOut = 20.0,
    hRadWall = 5.0,
    hConWinOut = 19.999999999999996,
    hConRoofOut = 20.0,
    hRadRoof = 5.0,
    tiltExtWalls = {1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966},
    aziExtWalls = {0.0, 1.5707963267948966, -1.5707963267948966, 3.141592653589793},
    wfWall = {0.25000000000000006, 0.25000000000000006, 0.25000000000000006, 0.25000000000000006},
    wfWin = {0.25, 0.25, 0.25, 0.25},
    wfGro = 0.0,
    specificPeople = 0.03305785123966942,
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
    hHeat = 14452.454546292447,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = false,
    hCool = 0,
    lCool = -14452.454546292447,
    heaLoadFacOut = 417.4713836351744,
    heaLoadFacGrd = 156.1957528524095,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false,
    withIdealThresholds = false,
    TThresholdHeater = 288.15,
    TThresholdCooler = 295.15);
end B1960_standard_SingleDwelling;
