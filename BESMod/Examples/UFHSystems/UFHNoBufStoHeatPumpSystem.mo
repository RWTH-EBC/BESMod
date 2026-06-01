within BESMod.Examples.UFHSystems;
model UFHNoBufStoHeatPumpSystem
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Demand.DHW.StandardProfiles DHW(redeclare
        BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough calcmFlow,
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.NoDHW DHWProfile),
  redeclare BESMod.Examples.UFHSystems.Haus43a_kfw40_iwu building,
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare BESMod.Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D
            (redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableDataSDF.TableData3D.VCLibPy.VCLibStandardPropane
              datTab),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea),
      redeclare
        BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystemNoBuffer
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        delayGenOn=60,
        redeclare model DHWSetTemperature =
            BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW,

        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,

        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.PumpController.ConstantSpeed
          pumGenCtrl),
      redeclare BESMod.Systems.Hydraulical.Distribution.DirectBuildingWithDHW
        distribution(
        dpBufHCSto_design=0,
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal,
        redeclare BESMod.Systems.RecordsCollection.Movers.SpeedControlled
          parPumGen,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoDHW),
      redeclare
        BESMod.Systems.Hydraulical.Transfer.UFHTransferSystemPressureBasedNormBased
        transfer(redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData_NormBased
          UFHParameters, dis=10)),
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      QBui_flow_nominal=building.QRec_flow_nominal,
      THydSup_nominal=fill(308.15, systemParameters.nZones),
      use_ventilation=false,
      use_elecHeating=false));

   extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=30000000,
      Interval=900,
      __Dymola_Algorithm="Dassl"));
end UFHNoBufStoHeatPumpSystem;
