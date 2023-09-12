within BESMod.Systems.Demand.Building.HeatDemand;
model SpawnHeatDemand_Tconst_Qconst_RestConst_EplusVar
  parameter Integer nZones = 11;
  extends Modelica.Icons.Example;
  extends PartialCalcHeatingDemand(
    KR_heater=10000,
    redeclare BESMod.Examples.UseCaseHighOrderModel.HOMSystem systemParameters(
      nZones=11,
      QBui_flow_nominal={1124.867,569.6307,53.59064,679.86365,809.8547,786.87427,
          552.7661,10,666.1303,635.3303,0},
      TOda_nominal=261.15,
      TSetZone_nominal(displayUnit="K") = {293.15,293.15,293.15,293.15,293.15,
        293.15,293.15,293.15,293.15,293.15,0},
      THydSup_nominal(displayUnit="K"),
      filNamWea=Modelica.Utilities.Files.loadResource(
          "D:/Programme/AixWeather/results/Aachen_Tconst_Qconst_RestConst_EplusVar.mos")),
    redeclare BESMod.Systems.Demand.Building.SpawnHOM building(use_openModelica=
         false,
      nZones=nZones,
      idf_name=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Data/ThermalZones/EnergyPlus_9_6_0/HOM/ExampleHOM_BESMod_Density_V960_NoIG_Orientation270_WindowDoor.idf"),
      epw_name=Modelica.Utilities.Files.loadResource(
          "D:/Programme/AixWeather/results/Aachen_Tconst_Qconst_RestConst_EplusVar.epw"),

      wea_name=Modelica.Utilities.Files.loadResource(
          "D:/Programme/AixWeather/results/Aachen_Tconst_Qconst_RestConst_EplusVar.mos")),
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles heaDemSce(
      redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
        redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile,
      gain=0),
    h_heater={100000,100000,100000,100000,100000,100000,100000,100000,100000,
        100000,100000},
    heaterCooler(each Heater_on=true),
    weaDat(
      computeWetBulbTemperature=true,
      TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      winDirSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter));

  Modelica.Blocks.Continuous.Integrator integrator[building.nZones]
    annotation (Placement(transformation(extent={{6,-80},{26,-60}})));
  Modelica.Blocks.Interfaces.RealOutput QBui[building.nZones]
    annotation (Placement(transformation(extent={{100,-42},{120,-22}})));
  Modelica.Blocks.Sources.RealExpression realExpSumQ(y=sum(QBui))
    annotation (Placement(transformation(extent={{48,-72},{68,-52}})));
  Modelica.Blocks.Interfaces.RealOutput QBui_Sum
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
equation
  connect(heaterCooler.heatingPower, integrator.u) annotation (Line(points={{
          -40,-12},{-26,-12},{-26,-48},{-2,-48},{-2,-70},{4,-70}}, color={0,0,
          127}));
  connect(integrator.y, QBui) annotation (Line(points={{27,-70},{96,-70},{96,
          -32},{110,-32}}, color={0,0,127}));
  connect(realExpSumQ.y, QBui_Sum) annotation (Line(points={{69,-62},{94,-62},{
          94,-50},{110,-50}}, color={0,0,127}));
  annotation (experiment(
      StopTime=31536000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SpawnHeatDemand_Tconst_Qconst_RestConst_EplusVar;
