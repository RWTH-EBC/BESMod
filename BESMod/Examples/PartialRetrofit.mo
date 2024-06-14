within BESMod.Examples;
package PartialRetrofit
extends Modelica.Icons.ExamplesPackage;
  model Case1NoRetrofit
    extends PartialCase(building(redeclare
          BESMod.Examples.PartialRetrofit.Buildings.Case_1_standard
          oneZoneParam), systemParameters(
        QBui_flow_nominal={15300},
        TOda_nominal=263.15,
        THydSup_nominal={338.15}));
    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=86400,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end Case1NoRetrofit;

  model Case1TotalRetrofit
    extends PartialCase(building(redeclare
          BESMod.Examples.PartialRetrofit.Buildings.Case_1_retrofit
          oneZoneParam), systemParameters(
        QBui_flow_nominal={5300},
        TOda_nominal=263.15,
        THydSup_nominal={318.15}));
    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=86400,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end Case1TotalRetrofit;

  model Case1PartialRetrofit
    extends PartialCase(
      NoRetrofitHydGen=true,
      NoRetrofitHydDis=false,
      NoRetrofitHydTra=false,
      building(redeclare
          BESMod.Examples.PartialRetrofit.Buildings.Case_1_retrofit
          oneZoneParam),
      systemParameters(
        QBui_flow_nominal={5300},
        TOda_nominal=263.15,
        THydSup_nominal={318.15},
        QBuiOld_flow_design={15300},
        THydSupOld_design={338.15}));
    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=86400,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end Case1PartialRetrofit;

  partial model PartialCase
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(
        redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
          oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0),
        hBui=sum(building.zoneParam.VAir)^(1/3),
        ABui=sum(building.zoneParam.VAir)^(2/3)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
          generation(
          use_old_design={NoRetrofitHydGen},
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
          redeclare package Medium_eva = AixLib.Media.Air,
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
            parHeaPum(
            genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
            TBiv=TBiv,
            scalingFactor=hydraulic.generation.parHeaPum.QPri_flow_nominal/5000,
            dpCon_nominal=0,
            dpEva_nominal=0,
            use_refIne=false,
            refIneFre_constant=0),
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
            parEleHea,
          redeclare model PerDataMainHP =
              AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
              QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,
              refrigerant="Propane",
              flowsheet="VIPhaseSeparatorFlowsheet"),
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen),
        redeclare Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem
          control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            valCtrl,
          dTHysBui=10,
          dTHysDHW=10,
          redeclare model DHWHysteresis =
              BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
          redeclare model BuildingHysteresis =
              BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
            parPIDHeaPum,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
            safetyControl),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedDirectLoading
          distribution(
          use_old_design={NoRetrofitHydDis},
          QHeaAftBuf_flow_nominal=0,
          redeclare
            BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
            parTemSen,
          redeclare
            BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            parThrWayVal,
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
            parStoBuf(use_QLos=true, T_m=338.15),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
            parStoDHW(
            dTLoadingHC1=10,
            use_QLos=true,
            T_m=65 + 273.15),
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
            parEleHeaAftBuf),
        redeclare BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
          transfer(
          use_oldRadDesign={NoRetrofitHydTra},
          redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
            parRad,
          redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
            parTra,
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum)),
      redeclare Systems.Demand.DHW.StandardProfiles DHW(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
          calcmFlow),
      redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
      redeclare BESParameters systemParameters,
      redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
        parameterStudy,
      redeclare final package MediumDHW = AixLib.Media.Water,
      redeclare final package MediumZone = AixLib.Media.Air,
      redeclare final package MediumHyd = AixLib.Media.Water,
      redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

    parameter Modelica.Units.SI.Temperature TBiv=271.15
      "Nominal bivalence temperature. = TOda_nominal for monovalent systems.";
    parameter Boolean NoRetrofitHydTra = false
      "If true, hydraulic transfersystem uses QBuiNoRetrofit.";
    parameter Boolean NoRetrofitHydDis = false
      "If true, hydraulic distribution system uses QBuiNoRetrofit.";
    parameter Boolean NoRetrofitHydGen = false
      "If true, hydraulic generation system uses QBuiNoRetrofit.";
    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end PartialCase;

  record BESParameters
    extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
      use_elecHeating=false,
      final filNamWea=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/TRY2015_522361130393_Jahr_City_Potsdam.mos"),
      final TAmbVen=min(TSetZone_nominal),
      final TAmbHyd=min(TSetZone_nominal),
      final TDHWWaterCold=283.15,
      final TSetDHW=328.15,
      final TVenSup_nominal=TSetZone_nominal,
      final TSetZone_nominal=fill(293.15, nZones),
      final nZones=1,
      final use_ventilation=false);

  end BESParameters;

  package Buildings
    record Case_1_retrofit "Case_1_retrofit_SingleDwelling"
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
        RExtRem = 0.020216675755004247,
        CExt = {100421538.7287612},
        AInt = 430.6183333333333,
        hConInt = 2.375675675675676,
        nInt = 1,
        RInt = {0.00015864610234473541},
        CInt = {66322853.1531042},
        AFloor = 77.008524,
        hConFloor = 1.7,
        nFloor = 1,
        RFloor = {0.0017094806036435206},
        RFloorRem =  0.03639477492651585,
        CFloor = {3229375.807286302},
        ARoof = 81.7011,
        hConRoof = 1.7,
        nRoof = 1,
        RRoof = {0.0006642141886533201},
        RRoofRem = 0.031467177775802616,
        CRoof = {1563249.5296817843},
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
        KRCool = 10000,
        TNCool = 1,
        CoolerOn = false,
        withIdealThresholds = false,
        TThresholdHeater = 288.15,
        TThresholdCooler = 295.15,
        heaLoadFacGrd=0,
        heaLoadFacOut=0);
    end Case_1_retrofit;

    record Case_1_standard "Case_1_standard_SingleDwelling"
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
        RWin = 0.008534961482565809,
        gWin = 0.75,
        UWin= 2.8010185522008,
        ratioWinConRad = 0.02,
        AExt = {47.69389, 47.69389, 47.69389, 47.69389},
        hConExt = 2.7000000000000006,
        nExt = 1,
        RExt = {0.0003600881127135614},
        RExtRem = 0.0018061646320222994,
        CExt = {67578368.85812245},
        AInt = 430.6183333333333,
        hConInt = 2.375675675675676,
        nInt = 1,
        RInt = {0.00015864610234473541},
        CInt = {66322853.1531042},
        AFloor = 77.008524,
        hConFloor = 1.7,
        nFloor = 1,
        RFloor = {0.001711324798876134},
        RFloorRem =  0.006462275327484408,
        CFloor = {4991626.335096046},
        ARoof = 81.7011,
        hConRoof = 1.7,
        nRoof = 1,
        RRoof = {0.0014751297291351348},
        RRoofRem = 0.005282800406622357,
        CRoof = {5823412.447090039},
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
        hHeat = 17426.160522476486,
        lHeat = 0,
        KRHeat = 10000,
        TNHeat = 1,
        HeaterOn = false,
        hCool = 0,
        lCool = -17426.160522476486,
        KRCool = 10000,
        TNCool = 1,
        CoolerOn = false,
        withIdealThresholds = false,
        TThresholdHeater = 288.15,
        TThresholdCooler = 295.15,
        heaLoadFacGrd=0,
        heaLoadFacOut=0);
    end Case_1_standard;

    record Case_2_retrofit "Case_2_retrofit_SingleDwelling"
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
        RWin = 0.03068061538461538,
        gWin = 0.6,
        UWin= 1.3002195175808904,
        ratioWinConRad = 0.02,
        AExt = {28.828125, 28.828125, 28.828125, 28.828125},
        hConExt = 2.7,
        nExt = 1,
        RExt = {0.002635720568811437},
        RExtRem = 0.0391791526753142,
        CExt = {34205984.307940625},
        AInt = 481.7708333333333,
        hConInt = 2.375675675675676,
        nInt = 1,
        RInt = {0.00013015347323843435},
        CInt = {53342685.29149853},
        AFloor = 60.3125,
        hConFloor = 1.7000000000000002,
        nFloor = 1,
        RFloor = {0.007240378276725048},
        RFloorRem =  0.05271675507143726,
        CFloor = {4264027.844552503},
        ARoof = 72.9171875,
        hConRoof = 1.7,
        nRoof = 1,
        RRoof = {0.0007442282362931753},
        RRoofRem = 0.03525784696754283,
        CRoof = {1395180.2248083546},
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
        hHeat = 3362.8545215039794,
        lHeat = 0,
        KRHeat = 10000,
        TNHeat = 1,
        HeaterOn = false,
        hCool = 0,
        lCool = -3362.8545215039794,
        KRCool = 10000,
        TNCool = 1,
        CoolerOn = false,
        withIdealThresholds = false,
        TThresholdHeater = 288.15,
        TThresholdCooler = 295.15,
        heaLoadFacGrd=0,
        heaLoadFacOut=0);
    end Case_2_retrofit;

    record Case_2_standard "Case_2_standard_SingleDwelling"
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
        RExtRem = 0.008018328847345654,
        CExt = {27308150.250833534},
        AInt = 481.7708333333333,
        hConInt = 2.375675675675676,
        nInt = 1,
        RInt = {0.00013015347323843435},
        CInt = {53342685.29149853},
        AFloor = 60.3125,
        hConFloor = 1.7000000000000002,
        nFloor = 1,
        RFloor = {0.0019728513255291387},
        RFloorRem =  0.02008642858073828,
        CFloor = {7138683.274600956},
        ARoof = 72.9171875,
        hConRoof = 1.7,
        nRoof = 1,
        RRoof = {0.0006832497704212157},
        RRoofRem = 0.024123570122556226,
        CRoof = {1365260.5804523209},
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
        KRCool = 10000,
        TNCool = 1,
        CoolerOn = false,
        withIdealThresholds = false,
        TThresholdHeater = 288.15,
        TThresholdCooler = 295.15,
        heaLoadFacGrd=0,
        heaLoadFacOut=0);
    end Case_2_standard;
  end Buildings;
end PartialRetrofit;
