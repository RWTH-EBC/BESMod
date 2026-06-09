within BESMod.Examples.UFHSystems;
model PartialConstSupplyUFH
  "partial test for ufh under nominal conditions"
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Examples.DesignOptimization.AachenSystem systemParameters(
        QBui_flow_nominal=building.QRec_flow_nominal,
      THydSup_nominal={308.15},
      TSetDHW=293.15,
      use_dhw=false),
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare replaceable BESMod.Examples.UFHSystems.Haus43a_kfw40_iwu building(
        zoneParam={BESMod.Examples.UFHSystems.Haus43a_kfw40_iwu_DataBase.Haus43a_kfw40_iwu_SingleDwelling(
        useConstantACHrate=true,
          baseACH=0.5,
          AFloor=0)}, energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
      redeclare BESMod.Systems.Hydraulical.Generation.ElectricalHeater
        generation(
        dTTra_nominal={max(hydraulic.transfer.dTTra_nominal)},
        f_design={1},
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea),
      redeclare
        BESMod.Utilities.TimeConstantEstimation.BaseClasses.TimeConstantEstimationControl
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.DynamicOpeningTest
          valCtrl,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicBoilerPI
          parPID(yMin=0),
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.Constant
          supTSet),
      redeclare replaceable
        BESMod.Systems.Hydraulical.Distribution.BuildingOnly distribution(
          redeclare BESMod.Systems.RecordsCollection.Movers.SpeedControlled
          parPum(use_riseTime=true)),
      redeclare replaceable
        BESMod.Systems.Hydraulical.Transfer.UFHTransferSystemPressureBasedNormBased
        transfer(
        f_design={1.15},
                 redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData_NormBased
          UFHParameters, dis=5)),
    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.NoDHW DHWProfile,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles userProfiles(
      gain={0,0,0}),
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
      HInfHorSou=if use_solGai then IBPSA.BoundaryConditions.Types.DataSource.File
           else IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      HInfHor=0,
      HSou=if use_solGai then IBPSA.BoundaryConditions.Types.RadiationDataSource.File
           else IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor));


  parameter Boolean use_solGai = false "=true to activate solar gains from weather file";

  Modelica.Blocks.Sources.Constant consNultIrr(each final k=0) "No irradiation"
    annotation (Placement(transformation(extent={{-320,18},{-298,40}})));

  Modelica.Blocks.Sources.Constant consNultIrr1(each final k=systemParameters.TOda_nominal)
                                                               "No irradiation"
    annotation (Placement(transformation(extent={{-322,68},{-300,90}})));

equation
  connect(consNultIrr.y, weaDat.HGloHor_in) annotation (Line(points={{-296.9,29},{
          -292.45,29},{-292.45,31},{-283,31}}, color={0,0,127}));
  connect(consNultIrr.y, weaDat.HDifHor_in) annotation (Line(points={{-296.9,29},{
          -288.45,29},{-288.45,41.5},{-283,41.5}}, color={0,0,127}));

  connect(consNultIrr1.y, weaDat.TDewPoi_in) annotation (Line(points={{-298.9,79},
          {-298.9,78},{-292,78},{-292,103.6},{-283,103.6}}, color={0,0,127}));
  connect(consNultIrr1.y, weaDat.TDryBul_in) annotation (Line(points={{-298.9,79},
          {-298.9,78},{-292,78},{-292,97},{-283,97}}, color={0,0,127}));
  connect(consNultIrr1.y, weaDat.TBlaSky_in) annotation (Line(points={{-298.9,79},
          {-298.9,78},{-292,78},{-292,91},{-283,91}}, color={0,0,127}));
  annotation (experiment(
      StopTime=20000000,
      Interval=900,
      __Dymola_Algorithm="Dassl"));
end PartialConstSupplyUFH;
