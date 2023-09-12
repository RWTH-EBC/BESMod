within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeatDemHOM_Tconst_Qconst_RestConst_EplusConst
  "Calculate the heat demand for a high order model from AixLib library"
  extends Modelica.Icons.Example;
  parameter Integer TIR=2 "Thermal Insulation Regulation" annotation (Dialog(
      group="Construction parameters",
      compact=true,
      descriptionLabel=true), choices(
      choice=1 "EnEV_2009",
      choice=2 "EnEV_2002",
      choice=3 "WSchV_1995",
      choice=4 "WSchV_1984",
      radioButtons=true));

  extends PartialCalcHeatingDemand(
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles heaDemSce(
        redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
        redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile,
      gain=0),
    TN_heater=1,
    KR_heater=10000,
    h_heater=fill(100000, building.nZones),
    redeclare Examples.UseCaseHighOrderModel.HOMSystem systemParameters(
      nZones=10,
      QBui_flow_nominal={1124.867,569.6307,53.59064,679.86365,809.8547,
          786.87427,552.7661,10,666.1303,635.3303},
      TOda_nominal=261.15,
      TSetZone_nominal(each displayUnit="K") = fill(293.15, building.nZones),
      THydSup_nominal=fill(273.15 + 55, building.nZones),
      filNamWea=Modelica.Utilities.Files.loadResource(
          "D:/Programme/AixWeather/results/Aachen_Tconst_Qconst_RestConst_EplusConst.mos")),
    redeclare AixLibHighOrder building(
      solar_absorptance_OW=0.7,
      calcMethodOut=1,
      TIR=2,
      useConstVentRate=true,
      ventRate={0.5,0.5,0,0.5,0.5,0.5,0.5,0,0.5,0.5},
      TSoil=286.15,
      DiffWeatherDataTime=Modelica.Units.Conversions.to_hour(weaDat.timZon),
      GroundReflection=0.2,
      T0_air=293.15,
      TWalls_start=292.15,
      redeclare AixLib.DataBase.Walls.Collections.OFD.EnEV2002Medium wallTypes,
      redeclare model WindowModel =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.WindowSimple,
      redeclare AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2002
        Type_Win(frameFraction=0, g=0.7),
      redeclare model CorrSolarGainWin =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorGSimple,
      use_sunblind=false,
      UValOutDoors=if TIR == 1 then 1.8 else 2.9,
      use_infiltEN12831=false,
      n50=if TIR == 1 or TIR == 2 then 3 else if TIR == 3 then 4 else 6,
      HOMBuiEnv(
        radLongCalcMethod=1,
        solar_absorptance_OW=0.7,
        TIR=2,
        wholeHouseBuildingEnvelope(
          solar_absorptance_OW=0.7,
          AirExchangeCorridor=0,
          solar_absorptance_RO=0.7,
          groundFloor_Building(
            windowarea_11=3.24,
            windowarea_12=1.08,
            windowarea_22=1.08,
            windowarea_41=1.08,
            windowarea_51=2.16,
            windowarea_52=1.08,
            door_height_31=2.145,
            door_width_42=1.01,
            door_height_42=2.145),
          upperFloor_Building(
            room_width_long=3.92,
            room_width_short=3.9,
            room_height_long=2.6,
            room_height_short=2.58,
            roof_width=0.0283,
            windowarea_62=1.08,
            windowarea_63=0,
            windowarea_72=1.08,
            windowarea_73=0,
            windowarea_92=1.08,
            windowarea_102=1.08,
            windowarea_103=0,
            Bedroom(withWindow3=false),
            Children1(withWindow3=false),
            Children2(withWindow3=false)),
          attic_2Ro_5Rooms(roof_width1=6.26, roof_width2=6.26))),
      RadOnTiltedSurf(WeatherFormat=2)),
    heaterCooler(each Heater_on=true),
    weaDat(
      computeWetBulbTemperature=true,
      pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
      relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
      ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
      opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File));

  Modelica.Blocks.Continuous.Integrator integrator[building.nZones]
    annotation (Placement(transformation(extent={{18,-84},{38,-64}})));
  Modelica.Blocks.Interfaces.RealOutput QBui[building.nZones]
    annotation (Placement(transformation(extent={{100,-32},{120,-12}})));
  Modelica.Blocks.Sources.RealExpression realExpSumQ(y=sum(QBui))
    annotation (Placement(transformation(extent={{48,-70},{68,-50}})));
  Modelica.Blocks.Interfaces.RealOutput QBui_Sum
    annotation (Placement(transformation(extent={{98,-68},{118,-48}})));
equation
  connect(heaterCooler.heatingPower, integrator.u) annotation (Line(points={{
          -40,-12},{-26,-12},{-26,-48},{10,-48},{10,-74},{16,-74}}, color={0,0,
          127}));
  connect(integrator.y, QBui) annotation (Line(points={{39,-74},{72,-74},{72,
          -50},{96,-50},{96,-22},{110,-22}}, color={0,0,127}));
  connect(realExpSumQ.y, QBui_Sum) annotation (Line(points={{69,-60},{94,-60},{
          94,-58},{108,-58}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>In order to use this model, choose a number of zones and pass a zoneParam from TEASER for every zone. Further specify the nominal heat outdoor air temperature in the system parameters or pass your custom systemParameters record.</p>
</html>"), experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"));
end CalcHeatDemHOM_Tconst_Qconst_RestConst_EplusConst;
