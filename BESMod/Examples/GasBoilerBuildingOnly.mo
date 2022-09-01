within BESMod.Examples;
model GasBoilerBuildingOnly
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.TEASERThermalZone
      building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0)),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Ventilation.NoVentilation
      ventilation,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem
      hydraulic(
      redeclare BESMod.Systems.Hydraulical.Generation.GasBoiler generation(
        dTTra_nominal={10},
        redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW
          paramBoiler,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          temperatureSensorData,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData),

      redeclare BESMod.Systems.Hydraulical.Control.MonovalentGasBoiler control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          thermostaticValveController,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
          thermostaticValveParameters,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
          HP_nSet_Controller,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
          monovalentControlParas),
      redeclare BESMod.Systems.Hydraulical.Distribution.BuildingOnly
        distribution(nParallelDem=1),
      redeclare BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
        transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          transferDataBaseDefinition,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,

        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters)),
    redeclare BESMod.Systems.Demand.DHW.DHW DHW(
      use_pressure=true,                        redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData, redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare
        BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough
        calcmFlow),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles
      userProfiles,
    redeclare
      BESMod.Examples.MyOwnHeatingRodEfficiencyStudy.SimpleStudyOfHeatingRodEfficiency
      parameterStudy,
    redeclare
      BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      THydSup_nominal={328.15},                  use_ventilation=false,
      use_dhw=false,
      use_elecHeating=false));
  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=86400,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end GasBoilerBuildingOnly;