within BESMod.Utilities.TimeConstantEstimation.BaseClasses;
partial model PartialEstimation "Partial model for estimation of time constants"
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Examples.DesignOptimization.AachenSystem systemParameters(
        QBui_flow_nominal=building.QRec_flow_nominal, TSetDHW=293.15),
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      ARoo=sum(building.zoneParam.ARoof),
      redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam(useConstantACHrate=true),
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ABui=sum(building.zoneParam.VAir)^(2/3),
      ventRate={0.3},
      T_start=293.15 - dTStepSet),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(redeclare
        BESMod.Systems.Hydraulical.Generation.ElectricalHeater generation(
        dTTra_nominal={max(hydraulic.transfer.dTTra_nominal)},
        f_design={2},
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
          parEleHea,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum),
        redeclare
        BESMod.Utilities.TimeConstantEstimation.BaseClasses.TimeConstantEstimationControl
        control),
    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.NoDHW DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare
      BESMod.Utilities.TimeConstantEstimation.BaseClasses.ProfilesWithStep
      userProfiles(dTStep=dTStepSet, startTime=startTimeTSet),
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation,
    weaDat(
      TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
      TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
      TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.Input,
      relHumSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      relHum=0,
      winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      winSpe=0,
      HInfHorSou=if use_solGai then IBPSA.BoundaryConditions.Types.DataSource.File else IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      HInfHor=0,
      HSou=if use_solGai then IBPSA.BoundaryConditions.Types.RadiationDataSource.File else IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor));

  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.TemperatureDifference dTStepSet=2
    "Temperature difference of step";
  parameter Modelica.Units.SI.TemperatureDifference dTStepOda=2
    "Temperature difference of step";
  parameter Modelica.Units.SI.Temperature TOda_start=systemParameters.TSetZone_nominal[1] annotation (Evaluate=false);
  parameter Modelica.Units.SI.Time startTimeTOda=Modelica.Constants.inf
    "Start time outdoor temperature step";
  parameter Modelica.Units.SI.Time startTimeTSet=86400*2
    "Start time of step in TSetZone";
  parameter Boolean use_solGai = false "=true to activate solar gains from weather file";

  Modelica.Blocks.Sources.Constant consNultIrr(each final k=0) "No irradiation"
    annotation (Placement(transformation(extent={{-320,18},{-298,40}})));
  Modelica.Blocks.Sources.Step     consNultIrr1(
    height=-dTStepOda,               offset=TOda_start,
    startTime=startTimeTOda)                                   "No irradiation"
    annotation (Placement(transformation(extent={{-322,82},{-300,104}})));

initial equation
  building.thermalZone[1].ROM.extWallRC.thermCapExt[1].T = building.T_start;
  building.thermalZone[1].ROM.floorRC.thermCapExt[1].T = building.T_start;
  building.thermalZone[1].ROM.intWallRC.thermCapInt[1].T = building.T_start;
  building.thermalZone[1].ROM.roofRC.thermCapExt[1].T = building.T_start;
equation
  connect(consNultIrr.y, weaDat.HGloHor_in) annotation (Line(points={{-296.9,29},{
          -292.45,29},{-292.45,31},{-283,31}}, color={0,0,127}));
  connect(consNultIrr.y, weaDat.HDifHor_in) annotation (Line(points={{-296.9,29},{
          -288.45,29},{-288.45,41.5},{-283,41.5}}, color={0,0,127}));
  connect(consNultIrr1.y, weaDat.TDewPoi_in) annotation (Line(points={{-298.9,93},
          {-298.9,90},{-283,90},{-283,103.6}}, color={0,0,127}));
  connect(consNultIrr1.y, weaDat.TDryBul_in) annotation (Line(points={{-298.9,93},
          {-291.45,93},{-291.45,97},{-283,97}}, color={0,0,127}));
  connect(consNultIrr1.y, weaDat.TBlaSky_in) annotation (Line(points={{-298.9,93},
          {-291.45,93},{-291.45,91},{-283,91}}, color={0,0,127}));

end PartialEstimation;
