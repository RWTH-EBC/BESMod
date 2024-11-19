within BESMod.Examples.HighOrderModel;
model BES_HOM
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.AixLibHighOrder building(
      energyDynamicsWalls=Modelica.Fluid.Types.Dynamics.FixedInitial,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      useConstVentRate=false,
      TimeCorrection=0,
      DiffWeatherDataTime=Modelica.Units.Conversions.to_hour(weaDat.timZon),
      redeclare AixLib.DataBase.Walls.Collections.OFD.EnEV2009Heavy wallTypes,
      redeclare model WindowModel =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.WindowSimple,
      redeclare AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2009
        Type_Win,
      redeclare model CorrSolarGainWin =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorGSimple,
      redeclare BESMod.Systems.Demand.Building.Components.AixLibHighOrderOFD
        HOMBuiEnv),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        TBiv=parameterStudy.TBiv,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D
            (y_nominal=0.8, redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableDataSDF.TableData3D.VCLibPy.VCLibVaporInjectionPhaseSeparatorPropane
              datTab),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen),
      redeclare BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoDHW(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal),
      redeclare BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra)),
    redeclare BESMod.Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles userProfiles(
        redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
        redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile),
    redeclare HOMSystem systemParameters,
    redeclare DesignOptimization.ParametersToChange parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  extends Modelica.Icons.Example;
  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HighOrderModel/BES_HOM.mos"
        "Simulate and plot"), Documentation(info="<html>
  <h4>Information</h4>
  <p>High order building energy system model extending <a href=\"modelica://BESMod.Systems.BaseClasses.PartialBuildingEnergySystem\">BESMod.Systems.BaseClasses.PartialBuildingEnergySystem</a>. The model consists of an electrical, building, control, hydraulic, DHW and ventilation system.</p>

  <p>The building is modeled using AixLib high order approach with EnEV2009 heavy walls and simple window model. The hydraulic system features a heat pump with electric heater backup in a monoenergetic configuration, two storage tanks in parallel (buffer and DHW), and radiator heating system.</p>

</html>"));
end BES_HOM;
