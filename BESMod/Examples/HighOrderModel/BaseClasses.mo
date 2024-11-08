within BESMod.Examples.HighOrderModel;
package BaseClasses
  partial model PartialBES_HOM
    extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
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

    annotation (experiment(StopTime=172800,
       Interval=600,
       Tolerance=1e-06),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HighOrderModel/BES_HOM.mos"
          "Simulate and plot"));
  end PartialBES_HOM;
end BaseClasses;
