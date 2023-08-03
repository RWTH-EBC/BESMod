within BESMod.Examples;
model GasBoilerBuildingOnly
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare BESMod.Systems.Demand.Building.TEASERThermalZone building(
        hBui=sum(building.zoneParam.VAir)^(1/3),
        ABui=sum(building.zoneParam.VAir)^(2/3),
        redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam(heaLoadFacGrd=0, heaLoadFacOut=0)),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare BESMod.Systems.Hydraulical.Generation.GasBoiler generation(
        dTTra_nominal={10},
        redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW
          paramBoiler,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum),
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
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters)),
    redeclare BESMod.Systems.Demand.DHW.DHW DHW(
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough calcmFlow),
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare BESMod.Systems.RecordsCollection.ExampleSystemParameters
      systemParameters(
      QBui_flow_nominal={12820},
      THydSup_nominal={338.15},
      use_ventilation=false,
      use_dhw=false,
      use_elecHeating=false));

  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=31536000,
      Interval=900.00288,
      __Dymola_Algorithm="Dassl"));
end GasBoilerBuildingOnly;
