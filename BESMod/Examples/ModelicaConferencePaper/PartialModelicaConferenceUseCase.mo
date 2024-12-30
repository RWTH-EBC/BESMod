within BESMod.Examples.ModelicaConferencePaper;
partial model PartialModelicaConferenceUseCase
  "Partial model to be extended to replace single subsystems"
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.ElectricalSystem electrical(
      redeclare Systems.Electrical.Distribution.BatterySystemSimple
        distribution(redeclare
          BuildingSystems.Technologies.ElectricalStorages.Data.LithiumIon.LithiumIonTeslaPowerwall1
          batteryParameters),
      redeclare BESMod.Systems.Electrical.Generation.PVSystemMultiSub
        generation(
        redeclare model CellTemperature =
            AixLib.Electrical.PVSystem.BaseClasses.CellTemperatureMountingContactToGround,
        redeclare AixLib.DataBase.SolarElectric.SchuecoSPV170SME1 pVParameters,
        lat=weaDat.lat,
        lon=weaDat.lon,
        alt=weaDat.alt,
        timZon=weaDat.timZon,
        ARoo=building.ARoo/2),
      redeclare BESMod.Systems.Electrical.Transfer.NoElectricalTransfer
        transfer,
      redeclare BESMod.Systems.Electrical.Control.NoControl control),
    redeclare BESMod.Systems.Control.DHWSuperheating control(TSetDHW=
          systemParameters.TSetDHW),
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        dTTra_nominal={10},
        redeclare package Medium_eva = AixLib.Media.Air),
        redeclare package MediumEva = AixLib.Media.Air,
        TBiv=271.15,
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
        supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Internal,
        redeclare model DHWHysteresis =

          BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare model BuildingHysteresis =

          BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum),
      redeclare Systems.Hydraulical.Distribution.SimpleTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoDHW(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal,
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoBuf(dTLoadingHC1=0)),
      redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
        dTTra_nominal=fill(10, hydraulic.transfer.nParallelDem),
        f_design=fill(1.2, hydraulic.transfer.nParallelDem),
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad));
    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare final BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM
        DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPum,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow), Error;
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy, Error, Error, Error, Error, Error;
        redeclare
          BESMod.Systems.Ventilation.Generation.RecordsCollection.DummyHeatExchangerRecovery
          parameters, Error, Error, Error, Error, Error;
      redeclare BESMod.Systems.Ventilation.Distribution.SimpleDistribution
        distribution(m_flow_nominal=building.AZone .* building.hZone .* 0.5 ./
            3600 .* 1.225), Error;


end PartialModelicaConferenceUseCase;
